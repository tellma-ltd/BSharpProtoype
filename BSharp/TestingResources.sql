BEGIN -- Cleanup & Declarations
	DECLARE @R1Save dbo.ResourceForSaveList, @R2Save dbo.ResourceForSaveList;
	DECLARE @R1Result dbo.ResourceList, @R2Result dbo.ResourceList;
	DECLARE @R1ResultJson NVARCHAR(MAX), @R2ResultJson NVARCHAR(MAX), @R3ResultJson NVARCHAR(MAX);
	DECLARE @ResourceActivationList dbo.ActivationList;

	DECLARE @ETB int, @USD int;
	DECLARE @CommonStock int;
	DECLARE @Camry2018 int, @TeddyBear int;
	DECLARE @HolidayOvertime int, @Labor int;
	DECLARE @ETBUnit int, @USDUnit int, @pcsUnit int, @shareUnit int, @wmoUnit int, @hrUnit int;
	SELECT @ETBUnit = [Id] FROM dbo.MeasurementUnits	WHERE [Name] = N'ETB'; IF @ETBUnit IS NULL Print N'@ETBUnit is NULL!!!!'
	SELECT @USDUnit = [Id] FROM dbo.MeasurementUnits	WHERE [Name] = N'USD'; IF @USDUnit IS NULL Print N'@USDUnit is NULL!!!!'
	SELECT @pcsUnit = [Id] FROM dbo.MeasurementUnits	WHERE [Name] = N'pcs'; IF @pcsUnit IS NULL Print N'@pcsUnit is NULL!!!!'
	SELECT @shareUnit = [Id] FROM dbo.MeasurementUnits	WHERE [Name] = N'share'; IF @shareUnit IS NULL Print N'@shareUnit is NULL!!!!'
	SELECT @wmoUnit = [Id] FROM dbo.MeasurementUnits	WHERE [Name] = N'wmo'; IF @wmoUnit IS NULL Print N'@wmoUnit is NULL!!!!'
	SELECT @hrUnit = [Id] FROM dbo.MeasurementUnits		WHERE [Name] = N'hr'; IF @hrUnit IS NULL Print N'@hrUnit is NULL!!!!'
END
BEGIN -- Inserting
	INSERT INTO @R1Save
	([ResourceType],		[Name],				[Code],	[MeasurementUnitId],[Memo], [Lookup1], [Lookup2], [Lookup3], [Lookup4], [PartOf], [FungibleParentIndex]) VALUES
	(N'Money',				N'ETB',				N'ETB',	@ETBUnit,			NULL,	NULL,		NULL,		NULL,		NULL,	NULL,		NULL),
	(N'Money',				N'USD',				N'USD',	@USDUnit,			NULL,	NULL,		NULL,		NULL,		NULL,	NULL,		NULL),
	(N'Vehicles',			N'Toyota Camry 2018', NULL,	@pcsUnit,			NULL,	N'Toyota',	N'Camry',	NULL,		NULL,	NULL,		NULL),
	(N'GeneralGoods',		N'Teddy bear',		NULL,	@pcsUnit,			NULL,	NULL,		NULL,		NULL,		NULL,	NULL,		NULL),
	(N'Shares',				N'Common Stock',	NULL,	@shareUnit,			NULL,	NULL,		NULL,		NULL,		NULL,	NULL,		NULL),
	(N'Shares',				N'Premium Stock',	NULL,	@shareUnit,			NULL,	NULL,		NULL,		NULL,		NULL,	NULL,		NULL),
	(N'WagesAndSalaries',	N'Labor',			NULL,	@wmoUnit,			NULL,	NULL,		NULL,		NULL,		NULL,	NULL,		NULL),
	(N'WagesAndSalaries',	N'Holiday Overtime', NULL,	@hrUnit,			NULL,	NULL,		NULL,		NULL,		NULL,	NULL,		NULL);

	EXEC  [dbo].[api_Resources__Save]
		@Resources = @R1Save,
		@ValidationErrorsJson = @ValidationErrorsJson OUTPUT,
		@ResourcesResultJson = @R1ResultJson OUTPUT

	IF @ValidationErrorsJson IS NOT NULL 
	BEGIN
		Print 'Location: Resources 1'
		GOTO Err_Label;
	END

	INSERT INTO @R1Result(
		[Index], [Id], [MeasurementUnitId], [ResourceType], [Name], [IsActive], [Code], [FungibleParentId],
		[CreatedAt], [CreatedBy], [ModifiedAt], [ModifiedBy], [EntityState]
	)
	SELECT 
		[Index], [Id], [MeasurementUnitId], [ResourceType], [Name], [IsActive], [Code], [FungibleParentId],
		[CreatedAt], [CreatedBy], [ModifiedAt], [ModifiedBy], [EntityState]
	FROM OpenJson(@R1ResultJson)
	WITH (
		[Index] INT '$.Index',
		[Id] INT '$.Id',
		[MeasurementUnitId] INT '$.MeasurementUnitId',
		[ResourceType] NVARCHAR (255) '$.ResourceType',
		[Name] NVARCHAR (255) '$.Name',
		[IsActive] BIT '$.IsActive',
		[Code] NVARCHAR (255) '$.Code',
		[FungibleParentId] INT '$.FungibleParentId',
		[CreatedAt] DATETIMEOFFSET(7) '$.CreatedAt',
		[CreatedBy] NVARCHAR(450) '$.CreatedBy',
		[ModifiedAt] DATETIMEOFFSET(7) '$.ModifiedAt',
		[ModifiedBy] NVARCHAR(450) '$.ModifiedBy',
		[EntityState] NVARCHAR(255) '$.EntityState'
	);
END
BEGIN -- Updating
	INSERT INTO @R2Save (
		[Id], [MeasurementUnitId], [ResourceType], [Name], [Code], [FungibleParentId], [EntityState]
	)
	SELECT
		[Id], [MeasurementUnitId], [ResourceType], [Name], [Code], [FungibleParentId], N'Unchanged'
	FROM dbo.Resources
	WHERE [Name] IN (N'Toyota Camry 2018', N'Fake')

	UPDATE @R2Save 
	SET 
		[Lookup3] = N'2018',
		[EntityState] = N'Updated'
	WHERE [Name] = N'Toyota Camry 2018';

	UPDATE @R2Save 
	SET
		[EntityState] = N'Deleted' 
	WHERE [Name] = N'Fake';

	EXEC  [dbo].[api_Resources__Save]
		@Resources = @R2Save,
		@ValidationErrorsJson = @ValidationErrorsJson OUTPUT,
		@ResourcesResultJson = @R2ResultJson OUTPUT

	IF @ValidationErrorsJson IS NOT NULL 
	BEGIN
		Print 'Location: Resources 2'
		GOTO Err_Label;
	END

	INSERT INTO @R2Result(
		[Index], [Id], [MeasurementUnitId], [ResourceType], [Name], [IsActive], [Code], [FungibleParentId],
		[CreatedAt], [CreatedBy], [ModifiedAt], [ModifiedBy], [EntityState]
	)
	SELECT 
		[Index], [Id], [MeasurementUnitId], [ResourceType], [Name], [IsActive], [Code], [FungibleParentId],
		[CreatedAt], [CreatedBy], [ModifiedAt], [ModifiedBy], [EntityState]
	FROM OpenJson(@R2ResultJson)
	WITH (
		[Index] INT '$.Index',
		[Id] INT '$.Id',
		[MeasurementUnitId] INT '$.MeasurementUnitId',
		[ResourceType] NVARCHAR (255) '$.ResourceType',
		[Name] NVARCHAR (255) '$.Name',
		[IsActive] BIT '$.IsActive',
		[Code] NVARCHAR (255) '$.Code',
		[FungibleParentId] INT '$.FungibleParentId',
		[CreatedAt] DATETIMEOFFSET(7) '$.CreatedAt',
		[CreatedBy] NVARCHAR(450) '$.CreatedBy',
		[ModifiedAt] DATETIMEOFFSET(7) '$.ModifiedAt',
		[ModifiedBy] NVARCHAR(450) '$.ModifiedBy',
		[EntityState] NVARCHAR(255) '$.EntityState'
	);
END 

IF @LookupsSelect = 1
	SELECT * FROM [dbo].Resources;

SELECT 
	@ETB = (SELECT [Id] FROM @R1Result WHERE [Name] = N'ETB'), 
	@USD = (SELECT [Id] FROM @R1Result WHERE [Name] = N'USD'),
	@Camry2018 = (SELECT [Id] FROM @R1Result WHERE [Name] = N'Toyota Camry 2018'),
	@TeddyBear = (SELECT [Id] FROM @R1Result WHERE [Name] = N'Teddy bear'),
	@CommonStock = (SELECT [Id] FROM @R1Result WHERE [Name] = N'Common Stock'),
	@HolidayOvertime = (SELECT [Id] FROM @R1Result WHERE [Name] = N'Holiday Overtime'),
	@Labor = (SELECT [Id] FROM @R1Result WHERE [Name] = N'Labor');