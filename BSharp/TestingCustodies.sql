BEGIN -- Cleanup & Declarations
	DECLARE @Agents AgentList, @AgentsResult AgentList, @Locations LocationList, @LocationsResult LocationList;
	DECLARE @MohamadAkra int, @AhmadAkra int, @BadegeKebede int, @TizitaNigussie int, @Ashenafi int, @YisakTegene int, @ZewdineshHora int, @TigistNegash int, @RomanZenebe int, @Mestawet int, @AyelechHora int, @YigezuLegesse int;
	DECLARE @BananIT int, @WaliaSteel int, @Lifan int, @Sesay int, @ERCA int, @Paint int, @Plastic int, @CBE int, @AWB int, @NIB int;
	DECLARE @ExecutiveOffice int, @Production int, @Sales int, @Finance int, @HR int, @Purchasing int;
	DECLARE @RawMaterialsWarehouse int, @FinishedGoodsWarehouse int; 
END
BEGIN -- Users
	IF NOT EXISTS(SELECT * FROM dbo.Users)
	INSERT INTO dbo.Users(Id, FriendlyName) VALUES
	(N'system@banan-it.com', N'B#'),
	(N'mohamad.akra@banan-it.com', N'Mohamad Akra'),
	(N'ahmad.akra@banan-it.com', N'Ahmad Akra'),
	(N'badegek@gmail.com', N'Badege'),
	(N'mintewelde00@gmail.com', N'Tizita'),
	(N'ashenafi935@gmail.com', N'Ashenafi'),
	(N'yisak.tegene@gmail.com', N'Yisak'),
	(N'zewdnesh.hora@gmail.com', N'Zewdinesh Hora'),
	(N'tigistnegash74@gmail.com', N'Tigist'),
	(N'roman.zen12@gmail.com', N'Roman'),
	(N'mestawetezige@gmail.com', N'Mestawet'),
	(N'ayelech.hora@gmail.com', N'Ayelech'),
	(N'info@banan-it.com', N'Banan IT'),
	(N'DESKTOP-V0VNDC4\Mohamad Akra', N'Dr. Akra')
END
BEGIN -- Agents
	BEGIN -- Insert individuals and organizations
		INSERT INTO @Agents
		([Id], [AgentType],		[Name],			[IsRelated], [UserId],						[TaxIdentificationNumber], [RegisteredAddress], [Title], [Gender], [BirthDateTime]) VALUES
		(-100,	N'Individual',	N'Mohamad Akra',	0,		 N'mohamad.akra@banan-it.com',	NULL,						NULL,				N'Dr.',		'M',	'1966.02.19'),
		(-99,	N'Individual',	N'Ahmad Akra',		0,		 N'ahmad.akra@banan-it.com',	NULL,						NULL,				N'Mr.',		'M',	'1992.09.21'),
		(-98, N'Individual',	N'Badege Kebede',	1,		 N'badegek@gmail.com',			NULL,						NULL,				N'ATO',		'M',	NULL),
		(-97, N'Individual',	N'Tizita Nigussie',	0,		N'mintewelde00@gmail.com',		NULL,						NULL,				N'Ms.', 	'F',	NULL),
		(-96, N'Individual',	N'Ashenafi Fantahun',0,		N'ashenafi935@gmail.com',		NULL,						NULL,				N'Mr.',		'M',	NULL),
		(-95, N'Individual',	N'Yisak Tegene',	0,		N'yisak.tegene@gmail.com',		NULL,						NULL,				N'Mr.',		'M',	NULL),
		(-94, N'Individual',	N'Zewdinesh Hora',	0,		N'zewdnesh.hora@gmail.com',		NULL,						NULL,				N'Ms.',		'F',	NULL),
		(-93, N'Individual',	N'Tigist Negash',	0,		N'tigistnegash74@gmail.com',	NULL,						NULL,				N'Ms.',		'F',	NULL),
		(-92, N'Individual',	N'Roman Zenebe',	0,		N'roman.zen12@gmail.com',		NULL,						NULL,				N'Ms.',		'F',	NULL),
		(-91, N'Individual',	N'Mestawet G/Egziyabhare',	0,N'mestawetezige@gmail.com',	NULL,						NULL,				N'Ms.',		'F',	NULL),
		(-90, N'Individual',	N'Ayelech Hora',	0,		N'ayelech.hora@gmail.com',		NULL,						NULL,				N'Ms.',		'F',	NULL),
		(-89, N'Individual',	N'Yigezu Legesse',	0,		NULL,							NULL,						NULL,				N'ATO',		'F',	NULL),

		(-88, N'Organization', N'Banan Information technologies, plc', 1, N'info@banan-it.com',N'0054901530',	N'AA, Bole, 316/3/203 A',	NULL,		NULL, '2017.08.09'),
		(-87, N'Organization', N'Walia Steel Industry, plc', 1, NULL,						N'0001656462',				NULL,				NULL,		NULL,	NULL),
		(-86, N'Organization', N'Yangfan Motors, PLC', 0,	NULL,							N'0005306731',		N'AA, Bole, 06, New',		NULL,		NULL,	NULL),
		(-85, N'Organization', N'Sisay Tesfaye, PLC', 0,	NULL,							N'',						NULL,				NULL,		NULL,	NULL),
		(-84, N'Organization', N'Ethiopian Revenues and Customs Authority', 0, NULL,		NULL,						NULL,				NULL,		NULL,	NULL),
		(-83, N'Organization', N'Best Paint Industry', 0,  NULL,							NULL,						NULL,				NULL,		NULL,	NULL),
		(-82, N'Organization', N'Best Plastic Industry', 0, NULL,							NULL,						NULL,				NULL,		NULL,	NULL),
		(-81, N'Organization', N'Commercial Bank of Ethiopia', 0, NULL,						NULL,						NULL,				NULL,		NULL,	NULL),
		(-80, N'Organization', N'Awash Bank', 0,			NULL,							NULL,						NULL,				NULL,		NULL,	NULL),
		(-79, N'Organization', N'NIB', 0,					NULL,							NULL,						NULL,				NULL,		NULL,	NULL),
		
		(-60, N'OrganizationUnit', N'Executive Office', 0,		NULL,							NULL,						NULL,				NULL,		NULL,	NULL),
		(-59, N'OrganizationUnit', N'Production', 0,		NULL,							NULL,						NULL,				NULL,		NULL,	NULL),
		(-58, N'OrganizationUnit', N'Sales & Marketing', 0, NULL,							NULL,						NULL,				NULL,		NULL,	NULL),
		(-57, N'OrganizationUnit', N'Finance', 0,			NULL,							NULL,						NULL,				NULL,		NULL,	NULL),
		(-56, N'OrganizationUnit', N'Human Resources', 0,	NULL,							NULL,						NULL,				NULL,		NULL,	NULL),
		(-55, N'OrganizationUnit', N'Materials & Purchasing', 0,	NULL,					NULL,						NULL,				NULL,		NULL,	NULL);

		DELETE FROM @AgentsResult; INSERT INTO @AgentsResult([Id], [AgentType], [Name], [IsActive], [IsRelated], [UserId], [TaxIdentificationNumber], [RegisteredAddress], [Title], [Gender], [BirthDateTime], [Status], [TemporaryId])
		EXEC  [dbo].[api_Agents__Save]  @Agents = @Agents; DELETE FROM @Agents WHERE [Status] IN (N'Inserted', N'Updated', 'Deleted'); INSERT INTO @Agents SELECT * FROM @AgentsResult;
	END
	BEGIN -- Updating MA TIN
		UPDATE @Agents 
		SET 
			[TaxIdentificationNumber] = N'0059603732',
			[Status] = N'Updated'
		WHERE [Id] = 1;

		DELETE FROM @AgentsResult; INSERT INTO @AgentsResult([Id], [AgentType], [Name], [IsActive], [IsRelated], [UserId], [TaxIdentificationNumber], [RegisteredAddress], [Title], [Gender], [BirthDateTime], [Status], [TemporaryId])
		EXEC  [dbo].[api_Agents__Save]  @Agents = @Agents; DELETE FROM @Agents WHERE [Status] IN (N'Inserted', N'Updated', 'Deleted'); INSERT INTO @Agents SELECT * FROM @AgentsResult;
	END	
	BEGIN -- Deleting MA Record
		UPDATE @Agents SET [Status] = N'Deleted' WHERE [Id] = 1;

		DELETE FROM @AgentsResult; INSERT INTO @AgentsResult([Id], [AgentType], [Name], [IsActive], [IsRelated], [UserId], [TaxIdentificationNumber], [RegisteredAddress], [Title], [Gender], [BirthDateTime], [Status], [TemporaryId])
	EXEC  [dbo].[api_Agents__Save]  @Agents = @Agents; DELETE FROM @Agents WHERE [Status] IN (N'Inserted', N'Updated', 'Deleted'); INSERT INTO @Agents SELECT * FROM @AgentsResult;
	END
	SELECT * FROM @Agents;
	SELECT 
		@MohamadAkra = (SELECT [Id] FROM @Agents WHERE [Name] = N'Mohamad Akra'), 
		@AhmadAkra = (SELECT [Id] FROM @Agents WHERE [Name] = N'Ahmad Akra'), 
		@BadegeKebede = (SELECT [Id] FROM @Agents WHERE [Name] = N'Badege Kebede'), 
		@TizitaNigussie = (SELECT [Id] FROM @Agents WHERE [Name] = N'Tizita Nigussie'), 
		@Ashenafi = (SELECT [Id] FROM @Agents WHERE [Name] = N'Ashenafi Fantahun'), 
		@YisakTegene = (SELECT [Id] FROM @Agents WHERE [Name] = N'Yisak Tegene'), 
		@ZewdineshHora = (SELECT [Id] FROM @Agents WHERE [Name] = N'Zewdinesh Hora'), 
		@TigistNegash = (SELECT [Id] FROM @Agents WHERE [Name] = N'Tigist Negash'), 
		@RomanZenebe = (SELECT [Id] FROM @Agents WHERE [Name] = N'Roman Zenebe'), 
		@Mestawet = (SELECT [Id] FROM @Agents WHERE [Name] = N'Mestawet G/Egziyabhare'), 
		@AyelechHora = (SELECT [Id] FROM @Agents WHERE [Name] = N'Ayelech Hora'), 
		@YigezuLegesse = (SELECT [Id] FROM @Agents WHERE [Name] = N'Yigezu Legesse'), 
		@BananIT = (SELECT [Id] FROM @Agents WHERE [Name] = N'Banan Information technologies, plc'),
		@WaliaSteel = (SELECT [Id] FROM @Agents WHERE [Name] = N'Walia Steel Industry, plc'),
		@Lifan = (SELECT [Id] FROM @Agents WHERE [Name] = N'Yangfan Motors, PLC'),
		@Sesay = (SELECT [Id] FROM @Agents WHERE [Name] = N'Sisay Tesfaye, PLC'),
		@ERCA = (SELECT [Id] FROM @Agents WHERE [Name] = N'Ethiopian Revenues and Customs Authority'),
		@Paint = (SELECT [Id] FROM @Agents WHERE [Name] = N'Best Paint Industry'),
		@Plastic = (SELECT [Id] FROM @Agents WHERE [Name] = N'Best Plastic Industry'),
		@CBE = (SELECT [Id] FROM @Agents WHERE [Name] = N'Commercial Bank of Ethiopia'),
		@AWB = (SELECT [Id] FROM @Agents WHERE [Name] = N'Awash Bank'),
		@NIB = (SELECT [Id] FROM @Agents WHERE [Name] = N'NIB'),

		@ExecutiveOffice = (SELECT [Id] FROM @Agents WHERE [Name] = N'Executive Office'),
		@Production = (SELECT [Id] FROM @Agents WHERE [Name] = N'Production'),
		@Sales = (SELECT [Id] FROM @Agents WHERE [Name] = N'Sales & Marketing'),
		@Finance = (SELECT [Id] FROM @Agents WHERE [Name] = N'Finance'),
		@HR = (SELECT [Id] FROM @Agents WHERE [Name] = N'Human Resources'),
		@Purchasing = (SELECT [Id] FROM @Agents WHERE [Name] = N'Materials & Purchasing');
END
BEGIN -- Locations
	BEGIN -- Insert 
		INSERT INTO @Locations
		([Id], [LocationType], [Name],						[Address], [Parent],[CustodianId]) VALUES
		(-100, N'Warehouse',	N'Raw Materials Warehouse', NULL,		NULL,	NULL),
		(-99, N'Warehouse',	N'Fake Warehouse', NULL,		NULL,	NULL),
		(-98, N'Warehouse',		N'Finished Goods Warehouse', NULL,		NULL,	NULL);

		DELETE FROM @LocationsResult; INSERT INTO @LocationsResult([Id], [LocationType], [Name], [IsActive], [Address], [Parent],[CustodianId], [Status], [TemporaryId])
		EXEC  [dbo].[api_Locations__Save]  @Locations = @Locations; DELETE FROM @Locations WHERE [Status] IN (N'Inserted', N'Updated', 'Deleted'); INSERT INTO @Locations SELECT * FROM @LocationsResult;
	END
	BEGIN -- Updating RM Warehouse address
		UPDATE @Locations 
		SET 
			[Address] = N'Alemgena, Oromia',
			[Status] = N'Updated'
		WHERE [Name] = N'Raw Materials Warehouse';

		DELETE FROM @LocationsResult; INSERT INTO @LocationsResult([Id], [LocationType], [Name], [IsActive], [Address], [Parent],[CustodianId], [Status], [TemporaryId])
		EXEC  [dbo].[api_Locations__Save]  @Locations = @Locations; DELETE FROM @Locations WHERE [Status] IN (N'Inserted', N'Updated', 'Deleted'); INSERT INTO @Locations SELECT * FROM @LocationsResult;
	END
	BEGIN -- Updating RM Warehouse address
		UPDATE @Locations 
		SET 
			[Status] = N'Deleted'
		WHERE [Name] = N'Fake Warehouse';

		DELETE FROM @LocationsResult; INSERT INTO @LocationsResult([Id], [LocationType], [Name], [IsActive], [Address], [Parent],[CustodianId], [Status], [TemporaryId])
		EXEC  [dbo].[api_Locations__Save]  @Locations = @Locations; DELETE FROM @Locations WHERE [Status] IN (N'Inserted', N'Updated', 'Deleted'); INSERT INTO @Locations SELECT * FROM @LocationsResult;
	END	
	SELECT * FROM @Locations;
	SELECT
		@RawMaterialsWarehouse = (SELECT [Id] FROM @Locations WHERE [Name] = N'Raw Materials Warehouse'), 
		@FinishedGoodsWarehouse = (SELECT [Id] FROM @Locations WHERE [Name] = N'Finished Goods Warehouse');
END

INSERT INTO @Settings([Field],[Value]) Values(N'TaxAuthority', @ERCA);
DELETE FROM @SettingsResult; INSERT INTO @SettingsResult([Field], [Value], [Status])
EXEC  [dbo].[api_Settings__Save]  @Settings = @Settings; DELETE FROM @Settings WHERE [Status] IN (N'Inserted', N'Updated', 'Deleted'); INSERT INTO @Settings SELECT * FROM @SettingsResult;
