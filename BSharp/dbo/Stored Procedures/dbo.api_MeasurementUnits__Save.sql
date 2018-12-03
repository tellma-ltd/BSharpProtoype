CREATE PROCEDURE [dbo].[api_MeasurementUnits__Save]
	@MeasurementUnits [MeasurementUnitList] READONLY
AS
BEGIN
	DECLARE @IdMappings IdMappingList, @TenantId int, @msg nvarchar(2048);
	SELECT @TenantId = dbo.fn_TenantId();
	IF @TenantId IS NULL
	BEGIN
		SELECT @msg = FORMATMESSAGE(dbo.fn_Translate('NullTenantId')); 
		THROW 50001, @msg, 1;
	END

	DELETE FROM dbo.MeasurementUnits
	WHERE Id IN (SELECT Id FROM @MeasurementUnits WHERE Status = N'Deleted');

	MERGE INTO dbo.MeasurementUnits AS t
	USING (
		SELECT @TenantId As [TenantId], [Id], [Code], [UnitType], [Name], [UnitAmount], [BaseAmount], [IsActive]
		FROM @MeasurementUnits 
		WHERE [Status] = (N'Updated')
	) AS s ON t.Id = s.Id
	WHEN MATCHED THEN
		UPDATE SET 
			t.[Code] = s.[Code],
			t.[UnitType] = s.[UnitType],
			t.[Name] = s.[Name],
			t.[UnitAmount] = s.[UnitAmount],
			t.[BaseAmount] = s.[BaseAmount];

	INSERT INTO @IdMappings([Index], [Id])
	SELECT x.[Index], x.[Id]
	FROM
	(
		MERGE INTO dbo.MeasurementUnits AS t
		USING (
			SELECT NULL AS [Id], [Code], [UnitType], [Name], [UnitAmount], [BaseAmount], [IsActive], [Index]
			FROM @MeasurementUnits
			WHERE [Status] = (N'Inserted') -- Equiv. to WHERE [Id] IS NULL
		) AS s ON t.Id = s.Id
		WHEN NOT MATCHED THEN
			INSERT ([TenantId], [Code], [UnitType], [Name], [UnitAmount], [BaseAmount], [IsActive])
			VALUES (@TenantId, s.[Code], s.[UnitType], s.[Name], s.[UnitAmount], s.[BaseAmount], s.[IsActive])
		OUTPUT s.[Index] AS [Index], inserted.[Id] 
	) AS x;

	SELECT [Index], [Id] FROM @IdMappings;
END;