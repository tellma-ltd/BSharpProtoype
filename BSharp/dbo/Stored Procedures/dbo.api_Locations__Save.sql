CREATE PROCEDURE [dbo].[api_Locations__Save]
	@Locations [LocationList] READONLY
AS
BEGIN
	DECLARE @IdMappings IdMappingList, @TenantId int, @msg nvarchar(2048);
	SELECT @TenantId = dbo.fn_TenantId();
	IF @TenantId IS NULL
	BEGIN
		SELECT @msg = FORMATMESSAGE(dbo.fn_Translate('NullTenantId')); 
		THROW 50001, @msg, 1;
	END
	DELETE FROM dbo.Custodies WHERE TenantId = @TenantId
	AND Id IN (SELECT Id FROM @Locations WHERE Status = N'Deleted');

	INSERT INTO @IdMappings([NewId], [OldId])
	SELECT x.[NewId], x.[OldId]
	FROM
	(
		MERGE INTO dbo.Custodies AS t
		USING (
			SELECT @TenantId As [TenantId], [Id], [LocationType], [Name], [IsActive] 
			FROM @Locations 
			WHERE [Status] IN (N'Inserted', N'Updated')
		) AS s ON t.[TenantId] = s.[TenantId] AND t.Id = s.Id
		WHEN MATCHED THEN
			UPDATE SET 
				t.[Name] = s.[Name],
				t.[IsActive] = s.[IsActive]
		WHEN NOT MATCHED THEN
			INSERT ([TenantId], [CustodyType], [Name], [IsActive])
			VALUES (@TenantId, s.[LocationType], s.[Name], s.[IsActive])
		--WHEN NOT MATCHED BY SOURCE THEN 
		--	DELETE
		OUTPUT inserted.[Id] As [NewId], s.[Id] As [OldId]
	) AS x;

	MERGE INTO dbo.Locations t
	USING (
		SELECT @TenantId As [TenantId], M.[NewId] As [Id], [LocationType], [Address], [ParentId], [CustodianId]
		FROM @Locations I 
		JOIN @IdMappings M ON I.Id = M.OldId
	) AS s ON t.[TenantId] = s.[TenantId] AND t.Id = s.Id
	WHEN MATCHED THEN
		UPDATE SET
			t.[Id]						= s.[Id],
			t.[Address]					= s.[Address],
			t.[ParentId]					= s.[ParentId],      
			t.[CustodianId]				= s.[CustodianId]
	WHEN NOT MATCHED THEN
		INSERT ([TenantId], [Id], [LocationType],	[Address] ,	[ParentId],	[CustodianId])
		VALUES (@TenantId, s.[Id], s.[LocationType], s.[Address], s.[ParentId], s.[CustodianId]);

	SELECT C.[Id], L.[LocationType], C.[Name], C.[IsActive], L.[Address], L.[ParentId], L.[CustodianId], N'Unchanged' As Status, M.[OldId] As [TemporaryId]
	FROM dbo.Custodies C
	JOIN dbo.Locations L ON C.[TenantId] = L.[TenantId] AND C.Id = L.Id  
	LEFT JOIN @IdMappings M ON C.[Id] = M.[NewId]
	WHERE C.[Id] IN (
		SELECT M.[NewId] FROM @Locations L JOIN @IdMappings M ON L.Id = M.OldId WHERE [Status] = N'Inserted'
		UNION ALL
		SELECT Id FROM @Locations WHERE [Status] = N'Updated');
END