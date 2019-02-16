CREATE PROCEDURE [dbo].[dal_Accounts__Save]
	@Entities [AccountList] READONLY,
	@IndexedIdsJson NVARCHAR(MAX) OUTPUT
AS
SET NOCOUNT ON;
	DECLARE @IndexedIds [dbo].[IndexedIdList];
	DECLARE @TenantId int = CONVERT(INT, SESSION_CONTEXT(N'TenantId'));
	DECLARE @Now DATETIMEOFFSET(7) = SYSDATETIMEOFFSET();
	DECLARE @UserId INT = CONVERT(INT, SESSION_CONTEXT(N'UserId'));

-- Deletions, if already user, we should deactivate instead
	DELETE FROM [dbo].Accounts
	WHERE [Id] IN (SELECT [Id] FROM @Entities WHERE [EntityState] = N'Deleted');

	INSERT INTO @IndexedIds([Index], [Id])
	SELECT x.[Index], x.[Id]
	FROM
	(
		MERGE INTO [dbo].Accounts AS t
		USING (
			SELECT [Index], [Id], [Code], [AccountType], [AccountCategory], [Name], [Name2],
				[IFRSConceptId], [OperationId], [CustodyId], [Reference], [ResourceId], [ParentId] 
			FROM @Entities 
			WHERE [EntityState] IN (N'Inserted', N'Updated')
		) AS s ON (t.Id = s.Id)
		WHEN MATCHED 
		THEN
			UPDATE SET
				t.[Code]			= s.[Code],
				t.[AccountType]		= s.[AccountType],
				t.[AccountCategory] = s.[AccountCategory],
				t.[Name]			= s.[Name],
				t.[Name2]			= s.[Name2],
				t.[IFRSConceptId]	= s.[IFRSConceptId],
				t.[OperationId]		= s.[OperationId],
				t.[CustodyId]		= s.[CustodyId],
				t.[Reference]		= s.[Reference],
				t.[ResourceId]		= s.[ResourceId],
				--t.[ParentId]		= s.[ParentId], reparenting
				t.[ModifiedAt]		= @Now,
				t.[ModifiedById]	= @UserId
		WHEN NOT MATCHED THEN
			INSERT ([TenantId],  [Code], [AccountType], [AccountCategory], [Name], [Name2],
				[IFRSConceptId], [OperationId], [CustodyId], [Reference], [ResourceId], 
				-- [ParentId], reparenting	
				[CreatedAt], [CreatedById], [ModifiedAt], [ModifiedById])
			VALUES (@TenantId, s.[Code], s.[AccountType], s.[AccountCategory], s.[Name], s.[Name2], 
				s.[IFRSConceptId], s.[OperationId], s.[CustodyId], s.[Reference], s.[ResourceId], s.[ParentId],			
				@Now,			@UserId,	@Now,			@UserId)
			OUTPUT s.[Index], inserted.[Id] 
	) As x

	UPDATE BE
	SET BE.[ParentId]= T.[ParentId]
	FROM [dbo].Accounts BE
	JOIN (
		SELECT II.[Id], IIParent.[Id] As ParentId
		FROM @Entities O
		JOIN @IndexedIds IIParent ON IIParent.[Index] = O.ParentIndex
		JOIN @IndexedIds II ON II.[Index] = O.[Index]
	) T ON BE.Id = T.[Id]

	SELECT @IndexedIdsJson = (SELECT * FROM @IndexedIds FOR JSON PATH);