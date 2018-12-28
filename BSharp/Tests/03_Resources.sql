BEGIN -- Cleanup & Declarations
	DECLARE @ResourcesDTO [dbo].ResourceList;

	DECLARE @ETB int, @USD int, @CommonStock int;
	DECLARE @Camry2018 int, @Cotton int, @TeddyBear int, @Car1 int, @Car2 int;
	DECLARE @HOvertime int, @Basic int, @Transportation int, @Labor int, @Car1Svc int, @GOff int;
END
BEGIN -- Inserting
	INSERT INTO @ResourcesDTO
	([ResourceType],		[Name],					[Code],		[MeasurementUnitId],[Memo], [Lookup1], [Lookup2], [Lookup3], [Lookup4], [PartOfIndex], [InstanceOfIndex], [ServiceOfIndex]) VALUES
	(N'Money',				N'ETB',					N'ETB',		@ETBUnit,			NULL,	NULL,		NULL,		NULL,		NULL,	NULL,			NULL,				NULL),
	(N'Money',				N'USD',					N'USD',		@USDUnit,			NULL,	NULL,		NULL,		NULL,		NULL,	NULL,			NULL,				NULL),
	(N'MotorVehicles',		N'Toyota Camry 2018',	NULL,		@pcsUnit,			NULL,	N'Toyota',	N'Camry',	NULL,		NULL,	NULL,			NULL,				NULL),
	(N'SKD',				N'Toy. Cam. 18 - 101',	N'101',		@eaUnit,			NULL,	N'Toyota',	N'Camry',	NULL,		NULL,	NULL,			2,					NULL),
	(N'SKD',				N'Toy. Cam. 18 - 102',	N'102',		@eaUnit,			NULL,	N'Toyota',	N'Camry',	NULL,		NULL,	NULL,			2,					NULL),
	(N'SKD',				N'Fake',				N'199',		@eaUnit,			NULL,	N'Toyota',	N'Camry',	NULL,		NULL,	NULL,			2,					NULL),
	(N'GeneralGoods',		N'Cotton',				NULL,		@KgUnit,			NULL,	NULL,		NULL,		NULL,		NULL,	NULL,			NULL,				NULL),
	(N'GeneralGoods',		N'Teddy bear',			NULL,		@pcsUnit,			NULL,	NULL,		NULL,		NULL,		NULL,	NULL,			NULL,				NULL),
	(N'Shares',				N'Common Stock',		N'CMNSTCK',	@shareUnit,			NULL,	NULL,		NULL,		NULL,		NULL,	NULL,			NULL,				NULL),
	(N'Shares',				N'Premium Stock',		N'PRMMSTCK',@shareUnit,			NULL,	NULL,		NULL,		NULL,		NULL,	NULL,			NULL,				NULL),
	(N'WagesAndSalaries',	N'Basic',				NULL,		@moUnit,			NULL,	NULL,		NULL,		NULL,		NULL,	NULL,			NULL,				NULL),
	(N'WagesAndSalaries',	N'Transportation',		NULL,		@moUnit,			NULL,	NULL,		NULL,		NULL,		NULL,	NULL,			NULL,				NULL),
	(N'WagesAndSalaries',	N'Holiday Overtime',	NULL,		@hrUnit,			NULL,	NULL,		NULL,		NULL,		NULL,	NULL,			NULL,				NULL),
	(N'WagesAndSalaries',	N'Labor',				NULL,		@dayUnit,			NULL,	NULL,		NULL,		NULL,		NULL,	NULL,			NULL,				NULL),
	(N'PPEServices',		N'Girgi Office',		N'Goff',	@moUnit,			NULL,	NULL,		NULL,		NULL,		NULL,	NULL,			NULL,				3),
	(N'PPEServices',		N'Car 101 - Svc',		N'101D',	@moUnit,			NULL,	NULL,		NULL,		NULL,		NULL,	NULL,			NULL,				3),
	(N'PPEServices',		N'Car 102 - Svc',		N'102D',	@dayUnit,			NULL,	NULL,		NULL,		NULL,		NULL,	NULL,			NULL,				4);

	EXEC [dbo].[api_Resources__Save]
		@Entities = @ResourcesDTO,
		@ValidationErrorsJson = @ValidationErrorsJson OUTPUT,
		@ResultsJson = @ResultsJson OUTPUT;

	IF @ValidationErrorsJson IS NOT NULL 
	BEGIN
		Print 'Location: Resources 1'
		GOTO Err_Label;
	END;
	IF @DebugResources = 1
		SELECT * FROM [dbo].[ft_Resources__Json] (@ResultsJson);
END
BEGIN -- Updating
	DELETE FROM @ResourcesDTO;
	INSERT INTO @ResourcesDTO (
		[Id], [MeasurementUnitId], [ResourceType], [Name], [Code], [Lookup1], [Lookup2], [Lookup3], [Lookup4],
		[PartOfId], [InstanceOfId], [ServiceOfId], [EntityState]
	)
	SELECT
		[Id], [MeasurementUnitId], [ResourceType], [Name], [Code], [Lookup1], [Lookup2], [Lookup3], [Lookup4],
		[PartOfId], [InstanceOfId], [ServiceOfId], N'Unchanged'
	FROM [dbo].Resources
	WHERE [ResourceType] IN (N'MotorVehicles', N'SKD')

	UPDATE @ResourcesDTO 
	SET 
		[Lookup3] = N'2018',
		[EntityState] = N'Updated'
	WHERE [Name] <> N'Fake';

	UPDATE @ResourcesDTO 
	SET
		[EntityState] = N'Deleted' 
	WHERE [Name] = N'Fake';

	EXEC [dbo].[api_Resources__Save]
		@Entities = @ResourcesDTO,
		@ValidationErrorsJson = @ValidationErrorsJson OUTPUT,
		@ResultsJson = @ResultsJson OUTPUT;

	IF @ValidationErrorsJson IS NOT NULL 
	BEGIN
		Print 'Location: Resources 2'
		GOTO Err_Label;
	END
	IF @DebugResources = 1
		SELECT * FROM [dbo].[ft_Resources__Json] (@ResultsJson);
END 

IF @DebugResources = 1
	SELECT * FROM [dbo].Resources;

SELECT 
	@ETB = (SELECT [Id] FROM [dbo].[Resources] WHERE [Name] = N'ETB'), 
	@USD = (SELECT [Id] FROM [dbo].[Resources] WHERE [Name] = N'USD'),
	@Camry2018 = (SELECT [Id] FROM [dbo].[Resources] WHERE [Name] = N'Toyota Camry 2018'),
	@Car1 = (SELECT [Id] FROM [dbo].[Resources] WHERE [Code] = N'101'),
	@Car2 = (SELECT [Id] FROM [dbo].[Resources] WHERE [Code] = N'102'),
	@Car1Svc = (SELECT [Id] FROM [dbo].[Resources] WHERE [Code] = N'101D'),
	@GOff = (SELECT [Id] FROM [dbo].[Resources] WHERE [Code] = N'Goff'),
	@Cotton = (SELECT [Id] FROM [dbo].[Resources] WHERE [Name] = N'Cotton'),
	@TeddyBear = (SELECT [Id] FROM [dbo].[Resources] WHERE [Name] = N'Teddy bear'),
	@CommonStock = (SELECT [Id] FROM [dbo].[Resources] WHERE [Name] = N'Common Stock'),
	@HOvertime = (SELECT [Id] FROM [dbo].[Resources] WHERE [Name] = N'Holiday Overtime'),
	@Basic = (SELECT [Id] FROM [dbo].[Resources] WHERE [Name] = N'Basic'),
	@Transportation = (SELECT [Id] FROM [dbo].[Resources] WHERE [Name] = N'Transportation'),
	@Labor = (SELECT [Id] FROM [dbo].[Resources] WHERE [Name] = N'Labor');