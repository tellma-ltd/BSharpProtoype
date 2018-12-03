CREATE PROCEDURE [dbo].[api_Operations__Save]
	@Operations [OperationList] READONLY
AS
BEGIN
	DECLARE @IdMappings IdMappingList, @TenantId int, @msg nvarchar(2048);
	SELECT @TenantId = dbo.fn_TenantId();
	IF @TenantId IS NULL
	BEGIN
		SELECT @msg = FORMATMESSAGE(dbo.fn_Translate('NullTenantId')); 
		THROW 50001, @msg, 1;
	END
	DELETE FROM dbo.Operations WHERE TenantId = @TenantId AND Id IN (SELECT Id FROM @Operations WHERE Status = N'Deleted');

	INSERT INTO @IdMappings([Index], [Id])
	SELECT x.[NewId], x.[OldId]
	FROM
	(
		MERGE INTO dbo.Operations AS t
		USING (
			SELECT @TenantId As [TenantId], [Id], [OperationType], [Name], [ParentId]
			FROM @Operations 
			WHERE [Status] IN (N'Inserted', N'Updated')
		) AS s ON t.[TenantId] = s.[TenantId] AND t.Id = s.Id
		WHEN MATCHED THEN
			UPDATE SET 
				t.[OperationType] = s.[OperationType],
				t.[Name] = s.[Name],
				t.[ParentId] = s.[ParentId]
		WHEN NOT MATCHED THEN
			INSERT ([TenantId], [OperationType], [Name])
			VALUES (@TenantId, s.[OperationType], s.[Name])
		--WHEN NOT MATCHED BY SOURCE THEN 
		--	DELETE
		OUTPUT inserted.[Id] As [NewId], s.[Id] As [OldId]
	) AS x;
	PRINT N'Parent Id in table Operations is lost. Additional code is needed to fix it. Will be fixed once we agree it is necessary'
	/*
	UPDATE O
	SET O.[ParentId] = 
	FROM dbo.Operations O 
	JOIN @Operations OL ON O.Id = OL.Parent
	JOIN @IdMappings M ON OL.Id = M.OldId
	JOIN dbo.Operations O2 ON M.NewId = O2.Id
	*/
END;