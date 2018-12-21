BEGIN -- Cleanup & Declarations
	DECLARE @MU1Result [dbo].MeasurementUnitList, @MU2Result [dbo].MeasurementUnitList;
	DECLARE @MU1Save [dbo].MeasurementUnitForSaveList, @MU2Save [dbo].MeasurementUnitForSaveList;
	DECLARE @MU1ResultJson NVARCHAR(MAX), @MU2ResultJson NVARCHAR(MAX);
END
BEGIN -- Inserting
	INSERT INTO @MU1Save ([Name], [UnitType], [Description], [UnitAmount], [BaseAmount], [Code]) VALUES
		(N'AED', N'Money', N'AE Dirhams', 3.67, 1, N'AED'),
		(N'd', N'Time', N'Day', 1, 86400, NULL),
		(N'dozen', N'Count', N'Dozen', 1, 12, NULL),
		(N'ea', N'Pure', N'Each', 1, 1, NULL),
		(N'ETB', N'Money', N'ET Birr', 27.8, 1, N'ETB'),
		(N'g', N'Mass', N'Gram', 1, 1, NULL),
		(N'hr', N'Time', N'Hour', 1, 3600, NULL),
		(N'in', N'Distance', N'inch', 1, 2.541, NULL),
		(N'kg', N'Mass', N'Kilogram', 1, 1000, NULL),
		(N'ltr', N'Volume', N'Liter', 1, 1, NULL),
		(N'm', N'Distance', N'meter', 1, 1, NULL),
		(N'min', N'Time', N'minute', 1, 60, NULL),
		(N'mo', N'Time', N'Month', 1, 2592000, NULL),
		(N'mt', N'Mass', N'Metric ton', 1, 1000000, NULL),
		(N'pcs', N'Count', N'Pieces', 1, 1, NULL),
		(N's', N'Time', N'second', 1, 1, NULL),
		(N'share', N'Pure', N'Shares', 1, 1, NULL),
		(N'USD', N'Money', N'US Dollars', 1, 1, N'USD'),
		(N'usg', N'Volume', N'US Gallon', 1, 3.785411784, NULL),
		(N'wd', N'Time', N'work day', 1, 8, NULL),
		(N'wk', N'Time', N'week', 1, 604800, NULL),
		(N'wmo', N'Time', N'work month', 1, 1248, NULL),
		(N'wwk', N'Time', N'work week', 1, 48, NULL),
		(N'wyr', N'Time', N'work year', 1, 14976, NULL),
		(N'yr', N'Time', N'Year', 1, 31104000, NULL);

	EXEC [dbo].[api_MeasurementUnits__Save]
		@Entities = @MU1Save,
		@ValidationErrorsJson = @ValidationErrorsJson OUTPUT,
		@EntitiesResultJson = @MU1ResultJson OUTPUT

	IF @ValidationErrorsJson IS NOT NULL 
	BEGIN
		Print 'MeasurementUnits: Location 1'
		GOTO Err_Label;
	END

	INSERT INTO @MU1Result(
		[Id], [UnitType], [UnitAmount], [BaseAmount], [Name], [Description], [IsActive], [Code],
		[CreatedAt], [CreatedBy], [ModifiedAt], [ModifiedBy], [EntityState]
	)
	SELECT 
		[Id], [UnitType], [UnitAmount], [BaseAmount], [Name], [Description], [IsActive], [Code],
		[CreatedAt], [CreatedBy], [ModifiedAt], [ModifiedBy], [EntityState]
	FROM OpenJson(@MU1ResultJson)
	WITH (
		[Id] INT '$.Id',
		[UnitType] NVARCHAR (255) '$.UnitType',
		[UnitAmount] FLOAT (53) '$.UnitAmount',
		[BaseAmount] FLOAT (53) '$.BaseAmount',
		[Name] NVARCHAR (255) '$.Name',
		[Description] NVARCHAR (255) '$.Description',
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
INSERT INTO @MU2Save ([Id], [Code], [UnitType], [Name], [Description], [UnitAmount], [BaseAmount], [EntityState])
SELECT [Id], [Code], [UnitType], [Name], [Description], [UnitAmount], [BaseAmount], N'Unchanged'
FROM [dbo].MeasurementUnits
WHERE [Code] Like 'm%';

-- Inserting
	DECLARE @TestingValidation bit = 0
	IF (@TestingValidation = 1)
	INSERT INTO @MU2Save
		([Name], [UnitType], [Description], [UnitAmount], [BaseAmount], [Code]) Values
		(N'AED', N'Money', N'AE Dirhams', 3.67, 1, N'AED'),
		(N'c', N'Time', N'Century', 1, 3110400000, NULL),
		(N'dozen', N'Count', N'Dazzina', 1, 12, NULL);
-- Updating
	UPDATE @MU2Save 
	SET 
		[Name] = N'pcs',
		[Description] = N'Metric Ton',
		[EntityState] = N'Updated'
	WHERE [Name] = N'mt';

-- Deleting
	UPDATE @MU2Save 
	SET 
		[EntityState] = N'Deleted'
	WHERE [Name] = N'min';-- Deleting the minute

-- Calling Save API
	EXEC [dbo].[api_MeasurementUnits__Save]
		@Entities = @MU2Save,
		@ValidationErrorsJson = @ValidationErrorsJson OUTPUT,
		@EntitiesResultJson = @MU2ResultJson OUTPUT

	IF @ValidationErrorsJson IS NOT NULL
	BEGIN
		Print 'MeasurementUnits: Location 2'
		GOTO Err_Label;
	END

	INSERT INTO @MU2Result(
		[Id], [UnitType], [UnitAmount], [BaseAmount], [Name], [IsActive], [Code],
		[CreatedAt], [CreatedBy], [ModifiedAt], [ModifiedBy], [EntityState]
	)
	SELECT 
		[Id], [UnitType], [UnitAmount], [BaseAmount], [Name], [IsActive], [Code],
		[CreatedAt], [CreatedBy], [ModifiedAt], [ModifiedBy], [EntityState]
	FROM OpenJson(@MU2ResultJson)
	WITH (
		[Id] INT '$.Id',
		[UnitType] NVARCHAR (255) '$.UnitType',
		[UnitAmount] FLOAT (53) '$.UnitAmount',
		[BaseAmount] FLOAT (53) '$.BaseAmount',
		[Name] NVARCHAR (255) '$.Name',
		[Description] NVARCHAR (255) '$.Description',
		[IsActive] BIT '$.IsActive',
		[Code] NVARCHAR (255) '$.Code',
		[CreatedAt] DATETIMEOFFSET(7) '$.CreatedAt',
		[CreatedBy] NVARCHAR(450) '$.CreatedBy',
		[ModifiedAt] DATETIMEOFFSET(7) '$.ModifiedAt',
		[ModifiedBy] NVARCHAR(450) '$.ModifiedBy',
		[EntityState] NVARCHAR(255) '$.EntityState'
	);
IF @LookupsSelect = 1
	SELECT * FROM [dbo].MeasurementUnits;