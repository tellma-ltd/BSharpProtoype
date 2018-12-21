BEGIN -- Cleanup & Declarations
	DECLARE @Loc1Save LocationForSaveList, @Loc2Save LocationForSaveList;
	DECLARE @Loc1Result [dbo].LocationList, @Loc2Result [dbo].LocationList, @Loc3Result [dbo].LocationList;
	DECLARE @Loc1ResultJson NVARCHAR(MAX), @Loc2ResultJson NVARCHAR(MAX), @Loc3ResultJson NVARCHAR(MAX);
	DECLARE @LocationActivationList [dbo].ActivationList;

	DECLARE @RawMaterialsWarehouse int, @FinishedGoodsWarehouse int, @MiscWarehouse int, @CBEUSD int, @CBEETB int; 
END

BEGIN -- Insert 
	INSERT INTO @Loc1Save
	([LocationType], [Name],					[Address], [BirthDateTime], [CustodianId]) VALUES
	(N'Warehouse',	N'Raw Materials Warehouse', NULL,		NULL,			NULL),
	(N'Warehouse',	N'Fake Warehouse',		N'Far away',	NULL,			NULL),
	(N'Warehouse',	N'Finished Goods Warehouse', NULL,		NULL,			NULL),
	(N'Warehouse',	N'Misc Warehouse',			NULL,		NULL,			NULL),
	(N'BankAccount',N'CBE - USD',				N'144-1200',NULL,			@CBE),
	(N'BankAccount',N'CBE - ETB',				N'144-1299',NULL,			@CBE);

	EXEC [dbo].[api_Locations__Save]
		@Entities = @Loc1Save,
		@ValidationErrorsJson = @ValidationErrorsJson OUTPUT,
		@EntitiesResultJson = @Loc1ResultJson OUTPUT

	IF @ValidationErrorsJson IS NOT NULL 
	BEGIN
		Print 'Locations: Location 1'
		GOTO Err_Label;
	END

	INSERT INTO @Loc1Result(
		[Id], [LocationType], [Name], [IsActive], [Code], [Address], [BirthDateTime], [CustodianId],
		[CreatedAt], [CreatedBy], [ModifiedAt], [ModifiedBy], [EntityState]
	)
	SELECT 
		[Id], [LocationType], [Name], [IsActive], [Code], [Address], [BirthDateTime], [CustodianId],
		[CreatedAt], [CreatedBy], [ModifiedAt], [ModifiedBy], [EntityState]
	FROM OpenJson(@Loc1ResultJson)
	WITH (
		[Id] INT '$.Id',
		[LocationType] NVARCHAR (255) '$.LocationType',
		[Name] NVARCHAR (255) '$.Name',
		[IsActive] BIT '$.IsActive',
		[Code] NVARCHAR (255) '$.Code',
		[Address] NVARCHAR (255) '$.Address',
		[BirthDateTime] DATETIMEOFFSET (7) '$.BirthDateTime',
		[CustodianId] INT '$.CustodianId',
		[CreatedAt] DATETIMEOFFSET(7) '$.CreatedAt',
		[CreatedBy] NVARCHAR(450) '$.CreatedBy',
		[ModifiedAt] DATETIMEOFFSET(7) '$.ModifiedAt',
		[ModifiedBy] NVARCHAR(450) '$.ModifiedBy',
		[EntityState] NVARCHAR(255) '$.EntityState'
	);
END
BEGIN -- Updating RM Warehouse address
	INSERT INTO @Loc2Save (
		 [Id], [LocationType], [Name], [Code], [Address], [BirthDateTime], [EntityState], [CustodianId]
	)
	SELECT
		L.[Id], [LocationType], [Name], [Code], [Address], [BirthDateTime], N'Unchanged', L.[CustodianId]
	FROM [dbo].Locations L
	JOIN [dbo].[Custodies] C ON L.Id = C.Id
	WHERE [Name] IN (N'Raw Materials Warehouse', N'Fake Warehouse')

	UPDATE @Loc2Save
	SET 
		[Address] = N'Alemgena, Oromia',
		[EntityState] = N'Updated'
	WHERE [Name] = N'Raw Materials Warehouse';

	UPDATE @Loc2Save
	SET 
		[EntityState] = N'Deleted'
	WHERE [Name] = N'Fake Warehouse';

	EXEC [dbo].[api_Locations__Save]
		@Entities = @Loc2Save,
		@ValidationErrorsJson = @ValidationErrorsJson OUTPUT,
		@EntitiesResultJson = @Loc2ResultJson OUTPUT

	IF @ValidationErrorsJson IS NOT NULL 
	BEGIN
		Print 'Locations: Location 2'
		GOTO Err_Label;
	END;

	INSERT INTO @Loc2Result(
		[Id], [LocationType], [Name], [IsActive], [Code], [Address], [BirthDateTime], [CustodianId],
		[CreatedAt], [CreatedBy], [ModifiedAt], [ModifiedBy], [EntityState]
	)
	SELECT 
		[Id], [LocationType], [Name], [IsActive], [Code], [Address], [BirthDateTime], [CustodianId],
		[CreatedAt], [CreatedBy], [ModifiedAt], [ModifiedBy], [EntityState]
	FROM OpenJson(@Loc2ResultJson)
	WITH (
		[Id] INT '$.Id',
		[LocationType] NVARCHAR (255) '$.LocationType',
		[Name] NVARCHAR (255) '$.Name',
		[IsActive] BIT '$.IsActive',
		[Code] NVARCHAR (255) '$.Code',
		[Address] NVARCHAR (255) '$.Address',
		[BirthDateTime] DATETIMEOFFSET (7) '$.BirthDateTime',
		[CustodianId] INT '$.CustodianId',
		[CreatedAt] DATETIMEOFFSET(7) '$.CreatedAt',
		[CreatedBy] NVARCHAR(450) '$.CreatedBy',
		[ModifiedAt] DATETIMEOFFSET(7) '$.ModifiedAt',
		[ModifiedBy] NVARCHAR(450) '$.ModifiedBy',
		[EntityState] NVARCHAR(255) '$.EntityState'
	);
	DECLARE @Locs dbo.IntegerList;
	INSERT INTO @Locs([Id]) VALUES 
		(29),
		(31);

	EXEC [dbo].[api_Locations__Deactivate]
		@Ids = @Locs,
		@EntitiesResultJson = @Loc3ResultJson OUTPUT

	INSERT INTO @Loc3Result(
		[Id], [LocationType], [Name], [IsActive], [Code], [Address], [BirthDateTime], [CustodianId],
		[CreatedAt], [CreatedBy], [ModifiedAt], [ModifiedBy], [EntityState]
	)
	SELECT 
		[Id], [LocationType], [Name], [IsActive], [Code], [Address], [BirthDateTime], [CustodianId],
		[CreatedAt], [CreatedBy], [ModifiedAt], [ModifiedBy], [EntityState]
	FROM OpenJson(@Loc3ResultJson)
	WITH (
		[Id] INT '$.Id',
		[LocationType] NVARCHAR (255) '$.LocationType',
		[Name] NVARCHAR (255) '$.Name',
		[IsActive] BIT '$.IsActive',
		[Code] NVARCHAR (255) '$.Code',
		[Address] NVARCHAR (255) '$.Address',
		[BirthDateTime] DATETIMEOFFSET (7) '$.BirthDateTime',
		[CustodianId] INT '$.CustodianId',
		[CreatedAt] DATETIMEOFFSET(7) '$.CreatedAt',
		[CreatedBy] NVARCHAR(450) '$.CreatedBy',
		[ModifiedAt] DATETIMEOFFSET(7) '$.ModifiedAt',
		[ModifiedBy] NVARCHAR(450) '$.ModifiedBy',
		[EntityState] NVARCHAR(255) '$.EntityState'
	);
END

IF @LookupsSelect = 1
BEGIN
	SELECT * FROM @Loc1Result; SELECT * FROM @Loc2Result; SELECT * FROM @Loc3Result;
	SELECT * FROM [dbo].[Custodies];
END

SELECT
	@RawMaterialsWarehouse = (SELECT [Id] FROM @Loc1Result WHERE [Name] = N'Raw Materials Warehouse'), 
	@FinishedGoodsWarehouse = (SELECT [Id] FROM @Loc1Result WHERE [Name] = N'Finished Goods Warehouse'),
	@MiscWarehouse = (SELECT [Id] FROM @Loc1Result WHERE [Name] = N'Misc Warehouse'),
	@CBEUSD = (SELECT [Id] FROM @Loc1Result WHERE [Name] = N'CBE - USD'),
	@CBEETB = (SELECT [Id] FROM @Loc1Result WHERE [Name] = N'CBE - ETB');
	