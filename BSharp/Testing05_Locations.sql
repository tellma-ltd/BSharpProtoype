BEGIN -- Cleanup & Declarations
	DECLARE @Loc1Save LocationForSaveList, @Loc2Save LocationForSaveList;
	DECLARE @Loc1Result [dbo].LocationList, @Loc2Result [dbo].LocationList, @Loc3Result [dbo].LocationList;
	DECLARE @Loc1ResultJson NVARCHAR(MAX), @Loc2ResultJson NVARCHAR(MAX), @Loc3ResultJson NVARCHAR(MAX);
	DECLARE @LocationActivationList [dbo].ActivationList;

	DECLARE @RawMaterialsWarehouse int, @FinishedGoodsWarehouse int; 
END

BEGIN -- Insert 
	INSERT INTO @Loc1Save
	([LocationType], [Name],					[Address], [BirthDateTime], [CustodianId]) VALUES
	(N'Warehouse',	N'Raw Materials Warehouse', NULL,		NULL, NULL),
	(N'Warehouse',	N'Fake Warehouse',			N'Far away', NULL, NULL),
	(N'Warehouse',	N'Finished Goods Warehouse', NULL,		NULL, NULL);

	EXEC [dbo].[api_Locations__Save]
		@Locations = @Loc1Save,
		@ValidationErrorsJson = @ValidationErrorsJson OUTPUT,
		@LocationsResultJson = @Loc1ResultJson OUTPUT

	IF @ValidationErrorsJson IS NOT NULL 
	BEGIN
		Print 'Locations: Location 1'
		GOTO Err_Label;
	END

	INSERT INTO @Loc1Result(
		[Index], [Id], [LocationType], [Name], [IsActive], [Code], [Address], [BirthDateTime], [CustodianId],
		[CreatedAt], [CreatedBy], [ModifiedAt], [ModifiedBy], [EntityState]
	)
	SELECT 
		[Index], [Id], [LocationType], [Name], [IsActive], [Code], [Address], [BirthDateTime], [CustodianId],
		[CreatedAt], [CreatedBy], [ModifiedAt], [ModifiedBy], [EntityState]
	FROM OpenJson(@Loc1ResultJson)
	WITH (
		[Index] INT '$.Index',
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
		@Locations = @Loc2Save,
		@ValidationErrorsJson = @ValidationErrorsJson OUTPUT,
		@LocationsResultJson = @Loc2ResultJson OUTPUT

	IF @ValidationErrorsJson IS NOT NULL 
	BEGIN
		Print 'Locations: Location 2'
		GOTO Err_Label;
	END;

	INSERT INTO @Loc2Result(
		[Index], [Id], [LocationType], [Name], [IsActive], [Code], [Address], [BirthDateTime], [CustodianId],
		[CreatedAt], [CreatedBy], [ModifiedAt], [ModifiedBy], [EntityState]
	)
	SELECT 
		[Index], [Id], [LocationType], [Name], [IsActive], [Code], [Address], [BirthDateTime], [CustodianId],
		[CreatedAt], [CreatedBy], [ModifiedAt], [ModifiedBy], [EntityState]
	FROM OpenJson(@Loc2ResultJson)
	WITH (
		[Index] INT '$.Index',
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
	DECLARE @Locs dbo.[IndexedIdList];
	INSERT INTO @Locs([Index], [Id]) VALUES 
	(0, 29),
	(1, 31);

	EXEC [dbo].[api_Locations__Deactivate]
	@IndexedIds = @Locs,
	@LocationsResultJson = @Loc3ResultJson OUTPUT

INSERT INTO @Loc3Result(
		[Index], [Id], [LocationType], [Name], [IsActive], [Code], [Address], [BirthDateTime], [CustodianId],
		[CreatedAt], [CreatedBy], [ModifiedAt], [ModifiedBy], [EntityState]
	)
	SELECT 
		[Index], [Id], [LocationType], [Name], [IsActive], [Code], [Address], [BirthDateTime], [CustodianId],
		[CreatedAt], [CreatedBy], [ModifiedAt], [ModifiedBy], [EntityState]
	FROM OpenJson(@Loc3ResultJson)
	WITH (
		[Index] INT '$.Index',
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
	@FinishedGoodsWarehouse = (SELECT [Id] FROM @Loc1Result WHERE [Name] = N'Finished Goods Warehouse');
