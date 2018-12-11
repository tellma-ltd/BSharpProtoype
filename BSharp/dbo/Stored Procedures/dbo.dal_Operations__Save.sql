CREATE PROCEDURE [dbo].[dal_Operations__Save]
	@Operations [OperationForSaveList] READONLY,
	@IndexedIdsJson  NVARCHAR(MAX) OUTPUT
AS
SET NOCOUNT ON;
	DECLARE @IndexedIds [dbo].[IndexedIdList];
	DECLARE @TenantId int = CONVERT(INT, SESSION_CONTEXT(N'TenantId'));
	DECLARE @Now DATETIMEOFFSET(7) = SYSDATETIMEOFFSET();
	DECLARE @UserId NVARCHAR(450) = CONVERT(NVARCHAR(450), SESSION_CONTEXT(N'UserId'));

-- Deletions
	DELETE FROM [dbo].Operations
	WHERE [Id] IN (SELECT [Id] FROM @Operations WHERE [EntityState] = N'Deleted');

	INSERT INTO @IndexedIds([Index], [Id])
	SELECT x.[Index], x.[Id]
	FROM
	(
		MERGE INTO [dbo].Operations AS t
		USING (
			SELECT [Index], [Id], [Code], [OperationType], [Name], [ParentId]
			FROM @Operations 
			WHERE [EntityState] IN (N'Inserted', N'Updated')
		) AS s ON (t.Id = s.Id)
		WHEN MATCHED 
		THEN
			UPDATE SET 
				t.[OperationType]	= s.[OperationType],
				t.[Name]			= s.[Name],
				t.[ParentId]		= s.[ParentId],
				t.[Code]			= s.[Code],
				t.[ModifiedAt]		= @Now,
				t.[ModifiedBy]		= @UserId
		WHEN NOT MATCHED THEN
				INSERT ([TenantId], [OperationType], [Name], [Code], [CreatedAt], [CreatedBy], [ModifiedAt], [ModifiedBy])
				VALUES (@TenantId, s.[OperationType], s.[Name], s.[Code], @Now, @UserId, @Now, @UserId)
			OUTPUT s.[Index], inserted.[Id] 
	) As x

	UPDATE BE
	SET BE.[ParentId]= T.[ParentId]
	FROM [dbo].Operations BE
	JOIN (
		SELECT II.[Id], IIParent.[Id] As ParentId
		FROM @Operations O
		JOIN @IndexedIds IIParent ON IIParent.[Index] = O.ParentIndex
		JOIN @IndexedIds II ON II.[Index] = O.[Index]
	) T ON BE.Id = T.[Id]

	SELECT @IndexedIdsJson =
	(
		SELECT [Index], [Id] FROM @IndexedIds
		FOR JSON PATH
	);