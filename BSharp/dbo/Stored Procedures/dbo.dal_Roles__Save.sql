CREATE PROCEDURE [dbo].[dal_Roles__Save]
	@Roles [dbo].[RoleList] READONLY, 
	@Permissions [dbo].[PermissionList] READONLY, 
	@IndexedIdsJson NVARCHAR(MAX) OUTPUT
AS
BEGIN
	DECLARE @IndexedIds [dbo].[IndexedIdList], @PermissionsIndexedIds [dbo].[IndexedIdList];
	DECLARE @TenantId int = CONVERT(INT, SESSION_CONTEXT(N'TenantId'));
	DECLARE @Now DATETIMEOFFSET(7) = SYSDATETIMEOFFSET();
	DECLARE @UserId NVARCHAR(450) = CONVERT(NVARCHAR(450), SESSION_CONTEXT(N'UserId'));

	DELETE FROM [dbo].Permissions
	WHERE [Id] IN (SELECT [Id] FROM @Permissions WHERE [EntityState] = N'Deleted');

	INSERT INTO @IndexedIds([Index], [Id])
	SELECT x.[Index], x.[Id]
	FROM
	(
		MERGE INTO [dbo].[Roles] AS t
		USING (
			SELECT 
				[Index], [Id], [Name], [Name2], [IsPublic], [Code]
			FROM @Roles 
			WHERE [EntityState] IN (N'Inserted', N'Updated')
		) AS s ON (t.Id = s.Id)
		WHEN MATCHED 
		THEN
			UPDATE SET
				t.[Name]		= s.[Name],
				t.[Name2]		= s.[Name2],
				t.[IsPublic]	= s.[IsPublic],
				t.[Code]		= s.[Code],
				t.[ModifiedAt]	= @Now,
				t.[ModifiedBy]	= @UserId
		WHEN NOT MATCHED THEN
			INSERT (
				[TenantId], [Name], [Name2],	[IsPublic],		[Code], [CreatedAt], [CreatedBy], [ModifiedAt], [ModifiedBy]
			)
			VALUES (
				@TenantId, s.[Name], s.[Name2], s.[IsPublic], s.[Code], @Now,		@UserId,		@Now,		@UserId
			)
			OUTPUT s.[Index], inserted.[Id] 
	) As x;

	INSERT INTO @PermissionsIndexedIds([Index], [Id])
	SELECT x.[Index], x.[Id]
	FROM
	(
		MERGE INTO [dbo].[Permissions] AS t
		USING (
			SELECT L.[Index], L.[Id], II.[Id] AS [RoleId], [ViewId], [Level], [Criteria], [Memo]
			FROM @Permissions L
			JOIN @IndexedIds II ON L.RoleIndex = II.[Index]
			WHERE L.[EntityState] IN (N'Inserted', N'Updated')
		) AS s ON t.Id = s.Id
		WHEN MATCHED THEN
			UPDATE SET 
				t.[ViewId]		= s.[ViewId], 
				t.[Level]		= s.[Level],
				t.[Criteria]	= s.[Criteria],
				t.[Memo]		= s.[Memo],
				t.[ModifiedAt]	= @Now,
				t.[ModifiedBy]	= @UserId
		WHEN NOT MATCHED THEN
			INSERT ([TenantId], [RoleId],	[ViewId],	[Level],	[Criteria], [Memo], [CreatedAt], [CreatedBy], [ModifiedAt], [ModifiedBy])
			VALUES (@TenantId, s.[RoleId], s.[ViewId], s.[Level], s.[Criteria], s.[Memo], @Now,		@UserId,		@Now,		@UserId)
		OUTPUT s.[Index], inserted.[Id]
	) As x

	SELECT @IndexedIdsJson = (SELECT * FROM @IndexedIds FOR JSON PATH);
END;