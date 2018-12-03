CREATE PROCEDURE [dbo].[api_Agents__Save]
	@Agents [AgentList] READONLY
AS
BEGIN
	DECLARE @IdMappings IdMappingList, @TenantId int, @msg nvarchar(2048);
	SELECT @TenantId = dbo.fn_TenantId();
	IF @TenantId IS NULL
	BEGIN
		SELECT @msg = FORMATMESSAGE(dbo.fn_Translate('NullTenantId')); 
		THROW 50001, @msg, 1;
	END

	DELETE FROM dbo.Custodies WHERE TenantId = @TenantId AND Id IN (SELECT Id FROM @Agents WHERE Status = N'Deleted');

	INSERT INTO @IdMappings([Index], [Id])
	SELECT x.[NewId], x.[OldId]
	FROM
	(
		MERGE INTO dbo.Custodies AS t
		USING (
			SELECT @TenantId As [TenantId], [Id], [AgentType], [Name], [IsActive] 
			FROM @Agents 
			WHERE [Status] IN (N'Inserted', N'Updated')
		) AS s ON t.[TenantId] = s.[TenantId] AND t.Id = s.Id
		WHEN MATCHED THEN
			UPDATE SET 
				t.[Name] = s.[Name],
				t.[IsActive] = s.[IsActive]
		WHEN NOT MATCHED THEN
			INSERT ([TenantId], [CustodyType], [Name], [IsActive])
			VALUES (@TenantId, s.[AgentType], s.[Name], s.[IsActive])
		OUTPUT inserted.[Id] As [NewId], s.[Id] As [OldId]
	) AS x;

	MERGE INTO dbo.Agents t
	USING (-- was using M.OldId, had to make it Id to allow it to compile
		SELECT @TenantId As [TenantId], M.[Id], [AgentType], [IsRelated] , [UserId], [TaxIdentificationNumber], [RegisteredAddress], [Title], [Gender], [BirthDateTime]
		FROM @Agents I 
		JOIN @IdMappings M ON I.Id = M.Id -- TODO Was M.OldId, had to change it to allow compilation
	) AS s ON t.[TenantId] = s.[TenantId] AND t.Id = s.Id
	WHEN MATCHED THEN
		UPDATE SET
			t.[Id]						= s.[Id],
			t.[IsRelated]				= s.[IsRelated],
			t.[UserId]					= s.[UserId],
			t.[TaxIdentificationNumber] = s.[TaxIdentificationNumber],
			t.[RegisteredAddress]		= s.[RegisteredAddress],
			t.[Title]					= s.[Title],
			t.[Gender]					= s.[Gender],
			t.[BirthDateTime]			= s.[BirthDateTime]
	WHEN NOT MATCHED THEN
		INSERT ([TenantId], [Id], [AgentType]	,	[IsRelated] ,	[UserId],	[TaxIdentificationNumber],	[RegisteredAddress], [Title], [Gender], [BirthDateTime])
		VALUES (@TenantId, s.[Id], s.[AgentType], s.[IsRelated], s.[UserId], s.[TaxIdentificationNumber], s.[RegisteredAddress], s.[Title], s.[Gender], s.[BirthDateTime]);
	
END