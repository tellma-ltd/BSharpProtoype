BEGIN -- Cleanup & Declarations
	DECLARE @LocationsDTO [dbo].[LocationList];
	DECLARE @System int, @RawMaterialsWarehouse int, @FinishedGoodsWarehouse int, @MiscWarehouse int, @CBEUSD int, @CBEETB int; 
END;

BEGIN -- Insert 
	INSERT INTO @LocationsDTO
	([LocationType], [Name],					[Address], [BirthDateTime], [CustodianId]) VALUES
	(N'Warehouse',	N'System',					NULL,		NULL,			NULL),
	(N'Warehouse',	N'Raw Materials Warehouse', NULL,		NULL,			NULL),
	(N'Warehouse',	N'Fake Warehouse',		N'Far away',	NULL,			NULL),
	(N'Warehouse',	N'Finished Goods Warehouse', NULL,		NULL,			NULL),
	(N'Warehouse',	N'Misc Warehouse',			NULL,		NULL,			NULL),
	(N'BankAccount',N'CBE - USD',				N'144-1200',NULL,			@CBE),
	(N'BankAccount',N'CBE - ETB',				N'144-1299',NULL,			@CBE);

	EXEC [dbo].[api_Locations__Save]
		@Entities = @LocationsDTO,
		@ValidationErrorsJson = @ValidationErrorsJson OUTPUT,
		@ResultsJson = @ResultsJson OUTPUT;

	IF @ValidationErrorsJson IS NOT NULL 
	BEGIN
		Print 'Locations: Location 1'
		GOTO Err_Label;
	END;

	IF @DebugLocations = 1
		SELECT * FROM [dbo].[fr_Locations__Json](@ResultsJson);
END
BEGIN -- Updating RM Warehouse address
	DELETE FROM @LocationsDTO;
	INSERT INTO @LocationsDTO (
		 [Id], [LocationType], [Name], [Code], [Address], [BirthDateTime], [EntityState], [CustodianId]
	)
	SELECT
		L.[Id], [LocationType], [Name], [Code], [Address], [BirthDateTime], N'Unchanged', L.[CustodianId]
	FROM [dbo].Locations L
	JOIN [dbo].[Custodies] C ON L.Id = C.Id
	WHERE [Name] IN (N'Raw Materials Warehouse', N'Fake Warehouse');

	UPDATE @LocationsDTO
	SET 
		[Address] = N'Alemgena, Oromia',
		[EntityState] = N'Updated'
	WHERE [Name] = N'Raw Materials Warehouse';

	UPDATE @LocationsDTO
	SET 
		[EntityState] = N'Deleted'
	WHERE [Name] = N'Fake Warehouse';

	EXEC [dbo].[api_Locations__Save]
		@Entities = @LocationsDTO,
		@ValidationErrorsJson = @ValidationErrorsJson OUTPUT,
		@ResultsJson = @ResultsJson OUTPUT;

	IF @ValidationErrorsJson IS NOT NULL 
	BEGIN
		Print 'Locations: Location 2'
		GOTO Err_Label;
	END;

	IF @DebugLocations = 1
		SELECT * FROM [dbo].[fr_Locations__Json](@ResultsJson);

	DECLARE @Locs dbo.IntegerList;
	INSERT INTO @Locs([Id]) VALUES 
		(29),
		(31);

	EXEC [dbo].[api_Locations__Deactivate]
		@Ids = @Locs,
		@ResultsJson = @ResultsJson OUTPUT;

	IF @DebugLocations = 1
		SELECT * FROM [dbo].[fr_Locations__Json](@ResultsJson);
END

IF @DebugLocations = 1
	SELECT * FROM [dbo].[Custodies];

SELECT
	@System = (SELECT [Id] FROM [dbo].[Custodies] WHERE [Name] = N'System'), 
	@RawMaterialsWarehouse = (SELECT [Id] FROM [dbo].[Custodies] WHERE [Name] = N'Raw Materials Warehouse'), 
	@FinishedGoodsWarehouse = (SELECT [Id] FROM [dbo].[Custodies] WHERE [Name] = N'Finished Goods Warehouse'),
	@MiscWarehouse = (SELECT [Id] FROM [dbo].[Custodies] WHERE [Name] = N'Misc Warehouse'),
	@CBEUSD = (SELECT [Id] FROM [dbo].[Custodies] WHERE [Name] = N'CBE - USD'),
	@CBEETB = (SELECT [Id] FROM [dbo].[Custodies] WHERE [Name] = N'CBE - ETB');
	