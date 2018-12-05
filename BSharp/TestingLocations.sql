BEGIN -- Cleanup & Declarations
	DECLARE @L1 LocationForSaveList, @L2 LocationForSaveList;
	DECLARE @RawMaterialsWarehouse int, @FinishedGoodsWarehouse int; 
END

BEGIN -- Insert 
	INSERT INTO @L1
	([LocationType], [Name],					[Address], [BirthDateTime], [CustodianId]) VALUES
	(N'Warehouse',	N'Raw Materials Warehouse', NULL,		NULL, NULL),
	(N'Warehouse',	N'Fake Warehouse',			N'Far away',NULL, NULL),
	(N'Warehouse',	N'Finished Goods Warehouse', NULL,		NULL, NULL);

EXEC  [dbo].[api_Locations__Save]
		@Locations = @L1,
		@ValidationErrorsJson = @ValidationErrorsJson OUTPUT,
		@IndexedIdsJson = @IndexedIdsJson OUTPUT

	IF @ValidationErrorsJson IS NOT NULL 
	BEGIN
		Print 'Locations: Location 1'
		GOTO Err_Label;
	END

	DELETE FROM @IndexedIds;
	INSERT INTO @IndexedIds
	SELECT * FROM OpenJson(@IndexedIdsJson)
	WITH ([Index] INT '$.Index', [Id] INT '$.Id');

	DELETE FROM @L1 WHERE [EntityState] IN ('Deleted');

	UPDATE T 
	SET T.[Id] = II.[Id], T.[EntityState] = N'Unchanged'
	FROM @L1 T 
	JOIN @IndexedIds II ON T.[Index] = II.[Index];

	UPDATE @L1 SET [EntityState] = N'Unchanged'	WHERE  [EntityState] = N'Updated';
END
BEGIN -- Updating RM Warehouse address
INSERT INTO @L2 (
	  [Id], [LocationType], [Name], [Code], [Address], [BirthDateTime], [EntityState])
SELECT
	L.[Id], [LocationType], [Name], [Code], [Address], [BirthDateTime], N'Unchanged'
FROM dbo.Locations L
JOIN dbo.Custodies C ON L.Id = C.Id
WHERE [Name] IN (N'Raw Materials Warehouse', N'Fake Warehouse')

	UPDATE @L2 
	SET 
		[Address] = N'Alemgena, Oromia',
		[EntityState] = N'Updated'
	WHERE [Name] = N'Raw Materials Warehouse';

	UPDATE @L2 
	SET 
		[EntityState] = N'Deleted'
	WHERE [Name] = N'Fake Warehouse';

	EXEC  [dbo].[api_Locations__Save]
		@Locations = @L2,
		@ValidationErrorsJson = @ValidationErrorsJson OUTPUT,
		@IndexedIdsJson = @IndexedIdsJson OUTPUT

	IF @ValidationErrorsJson IS NOT NULL 
	BEGIN
		Print 'Locations: Location 2'
		GOTO Err_Label;
	END;

	DELETE FROM @IndexedIds;
	INSERT INTO @IndexedIds
	SELECT * FROM OpenJson(@IndexedIdsJson)
	WITH ([Index] INT '$.Index', [Id] INT '$.Id');

	DELETE FROM @L2 WHERE [EntityState] IN ('Deleted');

	UPDATE T 
	SET T.[Id] = II.[Id], T.[EntityState] = N'Unchanged'
	FROM @L2 T 
	JOIN @IndexedIds II ON T.[Index] = II.[Index];

	UPDATE @L2 SET [EntityState] = N'Unchanged'	WHERE  [EntityState] = N'Updated';
END	
--	SELECT * FROM @Locations;
SELECT
	@RawMaterialsWarehouse = (SELECT [Id] FROM @L1 WHERE [Name] = N'Raw Materials Warehouse'), 
	@FinishedGoodsWarehouse = (SELECT [Id] FROM @L1 WHERE [Name] = N'Finished Goods Warehouse');
