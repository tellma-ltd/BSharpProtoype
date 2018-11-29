BEGIN -- Cleanup & Declarations
	DECLARE @Resources ResourceList, @ResourcesResult ResourceList;
	DECLARE @ETB int, @USD int;
	DECLARE @CommonStock int;
	DECLARE @Camry2018 int, @TeddyBear int;
	DECLARE @HolidayOvertime int, @Labor int;
END
BEGIN -- Resources
	BEGIN -- Inserting
		INSERT INTO @Resources
		([Id], [TemporaryId], [ResourceType],		[Name],				[Code],							[MeasurementUnitId],[Memo], [Lookup1], [Lookup2], [Lookup3], [Lookup4], [PartOf], [FungibleParentId]) VALUES
		(-100, -100,			N'Money',			N'ETB',				N'ETB',	[dbo].[fn_UOM_Code__Id](N'ETB'),		NULL,	NULL,		NULL,		NULL,		NULL,	NULL,						NULL),
		(-99,	-99,			N'Money',			N'USD',				N'USD',	[dbo].[fn_UOM_Code__Id](N'USD'),		NULL,	NULL,		NULL,		NULL,		NULL,	NULL,						NULL),
		(-98,	-98,			N'Vehicles',		N'Toyota Camry 2018',NULL,	[dbo].[fn_UOM_Code__Id](N'pcs'),		NULL,	N'Toyota',	N'Camry',	NULL,		NULL,	NULL,						NULL),
		(-97,	-97,			N'GeneralGoods',	N'Teddy bear',		NULL,	[dbo].[fn_UOM_Code__Id](N'pcs'),		NULL,	NULL,		NULL,		NULL,		NULL,	NULL,						NULL),
		(-96,	-96,			N'Shares',			N'Common Stock',	NULL,	[dbo].[fn_UOM_Code__Id](N'share'),		NULL,	NULL,		NULL,		NULL,		NULL,	NULL,						NULL),
		(-92,	-92,			N'Shares',			N'Premium Stock',	NULL,	[dbo].[fn_UOM_Code__Id](N'share'),		NULL,	NULL,		NULL,		NULL,		NULL,	NULL,						NULL),
		(-95,	-95,			N'WagesAndSalaries',N'Labor',			NULL,	[dbo].[fn_UOM_Code__Id](N'wmo'),		NULL,	NULL,		NULL,		NULL,		NULL,	NULL,						NULL),
		(-94,	-94,			N'WagesAndSalaries',N'Holiday Overtime',NULL,	[dbo].[fn_UOM_Code__Id](N'hr'),			NULL,	NULL,		NULL,		NULL,		NULL,	NULL,						NULL);

		DELETE FROM @ResourcesResult; INSERT INTO @ResourcesResult([Id], [ResourceType],	[Name],			[Code], [MeasurementUnitId],[Memo], [Lookup1], [Lookup2], [Lookup3], [Lookup4], [PartOf], [FungibleParentId], [Status], [TemporaryId])
		EXEC  [dbo].[api_Resources__Save]  @Resources = @Resources; DELETE FROM @Resources WHERE Status IN (N'Inserted', N'Updated', 'Deleted'); INSERT INTO @Resources SELECT * FROM @ResourcesResult;
	END
	BEGIN -- Updating
		UPDATE @Resources 
		SET 
			[Lookup3] = N'2018',
			Status = N'Updated'
		WHERE [TemporaryId] = -98;

		DELETE FROM @ResourcesResult; INSERT INTO @ResourcesResult([Id], [ResourceType],	[Name],			[Code], [MeasurementUnitId],[Memo], [Lookup1], [Lookup2], [Lookup3], [Lookup4], [PartOf], [FungibleParentId], [Status], [TemporaryId])
		EXEC  [dbo].[api_Resources__Save]  @Resources = @Resources; DELETE FROM @Resources WHERE Status IN (N'Inserted', N'Updated', 'Deleted'); INSERT INTO @Resources SELECT * FROM @ResourcesResult;
	END	
	BEGIN -- Deleting
		UPDATE @Resources SET [Status] = N'Deleted' WHERE [TemporaryId] = -92;

		DELETE FROM @ResourcesResult; INSERT INTO @ResourcesResult([Id], [ResourceType],	[Name],			[Code], [MeasurementUnitId],[Memo], [Lookup1], [Lookup2], [Lookup3], [Lookup4], [PartOf], [FungibleParentId], [Status], [TemporaryId])
		EXEC  [dbo].[api_Resources__Save]  @Resources = @Resources; DELETE FROM @Resources WHERE Status IN (N'Inserted', N'Updated', 'Deleted'); INSERT INTO @Resources SELECT * FROM @ResourcesResult;
	END 
--	SELECT * FROM @Resources;
	SELECT 
		@ETB = (SELECT [Id] FROM @Resources WHERE [TemporaryId] = -100), 
		@USD = (SELECT [Id] FROM @Resources WHERE [TemporaryId] = -99),
		@Camry2018 = (SELECT [Id] FROM @Resources WHERE [TemporaryId] = -98),
		@TeddyBear = (SELECT [Id] FROM @Resources WHERE [TemporaryId] = -97),
		@CommonStock = (SELECT [Id] FROM @Resources WHERE [TemporaryId] = -96),
		@HolidayOvertime = (SELECT [Id] FROM @Resources WHERE [TemporaryId] = -95),
		@Labor = (SELECT [Id] FROM @Resources WHERE [TemporaryId] = -94);

	/*INSERT INTO dbo.Settings VALUES
	(N'HolidayOvertime', @HolidayOvertime),
	(N'Labor', @Labor); */
END