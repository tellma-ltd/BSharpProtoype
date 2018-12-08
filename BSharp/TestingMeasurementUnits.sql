BEGIN -- Cleanup & Declarations
	DECLARE @MU1Save [dbo].MeasurementUnitForSaveList, @MU2Save [dbo].MeasurementUnitForSaveList;
	DECLARE @MU1ResultJson NVARCHAR(MAX), @MU2ResultJson NVARCHAR(MAX);
	DECLARE @AED int, @Dozen int, @Kg int;
END
BEGIN -- Inserting
	INSERT INTO @MU1Save ([Code], [UnitType], [Name], [UnitAmount], [BaseAmount]) VALUES
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
		@MeasurementUnits = @MU1Save,
		@ValidationErrorsJson = @ValidationErrorsJson OUTPUT,
		@MeasurementUnitsResultJson = @MU1ResultJson OUTPUT

	IF @ValidationErrorsJson IS NOT NULL 
	BEGIN
		Print 'MeasurementUnits: Location 1'
		GOTO Err_Label;
	END

	INSERT INTO @MU1Result(
		[Index], [Id], [UnitType], [UnitAmount], [BaseAmount], [Name], [IsActive], [Code],
		[CreatedAt], [CreatedBy], [ModifiedAt], [ModifiedBy], [EntityState]
	)
	SELECT 
		[Index], [Id], [UnitType], [UnitAmount], [BaseAmount], [Name], [IsActive], [Code],
		[CreatedAt], [CreatedBy], [ModifiedAt], [ModifiedBy], [EntityState]
	FROM OpenJson(@MU1ResultJson)
	WITH (
		[Index] INT '$.Index',
		[Id] INT '$.Id',
		[UnitType] NVARCHAR (255) '$.UnitType',
		[UnitAmount] FLOAT (53) '$.UnitAmount',
		[BaseAmount] FLOAT (53) '$.BaseAmount',
		[Name] NVARCHAR (255) '$.Name',
		[IsActive] BIT '$.IsActive',
		[Code] NVARCHAR (255) '$.Code',
		[CreatedAt] DATETIMEOFFSET(7) '$.CreatedAt',
		[CreatedBy] NVARCHAR(450) '$.CreatedBy',
		[ModifiedAt] DATETIMEOFFSET(7) '$.ModifiedAt',
		[ModifiedBy] NVARCHAR(450) '$.ModifiedBy',
		[EntityState] NVARCHAR(255) '$.EntityState'
	);
END

-- Display units whose code starts with m
INSERT INTO @MU2Save ([Id], [Code], [UnitType], [Name], [UnitAmount], [BaseAmount], [EntityState])
SELECT [Id], [Code], [UnitType], [Name], [UnitAmount], [BaseAmount], N'Unchanged'
FROM dbo.MeasurementUnits
WHERE [Code] Like 'm%';

-- Inserting
	INSERT INTO @MU2Save
		([Code], [UnitType], [Name], [UnitAmount], [BaseAmount]) Values
		(N'AED', N'Money', N'AE Dirhams', 3.67, 1),
		(N'c', N'Time', N'Century', 1, 3110400000),
		(N'dozen', N'Count', N'Dazzina', 1, 12);
-- Updating
	UPDATE @MU2Save 
	SET 
		[Code] = N'pcs',
		[Name] = N'Metric Ton',
		[EntityState] = N'Updated'
	WHERE [Code] = N'mt';

-- Deleting
	UPDATE @MU2Save 
	SET 
		[EntityState] = N'Deleted'
	WHERE [Code] = N'min';-- Deleting the minute

-- Calling Save API
	EXEC  [dbo].[api_MeasurementUnits__Save]
		@MeasurementUnits = @MU2Save,
		@ValidationErrorsJson = @ValidationErrorsJson OUTPUT,
		@MeasurementUnitsResultJson = @MU2ResultJson OUTPUT

	IF @ValidationErrorsJson IS NOT NULL
	BEGIN
		Print 'MeasurementUnits: Location 2'
		GOTO Err_Label;
	END

	INSERT INTO @MU2Result(
		[Index], [Id], [UnitType], [UnitAmount], [BaseAmount], [Name], [IsActive], [Code],
		[CreatedAt], [CreatedBy], [ModifiedAt], [ModifiedBy], [EntityState]
	)
	SELECT 
		[Index], [Id], [UnitType], [UnitAmount], [BaseAmount], [Name], [IsActive], [Code],
		[CreatedAt], [CreatedBy], [ModifiedAt], [ModifiedBy], [EntityState]
	FROM OpenJson(@MU2ResultJson)
	WITH (
		[Index] INT '$.Index',
		[Id] INT '$.Id',
		[UnitType] NVARCHAR (255) '$.UnitType',
		[UnitAmount] FLOAT (53) '$.UnitAmount',
		[BaseAmount] FLOAT (53) '$.BaseAmount',
		[Name] NVARCHAR (255) '$.Name',
		[IsActive] BIT '$.IsActive',
		[Code] NVARCHAR (255) '$.Code',
		[CreatedAt] DATETIMEOFFSET(7) '$.CreatedAt',
		[CreatedBy] NVARCHAR(450) '$.CreatedBy',
		[ModifiedAt] DATETIMEOFFSET(7) '$.ModifiedAt',
		[ModifiedBy] NVARCHAR(450) '$.ModifiedBy',
		[EntityState] NVARCHAR(255) '$.EntityState'
	);