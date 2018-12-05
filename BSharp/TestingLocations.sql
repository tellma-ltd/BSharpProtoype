BEGIN -- Cleanup & Declarations
	DECLARE @Locations LocationList, @LocationsResult LocationList;
	DECLARE @RawMaterialsWarehouse int, @FinishedGoodsWarehouse int; 
END

BEGIN -- Locations
	BEGIN -- Insert 
		INSERT INTO @Locations
		([LocationType], [Name],						[Address], [ParentId],[CustodianId], [TemporaryId]) VALUES
		(N'Warehouse',	N'Raw Materials Warehouse', NULL,		NULL,	NULL, -100),
		(N'Warehouse',		N'Fake Warehouse',			NULL,		NULL,	NULL, -99),
		(N'Warehouse',		N'Finished Goods Warehouse', NULL,		NULL,	NULL, -98);

		DELETE FROM @LocationsResult; INSERT INTO @LocationsResult([Id], [LocationType], [Name], [IsActive], [Address], [ParentId],[CustodianId], [EntityState], [TemporaryId])
		EXEC  [dbo].[api_Locations__Save]  @Locations = @Locations; DELETE FROM @Locations WHERE [EntityState] IN (N'Inserted', N'Updated', 'Deleted'); INSERT INTO @Locations SELECT * FROM @LocationsResult;
	END
	BEGIN -- Updating RM Warehouse address
		UPDATE @Locations 
		SET 
			[Address] = N'Alemgena, Oromia',
			[EntityState] = N'Updated'
		WHERE [Name] = N'Raw Materials Warehouse';

		DELETE FROM @LocationsResult; INSERT INTO @LocationsResult([Id], [LocationType], [Name], [IsActive], [Address], [ParentId],[CustodianId], [EntityState], [TemporaryId])
		EXEC  [dbo].[api_Locations__Save]  @Locations = @Locations; DELETE FROM @Locations WHERE [EntityState] IN (N'Inserted', N'Updated', 'Deleted'); INSERT INTO @Locations SELECT * FROM @LocationsResult;
	END
	BEGIN -- Updating RM Warehouse address
		UPDATE @Locations 
		SET 
			[EntityState] = N'Deleted'
		WHERE [Name] = N'Fake Warehouse';

		DELETE FROM @LocationsResult; INSERT INTO @LocationsResult([Id], [LocationType], [Name], [IsActive], [Address], [ParentId],[CustodianId], [EntityState], [TemporaryId])
		EXEC  [dbo].[api_Locations__Save]  @Locations = @Locations; DELETE FROM @Locations WHERE [EntityState] IN (N'Inserted', N'Updated', 'Deleted'); INSERT INTO @Locations SELECT * FROM @LocationsResult;
	END	
--	SELECT * FROM @Locations;
	SELECT
		@RawMaterialsWarehouse = (SELECT [Id] FROM @Locations WHERE [Name] = N'Raw Materials Warehouse'), 
		@FinishedGoodsWarehouse = (SELECT [Id] FROM @Locations WHERE [Name] = N'Finished Goods Warehouse');
END