CREATE PROCEDURE [dbo].[dal_Agents__Save]
	@Agents [AgentForSaveList] READONLY,
	@IndexedIdsJson  NVARCHAR(MAX) OUTPUT
AS
	DECLARE @IndexedIds [IndexedIdList];
	DECLARE @TenantId int = [dbo].fn_TenantId();

-- Deletions
	DELETE FROM [dbo].Custodies
	WHERE Id IN (SELECT Id FROM @Agents WHERE [EntityState] = N'Deleted');

-- Updates
	MERGE INTO [dbo].Custodies AS t
	USING (
		SELECT [Id], [AgentType], [Name], [Code]
		FROM @Agents 
		WHERE [EntityState] = N'Updated'
	) AS s ON (t.Id = s.Id)
	WHEN MATCHED
	AND (	
		t.[Name] <> s.[Name] OR
		ISNULL(t.[Code], N'') <> ISNULL(s.[Code], N'')
	)
	THEN
		UPDATE SET 
			t.[Name] = s.[Name],
			t.[Code] = s.[Code];

	MERGE INTO [dbo].Agents t
	USING (
		SELECT [Id], [AgentType], [IsRelated], [UserId], [TaxIdentificationNumber], [RegisteredAddress], [Title], [Gender], [BirthDateTime]
		FROM @Agents
		WHERE [EntityState] = N'Updated'
	) AS s ON (t.Id = s.Id)
	WHEN MATCHED THEN
		UPDATE SET
			t.[Id]						= s.[Id],
			t.[IsRelated]				= s.[IsRelated],
			t.[UserId]					= s.[UserId],
			t.[TaxIdentificationNumber] = s.[TaxIdentificationNumber],
			t.[RegisteredAddress]		= s.[RegisteredAddress],
			t.[Title]					= s.[Title],
			t.[Gender]					= s.[Gender],
			t.[BirthDateTime]			= s.[BirthDateTime];

-- Inserts
	INSERT INTO @IndexedIds([Index], [Id])
	SELECT x.[Index], x.[Id]
	FROM
	(
		MERGE INTO [dbo].Custodies AS t
		USING (
			SELECT [Index], [Id], [AgentType], [Name], [Code]
			FROM @Agents 
			WHERE [EntityState] = N'Inserted'
		) AS s ON (t.Id = s.Id)
		WHEN NOT MATCHED THEN
			INSERT ([TenantId], [CustodyType], [Name], [Code])
			VALUES (@TenantId, s.[AgentType], s.[Name], s.[Code])
		OUTPUT s.[Index], inserted.[Id] 
	) AS x;

	MERGE INTO [dbo].Agents t
	USING (
		SELECT I.[Id], [AgentType], [IsRelated] , [UserId], [TaxIdentificationNumber], [RegisteredAddress], [Title], [Gender], [BirthDateTime],
				M.[Id] As [InsertedId]
		FROM @Agents I 
		JOIN @IndexedIds M ON I.[Index] = M.[Index]
		WHERE [EntityState] = N'Inserted'
	) AS s ON (t.Id = s.Id)
	WHEN NOT MATCHED THEN
		INSERT ([TenantId], [Id],			[AgentType],	[IsRelated],	[UserId],	[TaxIdentificationNumber],	[RegisteredAddress], [Title], [Gender], [BirthDateTime])
		VALUES (@TenantId, s.[InsertedId], s.[AgentType], s.[IsRelated], s.[UserId], s.[TaxIdentificationNumber], s.[RegisteredAddress], s.[Title], s.[Gender], s.[BirthDateTime]);
	
	SELECT @IndexedIdsJson =
	(
		SELECT [Index], [Id] FROM @IndexedIds
		FOR JSON AUTO
	);