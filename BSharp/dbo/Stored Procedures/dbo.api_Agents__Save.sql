CREATE PROCEDURE [dbo].[api_Agents__Save]
	@Agents [AgentList] READONLY
AS
	DECLARE @IdMappings IdMappingList;

	DELETE FROM dbo.Custodies WHERE Id IN (SELECT Id FROM @Agents WHERE Status = N'Deleted');

	INSERT INTO @IdMappings([NewId], [OldId])
	SELECT x.[NewId], x.[OldId]
	FROM
	(
		MERGE INTO dbo.Custodies AS t
		USING (
			SELECT [Id], [AgentType], [Name], [IsActive] 
			FROM @Agents 
			WHERE [Status] IN (N'Inserted', N'Updated')
		) AS s ON t.Id = s.Id
		WHEN MATCHED THEN
			UPDATE SET 
				t.[Name] = s.[Name],
				t.[IsActive] = s.[IsActive]
		WHEN NOT MATCHED THEN
			INSERT ([CustodyType], [Name], [IsActive])
			VALUES (s.[AgentType], s.[Name], s.[IsActive])
		--WHEN NOT MATCHED BY SOURCE THEN 
		--	DELETE
		OUTPUT inserted.[Id] As [NewId], s.[Id] As [OldId]
	) AS x;

	MERGE INTO dbo.Agents t
	USING (
		SELECT M.[NewId] As [Id], [AgentType], [IsRelated] , [UserId], [TaxIdentificationNumber], [RegisteredAddress], [Title], [Gender], [BirthDateTime]
		FROM @Agents I 
		JOIN @IdMappings M ON I.Id = M.OldId
	) As s ON t.Id = s.Id
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
		INSERT ([Id], [AgentType]	,	[IsRelated] ,	[UserId],	[TaxIdentificationNumber],	[RegisteredAddress], [Title], [Gender], [BirthDateTime])
		VALUES (s.[Id], s.[AgentType], s.[IsRelated], s.[UserId], s.[TaxIdentificationNumber], s.[RegisteredAddress], s.[Title], s.[Gender], s.[BirthDateTime]);

		--WHEN NOT MATCHED BY SOURCE THEN 
		--	DELETE

--INSERT INTO @AgentsLocal([Id], [Name], [IsActive], [CustodyType], [IsRelated] , [UserId], [TaxIdentificationNumber], [RegisteredAddress], [Title], [Gender], [BirthDateTime])
SELECT C.[Id], A.[AgentType], C.[Name], C.[IsActive], A.[IsRelated], A.[UserId], A.[TaxIdentificationNumber], A.[RegisteredAddress], A.[Title], A.[Gender], A.[BirthDateTime], N'Unchanged' As [Status], M.[OldId] As [TemporaryId]
FROM dbo.Custodies C JOIN dbo.Agents A ON C.Id = A.Id
LEFT JOIN @IdMappings M ON C.[Id] = M.[NewId]
WHERE C.[Id] IN (
	SELECT M.[NewId] FROM @Agents A JOIN @IdMappings M ON A.Id = M.OldId WHERE [Status] = N'Inserted'
	UNION ALL
	SELECT Id FROM @Agents WHERE [Status] = N'Updated');