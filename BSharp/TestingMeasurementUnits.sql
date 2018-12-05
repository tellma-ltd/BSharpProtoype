BEGIN -- Cleanup & Declarations
	DECLARE @MU1 [dbo].MeasurementUnitForSaveList, @MU2 [dbo].MeasurementUnitForSaveList;
	DECLARE @AED int, @Dozen int, @Kg int;
END
BEGIN -- Inserting
	INSERT INTO @MU1 ([Code], [UnitType], [Name], [UnitAmount], [BaseAmount]) VALUES
		('AED', N'Money', N'AE Dirhams', 3.67, 1),
		(N'd', N'Time', N'Day', 1, 86400),
		(N'dozen', N'Count', N'Dozen', 1, 12),
		(N'ea', N'Pure', N'Each', 1, 1),
		(N'ETB', N'Money', N'ET Birr', 27.8, 1),
		(N'g', N'Mass', N'Gram', 1, 1),
		(N'hr', N'Time', N'Hour', 1, 3600),
		(N'in', N'Distance', N'inch', 1, 2.541),
		(N'kg', N'Mass', N'Kilogram', 1, 1000),
		(N'ltr', N'Volume', N'Liter', 1, 1),
		(N'm', N'Distance', N'meter', 1, 1),
		(N'min', N'Time', N'minute', 1, 60),
		(N'mo', N'Time', N'Month', 1, 2592000),
		(N'mt', N'Mass', N'Metric ton', 1, 1000000),
		(N'pcs', N'Count', N'Pieces', 1, 1),
		(N's', N'Time', N'second', 1, 1),
		(N'share', N'Pure', N'Shares', 1, 1),
		(N'USD', N'Money', N'US Dollars', 1, 1),
		(N'usg', N'Volume', N'US Gallon', 1, 3.785411784),
		(N'wd', N'Time', N'work day', 1, 8),
		(N'wk', N'Time', N'week', 1, 604800),
		(N'wmo', N'Time', N'work month', 1, 1248),
		(N'wwk', N'Time', N'work week', 1, 48),
		(N'wyr', N'Time', N'work year', 1, 14976),
		(N'yr', N'Time', N'Year', 1, 31104000);

	EXEC  [dbo].[api_MeasurementUnits__Save]
		@MeasurementUnits = @MU1,
		@ValidationErrorsJson = @ValidationErrorsJson OUTPUT,
		@IndexedIdsJson = @IndexedIdsJson OUTPUT

	IF @ValidationErrorsJson IS NOT NULL 
	BEGIN
		Print 'MeasurementUnits: Location 1'
		GOTO Err_Label;
	END

	DELETE FROM @IndexedIds;
	INSERT INTO @IndexedIds
	SELECT * FROM OpenJson(@IndexedIdsJson)
	WITH ([Index] INT '$.Index', [Id] INT '$.Id');

	DELETE FROM @MU1 WHERE [EntityState] IN ('Deleted');

	UPDATE T 
	SET T.[Id] = II.[Id], T.[EntityState] = N'Unchanged'
	FROM @MU1 T 
	JOIN @IndexedIds II ON T.[Index] = II.[Index];
END

-- Display units whose code starts with m
INSERT INTO @MU2 ([Id], [Code], [UnitType], [Name], [UnitAmount], [BaseAmount], [EntityState])
SELECT [Id], [Code], [UnitType], [Name], [UnitAmount], [BaseAmount], N'Unchanged'
FROM dbo.MeasurementUnits
WHERE [Code] Like 'm%';

-- Inserting
	INSERT INTO @MU2
		([Code], [UnitType], [Name], [UnitAmount], [BaseAmount]) Values
		(N'AED', N'Money', N'AE Dirhams', 3.67, 1),
		(N'c', N'Time', N'Century', 1, 3110400000),
		(N'dozen', N'Count', N'Dazzina', 1, 12);
-- Updating
	UPDATE @MU2 
	SET 
		[Code] = N'pcs',
		[Name] = N'Metric Ton',
		[EntityState] = N'Updated'
	WHERE [Code] = N'mt';

-- Deleting
	UPDATE @MU2 
	SET 
		[EntityState] = N'Deleted'
	WHERE [Code] = N'min';-- Deleting the minute

-- Calling Save API
	EXEC  [dbo].[api_MeasurementUnits__Save]
		@MeasurementUnits = @MU2,
		@ValidationErrorsJson = @ValidationErrorsJson OUTPUT,
		@IndexedIdsJson = @IndexedIdsJson OUTPUT

	IF @ValidationErrorsJson IS NOT NULL
	BEGIN
		Print 'MeasurementUnits: Location 2'
		GOTO Err_Label;
	END
		
	DELETE FROM @IndexedIds;
	INSERT INTO @IndexedIds
	SELECT * FROM OpenJson(@IndexedIdsJson)
	WITH ([Index] INT '$.Index', [Id] INT '$.Id');
		
	DELETE FROM @MU2 WHERE [EntityState] IN ('Deleted');
	UPDATE MU 
	SET MU.[Id] = IM.[Id], [EntityState] = N'Unchanged'
	FROM @MU2 MU 
	JOIN @IndexedIds IM ON MU.[Index] = IM.[Index];
