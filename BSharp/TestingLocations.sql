BEGIN -- Cleanup & Declarations
	DECLARE @L1Save LocationForSaveList, @L2Save LocationForSaveList;
	DECLARE @L1ResultJson NVARCHAR(MAX), @L2ResultJson NVARCHAR(MAX), @L3ResultJson NVARCHAR(MAX);
	DECLARE @LocationActivationList dbo.ActivationList;

	DECLARE @RawMaterialsWarehouse int, @FinishedGoodsWarehouse int; 
END

BEGIN -- Insert 
	INSERT INTO @L1Save
	([LocationType], [Name],					[Address], [BirthDateTime], [CustodianId]) VALUES
	(N'Warehouse',	N'Raw Materials Warehouse', NULL,		NULL, NULL),
	(N'Warehouse',	N'Fake Warehouse',			N'Far away', NULL, NULL),
	(N'Warehouse',	N'Finished Goods Warehouse', NULL,		NULL, NULL);

	EXEC  [dbo].[api_Locations__Save]
		@Locations = @L1Save,
		@ValidationErrorsJson = @ValidationErrorsJson OUTPUT,
		@LocationsResultJson = @L1ResultJson OUTPUT

	IF @ValidationErrorsJson IS NOT NULL 
	BEGIN
		Print 'Locations: Location 1'
		GOTO Err_Label;
	END

	INSERT INTO @L1Result(
		[Index], [Id], [LocationType], [Name], [IsActive], [Code], [Address], [BirthDateTime], [CustodianId],
		[CreatedAt], [CreatedBy], [ModifiedAt], [ModifiedBy], [EntityState]
	)
	SELECT 
		[Index], [Id], [LocationType], [Name], [IsActive], [Code], [Address], [BirthDateTime], [CustodianId],
		[CreatedAt], [CreatedBy], [ModifiedAt], [ModifiedBy], [EntityState]
	FROM OpenJson(@L1ResultJson)
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
	INSERT INTO @L2Save (
		  [Id], [LocationType], [Name], [Code], [Address], [BirthDateTime], [EntityState], [CustodianId]
	)
	SELECT
		L.[Id], [LocationType], [Name], [Code], [Address], [BirthDateTime], N'Unchanged', L.[CustodianId]
	FROM dbo.Locations L
	JOIN dbo.Custodies C ON L.Id = C.Id
	WHERE [Name] IN (N'Raw Materials Warehouse', N'Fake Warehouse')

	UPDATE @L2Save
	SET 
		[Address] = N'Alemgena, Oromia',
		[EntityState] = N'Updated'
	WHERE [Name] = N'Raw Materials Warehouse';

	UPDATE @L2Save
	SET 
		[EntityState] = N'Deleted'
	WHERE [Name] = N'Fake Warehouse';

	EXEC  [dbo].[api_Locations__Save]
		@Locations = @L2Save,
		@ValidationErrorsJson = @ValidationErrorsJson OUTPUT,
		@LocationsResultJson = @L2ResultJson OUTPUT

	IF @ValidationErrorsJson IS NOT NULL 
	BEGIN
		Print 'Locations: Location 2'
		GOTO Err_Label;
	END;

	INSERT INTO @L2Result(
		[Index], [Id], [LocationType], [Name], [IsActive], [Code], [Address], [BirthDateTime], [CustodianId],
		[CreatedAt], [CreatedBy], [ModifiedAt], [ModifiedBy], [EntityState]
	)
	SELECT 
		[Index], [Id], [LocationType], [Name], [IsActive], [Code], [Address], [BirthDateTime], [CustodianId],
		[CreatedAt], [CreatedBy], [ModifiedAt], [ModifiedBy], [EntityState]
	FROM OpenJson(@L2ResultJson)
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

	INSERT INTO @LocationActivationList(Id, IsActive)
	VALUES(29, 0), (31, 0)

	EXEC  [dbo].[api_Locations__Activate]
	@ActivationList = @LocationActivationList,
	@LocationsResultJson = @L3ResultJson OUTPUT

INSERT INTO @L3Result(
		[Index], [Id], [LocationType], [Name], [IsActive], [Code], [Address], [BirthDateTime], [CustodianId],
		[CreatedAt], [CreatedBy], [ModifiedAt], [ModifiedBy], [EntityState]
	)
	SELECT 
		[Index], [Id], [LocationType], [Name], [IsActive], [Code], [Address], [BirthDateTime], [CustodianId],
		[CreatedAt], [CreatedBy], [ModifiedAt], [ModifiedBy], [EntityState]
	FROM OpenJson(@L3ResultJson)
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
	SELECT * FROM @L1Result; SELECT * FROM @L2Result; SELECT * FROM @L3Result;
	SELECT * FROM [dbo].Custodies;

SELECT
	@RawMaterialsWarehouse = (SELECT [Id] FROM @L1Result WHERE [Name] = N'Raw Materials Warehouse'), 
	@FinishedGoodsWarehouse = (SELECT [Id] FROM @L1Result WHERE [Name] = N'Finished Goods Warehouse');
