CREATE PROCEDURE [dbo].[dal_Agents__Save]
	@Entities [AgentList] READONLY,
	@IndexedIdsJson NVARCHAR(MAX) OUTPUT
AS
	DECLARE @IndexedIds [dbo].[IndexedIdList];
	DECLARE @TenantId int = CONVERT(INT, SESSION_CONTEXT(N'TenantId'));
	DECLARE @Now DATETIMEOFFSET(7) = SYSDATETIMEOFFSET();
	DECLARE @UserId INT = CONVERT(INT, SESSION_CONTEXT(N'UserId'));

-- Deletions
	DELETE FROM [dbo].[Custodies]
	WHERE [Id] IN (SELECT [Id] FROM @Entities WHERE [EntityState] = N'Deleted');

	INSERT INTO @IndexedIds([Index], [Id])
	SELECT x.[Index], x.[Id]
	FROM
	(
		MERGE INTO [dbo].[Custodies] AS t
		USING (
			SELECT [Index], [Id], [AgentType], [Name], [Name2], [Code], [Address], [BirthDateTime], [IsRelated], [TaxIdentificationNumber], [Title], [Gender]
			FROM @Entities 
			WHERE [EntityState] IN (N'Inserted', N'Updated')
		) AS s ON (t.Id = s.Id)
		WHEN MATCHED
		THEN
			UPDATE SET 
				t.[Name]			= s.[Name],
				t.[Name2]			= s.[Name2],
				t.[Code]			= s.[Code],
				t.[Address]			= s.[Address],
				t.[BirthDateTime]	= s.[BirthDateTime],

				t.[IsRelated]		= s.[IsRelated],
				t.[TaxIdentificationNumber] = s.[TaxIdentificationNumber],
				t.[Title]			= s.[Title],
				t.[Gender]			= s.[Gender],

				t.[ModifiedAt]		= @Now,
				t.[ModifiedBy]		= @UserId
		WHEN NOT MATCHED THEN
			INSERT ([TenantId], [CustodyType], [AgentType], [Name], [Name2], [Code], [Address], [BirthDateTime], [IsRelated], [TaxIdentificationNumber], [Title], [Gender], [CreatedAt], [CreatedBy], [ModifiedAt], [ModifiedBy])
			VALUES (@TenantId, N'Agent',	s.[AgentType], s.[Name], s.[Name2], s.[Code], s.[Address], s.[BirthDateTime], s.[IsRelated], s.[TaxIdentificationNumber], s.[Title], s.[Gender], @Now, @UserId, @Now, @UserId)
		OUTPUT s.[Index], inserted.[Id] 
	) AS x;
	
	SELECT @IndexedIdsJson = (SELECT * FROM @IndexedIds	FOR JSON PATH);