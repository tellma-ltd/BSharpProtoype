CREATE PROCEDURE [dbo].[dal_Agents__Save]
	@Agents [AgentForSaveList] READONLY,
	@IndexedIdsJson  NVARCHAR(MAX) OUTPUT
AS
	DECLARE @IndexedIds [dbo].[IndexedIdList];
	DECLARE @TenantId int = CONVERT(INT, SESSION_CONTEXT(N'TenantId'));
	DECLARE @Now DATETIMEOFFSET(7) = SYSDATETIMEOFFSET();
	DECLARE @UserId NVARCHAR(450) = CONVERT(NVARCHAR(450), SESSION_CONTEXT(N'UserId'));

-- Deletions
	DELETE FROM [dbo].Custodies
	WHERE [Id] IN (SELECT [Id] FROM @Agents WHERE [EntityState] = N'Deleted');

	INSERT INTO @IndexedIds([Index], [Id])
	SELECT x.[Index], x.[Id]
	FROM
	(
		MERGE INTO [dbo].Custodies AS t
		USING (
			SELECT [Index], [Id], [AgentType], [Name], [Code], [Address], [BirthDateTime]
			FROM @Agents 
			WHERE [EntityState] IN (N'Inserted', N'Updated')
		) AS s ON (t.Id = s.Id)
		WHEN MATCHED
		THEN
			UPDATE SET 
				t.[Name]			= s.[Name],
				t.[Code]			= s.[Code],
				t.[Address]			= s.[Address],
				t.[BirthDateTime]	= s.[BirthDateTime],
				t.[ModifiedAt]		= @Now,
				t.[ModifiedBy]		= @UserId
		WHEN NOT MATCHED THEN
			INSERT ([TenantId], [CustodyType], [Name], [Code], [Address], [BirthDateTime], [CreatedAt], [CreatedBy], [ModifiedAt], [ModifiedBy])
			VALUES (@TenantId, s.[AgentType], s.[Name], s.[Code], s.[Address], s.[BirthDateTime], @Now, @UserId, @Now, @UserId)
		OUTPUT s.[Index], inserted.[Id] 
	) AS x;

	MERGE INTO [dbo].Agents t
	USING (
		SELECT A.[Id], [AgentType], [IsRelated] , [UserId], [TaxIdentificationNumber], [Title], [Gender],
				II.[Id] As [InsertedId]
		FROM @Agents A
		JOIN @IndexedIds II ON A.[Index] = II.[Index]
		WHERE [EntityState] IN (N'Inserted', N'Updated')
	) AS s ON (t.Id = s.Id)
	WHEN MATCHED THEN
		UPDATE SET
			t.[Id]						= s.[Id],
			t.[IsRelated]				= s.[IsRelated],
			t.[UserId]					= s.[UserId],
			t.[TaxIdentificationNumber] = s.[TaxIdentificationNumber],
			t.[Title]					= s.[Title],
			t.[Gender]					= s.[Gender]
	WHEN NOT MATCHED THEN
		INSERT ([TenantId], [Id],			[AgentType],	[IsRelated],	[UserId],	[TaxIdentificationNumber], [Title], [Gender])
		VALUES (@TenantId, s.[InsertedId], s.[AgentType], s.[IsRelated], s.[UserId], s.[TaxIdentificationNumber], s.[Title], s.[Gender]);
	
	SELECT @IndexedIdsJson =
	(
		SELECT [Index], [Id] FROM @IndexedIds
		FOR JSON PATH
	);