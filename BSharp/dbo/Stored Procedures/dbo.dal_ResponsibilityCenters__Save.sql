CREATE PROCEDURE [dbo].[dal_ResponsibilityCenters__Save]
	@Entities [OperationList] READONLY,
	@IndexedIdsJson NVARCHAR(MAX) OUTPUT
AS
SET NOCOUNT ON;
	DECLARE @IndexedIds [dbo].[IndexedIdList];
	DECLARE @TenantId int = CONVERT(INT, SESSION_CONTEXT(N'TenantId'));
	DECLARE @Now DATETIMEOFFSET(7) = SYSDATETIMEOFFSET();
	DECLARE @UserId INT = CONVERT(INT, SESSION_CONTEXT(N'UserId'));

-- Deletions, if already user, we should deactivate instead
	DELETE FROM [dbo].[ResponsibilityCenters]
	WHERE [Id] IN (SELECT [Id] FROM @Entities WHERE [EntityState] = N'Deleted');

	INSERT INTO @IndexedIds([Index], [Id])
	SELECT x.[Index], x.[Id]
	FROM
	(
		MERGE INTO [dbo].[ResponsibilityCenters] AS t
		USING (
			SELECT [Index], [Id], [Code], [Name], [Name2], [ParentId], [ProductCategoryId], [GeographicRegionId], [CustomerSegmentId], [FunctionId]
			FROM @Entities 
			WHERE [EntityState] IN (N'Inserted', N'Updated')
		) AS s ON (t.Id = s.Id)
		WHEN MATCHED 
		THEN
			UPDATE SET 
				t.[Name]			= s.[Name],
				t.[Name2]			= s.[Name2],
				t.[ParentId]		= s.[ParentId],
				t.[Code]			= s.[Code],
				t.[ProductCategoryId] = s.[ProductCategoryId],
				t.[GeographicRegionId] = s.[GeographicRegionId],
				t.[CustomerSegmentId] = s.[CustomerSegmentId],
				t.[ModifiedAt]		= @Now,
				t.[ModifiedById]	= @UserId
		WHEN NOT MATCHED THEN
			INSERT ([TenantId], [Name],		[Name2], [Code], [ProductCategoryId], [GeographicRegionId], [CustomerSegmentId], [CreatedAt], [CreatedById], [ModifiedAt], [ModifiedById])
			VALUES (@TenantId, s.[Name], s.[Name2], s.[Code], s.[ProductCategoryId], s.[GeographicRegionId], s.[CustomerSegmentId],  @Now,			@UserId,	@Now,			@UserId)
			OUTPUT s.[Index], inserted.[Id] 
	) As x

	UPDATE BE
	SET BE.[ParentId]= T.[ParentId]
	FROM [dbo].[ResponsibilityCenters] BE
	JOIN (
		SELECT II.[Id], IIParent.[Id] As ParentId
		FROM @Entities O
		JOIN @IndexedIds IIParent ON IIParent.[Index] = O.ParentIndex
		JOIN @IndexedIds II ON II.[Index] = O.[Index]
	) T ON BE.Id = T.[Id]

	SELECT @IndexedIdsJson = (SELECT * FROM @IndexedIds FOR JSON PATH);