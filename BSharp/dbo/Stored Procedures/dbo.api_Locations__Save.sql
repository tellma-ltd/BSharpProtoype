CREATE PROCEDURE [dbo].[api_Locations__Save]
	@Locations [LocationList] READONLY
AS
BEGIN
	DECLARE @IndexedIds [IndexedIdList], @TenantId int, @msg nvarchar(2048);
	SELECT @TenantId = [dbo].fn_TenantId();
	IF @TenantId IS NULL
	BEGIN
		SELECT @msg = FORMATMESSAGE([dbo].fn_Translate('NullTenantId')); 
		THROW 50001, @msg, 1;
	END
	DELETE FROM [dbo].Custodies WHERE TenantId = @TenantId
	AND Id IN (SELECT Id FROM @Locations WHERE [EntityState] = N'Deleted');

	INSERT INTO @IndexedIds([Index], [Id])
	SELECT x.[NewId], x.[OldId]
	FROM
	(
		MERGE INTO [dbo].Custodies AS t
		USING (
			SELECT @TenantId As [TenantId], [Id], [LocationType], [Name], [IsActive] 
			FROM @Locations 
			WHERE [EntityState] IN (N'Inserted', N'Updated')
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

	MERGE INTO [dbo].Locations t
	USING (
		SELECT @TenantId As [TenantId], M.[Id], [LocationType], [Address], [ParentId], [CustodianId]
		FROM @Locations I 
		JOIN @IndexedIds M ON I.Id = M.Id -- TODO Was M.OldId, had to change it to allow compilation
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
END