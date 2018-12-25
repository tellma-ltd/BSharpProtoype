BEGIN -- Cleanup & Declarations
	DECLARE @A1Save [dbo].AgentForSaveList, @A2Save [dbo].AgentForSaveList;
	DECLARE @A1Result [dbo].AgentList, @A2Result [dbo].AgentList;
	DECLARE @A1ResultJson NVARCHAR(MAX), @A2ResultJson NVARCHAR(MAX);

	DECLARE @MohamadAkra int, @AhmadAkra int, @BadegeKebede int, @TizitaNigussie int, @Ashenafi int, @YisakTegene int,
			@ZewdineshHora int, @TigistNegash int, @RomanZenebe int, @Mestawet int, @AyelechHora int, @YigezuLegesse int,
			@MesfinWolde int;
	DECLARE @BananIT int, @WaliaSteel int, @Lifan int, @Sesay int, @ERCA int, @Paint int, @Plastic int, @CBE int, @AWB int,
			@NIB int, @Regus int;
	DECLARE @GeneralManager int, @ProductionManager int, @SalesManager int, @FinanceManager int, @HRManager int,
			@PurchasingManager int;
END
BEGIN -- Users
	IF NOT EXISTS(SELECT * FROM [dbo].Users)
	INSERT INTO [dbo].Users([Id], FriendlyName) VALUES
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
BEGIN -- Insert individuals and organizations
	INSERT INTO @A1Save
	([AgentType],		[Name],			[IsRelated], [UserId],					[TaxIdentificationNumber], [Address], [Title], [Gender], [BirthDateTime]) VALUES
	(N'Individual',	N'Mohamad Akra',	0,		 N'mohamad.akra@banan-it.com',	NULL,						NULL,				N'Dr.',		'M',	'1966.02.19'),
	(N'Individual',	N'Ahmad Akra',		0,		 N'ahmad.akra@banan-it.com',	NULL,						NULL,				N'Mr.',		'M',	'1992.09.21'),
	(N'Individual',	N'Badege Kebede',	1,		 N'badegek@gmail.com',			NULL,						NULL,				N'ATO',		'M',	NULL),
	(N'Individual',	N'Tizita Nigussie',	0,		N'mintewelde00@gmail.com',		NULL,						NULL,				N'Ms.', 	'F',	NULL),
	(N'Individual',	N'Ashenafi Fantahun',0,		N'ashenafi935@gmail.com',		NULL,						NULL,				N'Mr.',		'M',	NULL),
	(N'Individual',	N'Yisak Tegene',	0,		N'yisak.tegene@gmail.com',		NULL,						NULL,				N'Mr.',		'M',	NULL),
	(N'Individual',	N'Zewdinesh Hora',	0,		N'zewdnesh.hora@gmail.com',		NULL,						NULL,				N'Ms.',		'F',	NULL),
	(N'Individual',	N'Tigist Negash',	0,		N'tigistnegash74@gmail.com',	NULL,						NULL,				N'Ms.',		'F',	NULL),
	(N'Individual',	N'Roman Zenebe',	0,		N'roman.zen12@gmail.com',		NULL,						NULL,				N'Ms.',		'F',	NULL),
	(N'Individual',	N'Mestawet G/Egziyabhare',	0,N'mestawetezige@gmail.com',	NULL,						NULL,				N'Ms.',		'F',	NULL),
	(N'Individual',	N'Ayelech Hora',	0,		N'ayelech.hora@gmail.com',		NULL,						NULL,				N'Ms.',		'F',	NULL),
	(N'Individual',	N'Yigezu Legesse',	0,		NULL,							NULL,						NULL,				N'ATO',		'F',	NULL),
	(N'Individual',	N'Mesfin Wolde',	0,		NULL,							N'0059603732',				NULL,				N'Eng.',		'M',	NULL),

	(N'Organization', N'Banan Information technologies, plc', 1, N'info@banan-it.com',N'0054901530', N'AA, Bole, 316/3/203 A',	NULL,		NULL,	'2017.08.09'),
	(N'Organization', N'Walia Steel Industry, plc', 1, NULL,					N'0001656462',				NULL,				NULL,		NULL,	NULL),
	(N'Organization', N'Yangfan Motors, PLC', 0,	NULL,						N'0005306731',		N'AA, Bole, 06, New',		NULL,		NULL,	NULL),
	(N'Organization', N'Sisay Tesfaye, PLC', 0,	NULL,							N'',						NULL,				NULL,		NULL,	NULL),
	(N'Organization', N'Ethiopian Revenues and Customs Authority', 0, NULL,		NULL,						NULL,				NULL,		NULL,	NULL),
	(N'Organization', N'Best Paint Industry', 0,NULL,							NULL,						NULL,				NULL,		NULL,	NULL),
	(N'Organization', N'Best Plastic Industry', 0, NULL,						NULL,						NULL,				NULL,		NULL,	NULL),
	(N'Organization', N'Commercial Bank of Ethiopia', 0, NULL,					NULL,						NULL,				NULL,		NULL,	NULL),
	(N'Organization', N'Awash Bank',	0,		NULL,							NULL,						NULL,				NULL,		NULL,	NULL),
	(N'Organization', N'NIB',			0,		NULL,							NULL,						NULL,				NULL,		NULL,	NULL),
	(N'Organization', N'Regus',			0,		NULL,							N'0008895353',		N'AA, Girgi, 22, New',		NULL,		NULL,	NULL),
	
	(N'Position', N'General Manager',	1,		NULL,							NULL,						NULL,				NULL,		NULL,	NULL),
	(N'Position', N'Production Manager', 0,		NULL,							NULL,						NULL,				NULL,		NULL,	NULL),
	(N'Position', N'Sales & Marketing Manager', 0,	NULL,						NULL,						NULL,				NULL,		NULL,	NULL),
	(N'Position', N'Finance Manager',	0,		NULL,							NULL,						NULL,				NULL,		NULL,	NULL),
	(N'Position', N'Human Resources Manager', 0,NULL,							NULL,						NULL,				NULL,		NULL,	NULL),
	(N'Position', N'Materials & Purchasing Manager', 0,	NULL,					NULL,						NULL,				NULL,		NULL,	NULL);

	EXEC [dbo].[api_Agents__Save]
		@Entities = @A1Save,
		@ValidationErrorsJson = @ValidationErrorsJson OUTPUT,
		@EntitiesResultJson = @A1ResultJson OUTPUT

	IF @ValidationErrorsJson IS NOT NULL 
	BEGIN
		Print 'Agents: Location 1'
		GOTO Err_Label;
	END
	INSERT INTO @A1Result(
		[Id], [AgentType], [Name], [IsActive], [Code], [Address], [BirthDateTime], [CreatedAt], [CreatedBy],
		[ModifiedAt], [ModifiedBy], [IsRelated], [UserId], [TaxIdentificationNumber], [Title], [Gender], [EntityState]
	)
	SELECT 
		[Id], [AgentType], [Name], [IsActive], [Code], [Address], [BirthDateTime], [CreatedAt], [CreatedBy],
		[ModifiedAt], [ModifiedBy], [IsRelated], [UserId], [TaxIdentificationNumber], [Title], [Gender], [EntityState]
	FROM OpenJson(@A1ResultJson)
	WITH (
		[Id] INT '$.Id',
		[AgentType] NVARCHAR (255) '$.AgentType',
		[Name] NVARCHAR (255) '$.Name',
		[IsActive] BIT '$.IsActive',
		[Code] NVARCHAR (255) '$.Code',
		[Address] NVARCHAR (255) '$.Address',
		[BirthDateTime] DATETIMEOFFSET (7) '$.BirthDateTime',
		[CreatedAt] DATETIMEOFFSET(7) '$.CreatedAt',
		[CreatedBy] NVARCHAR(450) '$.CreatedBy',
		[ModifiedAt] DATETIMEOFFSET(7) '$.ModifiedAt',
		[ModifiedBy] NVARCHAR(450) '$.ModifiedBy',
		[IsRelated] BIT '$.IsRelated', 
		[UserId] NVARCHAR (450) '$.UserId', 
		[TaxIdentificationNumber] NVARCHAR (255) '$.TaxIdentificationNumber',
		[Title] NVARCHAR (255) '$.Title',
		[Gender] NCHAR (1) '$.Gender',
		[EntityState] NVARCHAR(255) '$.EntityState'
	);
END

-- Inserting
INSERT INTO @A2Save (
	 [Id], [AgentType], [Name], [Code], [IsRelated], [UserId], [TaxIdentificationNumber], [Address], [Title], [Gender], [BirthDateTime], [EntityState])
SELECT
	A.[Id], [AgentType], [Name], [Code], [IsRelated], [UserId], [TaxIdentificationNumber], [Address], [Title], [Gender], [BirthDateTime], N'Unchanged'
FROM [dbo].Agents A
JOIN [dbo].[Custodies] C ON A.Id = C.Id
WHERE [Name] Like N'%Akra' OR [Name] Like N'Y%';

-- Updating MA TIN
	UPDATE @A2Save
	SET 
		[TaxIdentificationNumber] = N'0059603732',
		[EntityState] = N'Updated'
	WHERE [Name] = N'Ahmad Akra';

	--UPDATE @A2Save 
	--SET 
	--	[Code] = N'MA',
	--	[EntityState] = N'Updated'
	--WHERE [Name] Like N'%Akra';

-- Deleting Legesse record
	UPDATE @A2Save
	SET [EntityState] = N'Deleted' 
	WHERE [Name] = N'Yigezu Legesse';

	EXEC [dbo].[api_Agents__Save]
		@Entities = @A2Save,
		@ValidationErrorsJson = @ValidationErrorsJson OUTPUT,
		@EntitiesResultJson = @A2ResultJson OUTPUT

	IF @ValidationErrorsJson IS NOT NULL 
	BEGIN
		Print 'Agents: Location 2'
		GOTO Err_Label;
	END;
	
	INSERT INTO @A2Result(
		[Id], [AgentType], [Name], [IsActive], [Code], [Address], [BirthDateTime], [CreatedAt], [CreatedBy],
		[ModifiedAt], [ModifiedBy], [IsRelated], [UserId], [TaxIdentificationNumber], [Title], [Gender], [EntityState]
	)
	SELECT 		
		[Id], [AgentType], [Name], [IsActive], [Code], [Address], [BirthDateTime], [CreatedAt], [CreatedBy],
		[ModifiedAt], [ModifiedBy], [IsRelated], [UserId], [TaxIdentificationNumber], [Title], [Gender], [EntityState]
	FROM OpenJson(@A2ResultJson)
	WITH (
		[Id] INT '$.Id',
		[AgentType] NVARCHAR (255) '$.AgentType', 
		[Name] NVARCHAR (255) '$.Name',
		[IsActive] BIT '$.IsActive',
		[Code] NVARCHAR (255) '$.Code',
		[Address] NVARCHAR (255) '$.Address',
		[BirthDateTime] DATETIMEOFFSET (7) '$.BirthDateTime',
		[CreatedAt] DATETIMEOFFSET(7) '$.CreatedAt',
		[CreatedBy] NVARCHAR(450) '$.CreatedBy',
		[ModifiedAt] DATETIMEOFFSET(7) '$.ModifiedAt',
		[ModifiedBy] NVARCHAR(450) '$.ModifiedBy',
		[IsRelated] BIT '$.IsRelated', 
		[UserId] NVARCHAR (450) '$.UserId', 
		[TaxIdentificationNumber] NVARCHAR (255) '$.TaxIdentificationNumber',
		[Title] NVARCHAR (255) '$.Title',
		[Gender] NCHAR (1) '$.Gender',
		[EntityState] NVARCHAR(255) '$.EntityState'
	);
	IF @LookupsSelect = 1
	BEGIN
		SELECT * FROM @A1Result; SELECT * FROM @A2Result;
		SELECT * FROM [dbo].[Custodies];
	END
SELECT 
	@MohamadAkra = (SELECT [Id] FROM @A1Result WHERE [Name] = N'Mohamad Akra'), 
	@AhmadAkra = (SELECT [Id] FROM @A1Result WHERE [Name] = N'Ahmad Akra'), 
	@BadegeKebede = (SELECT [Id] FROM @A1Result WHERE [Name] = N'Badege Kebede'), 
	@TizitaNigussie = (SELECT [Id] FROM @A1Result WHERE [Name] = N'Tizita Nigussie'), 
	@Ashenafi = (SELECT [Id] FROM @A1Result WHERE [Name] = N'Ashenafi Fantahun'), 
	@YisakTegene = (SELECT [Id] FROM @A1Result WHERE [Name] = N'Yisak Tegene'), 
	@ZewdineshHora = (SELECT [Id] FROM @A1Result WHERE [Name] = N'Zewdinesh Hora'), 
	@TigistNegash = (SELECT [Id] FROM @A1Result WHERE [Name] = N'Tigist Negash'), 
	@RomanZenebe = (SELECT [Id] FROM @A1Result WHERE [Name] = N'Roman Zenebe'), 
	@Mestawet = (SELECT [Id] FROM @A1Result WHERE [Name] = N'Mestawet G/Egziyabhare'), 
	@AyelechHora = (SELECT [Id] FROM @A1Result WHERE [Name] = N'Ayelech Hora'), 
	@YigezuLegesse = (SELECT [Id] FROM @A1Result WHERE [Name] = N'Yigezu Legesse'), 
	@MesfinWolde = (SELECT [Id] FROM @A1Result WHERE [Name] = N'Mesfin Wolde'),
	@BananIT = (SELECT [Id] FROM @A1Result WHERE [Name] = N'Banan Information technologies, plc'),
	@WaliaSteel = (SELECT [Id] FROM @A1Result WHERE [Name] = N'Walia Steel Industry, plc'),
	@Lifan = (SELECT [Id] FROM @A1Result WHERE [Name] = N'Yangfan Motors, PLC'),
	@Sesay = (SELECT [Id] FROM @A1Result WHERE [Name] = N'Sisay Tesfaye, PLC'),
	@ERCA = (SELECT [Id] FROM @A1Result WHERE [Name] = N'Ethiopian Revenues and Customs Authority'),
	@Paint = (SELECT [Id] FROM @A1Result WHERE [Name] = N'Best Paint Industry'),
	@Plastic = (SELECT [Id] FROM @A1Result WHERE [Name] = N'Best Plastic Industry'),
	@CBE = (SELECT [Id] FROM @A1Result WHERE [Name] = N'Commercial Bank of Ethiopia'),
	@AWB = (SELECT [Id] FROM @A1Result WHERE [Name] = N'Awash Bank'),
	@NIB = (SELECT [Id] FROM @A1Result WHERE [Name] = N'NIB'),
	@Regus = (SELECT [Id] FROM @A1Result WHERE [Name] = N'Regus'),

	@GeneralManager = (SELECT [Id] FROM @A1Result WHERE [Name] = N'General Manager'),
	@ProductionManager = (SELECT [Id] FROM @A1Result WHERE [Name] = N'Production Manager'),
	@SalesManager = (SELECT [Id] FROM @A1Result WHERE [Name] = N'Sales & Marketing Manager'),
	@FinanceManager = (SELECT [Id] FROM @A1Result WHERE [Name] = N'Finance Manager'),
	@HRManager = (SELECT [Id] FROM @A1Result WHERE [Name] = N'Human Resources Manager'),
	@PurchasingManager = (SELECT [Id] FROM @A1Result WHERE [Name] = N'Materials & Purchasing Manager');

--		SELECT @MohamadAkra AS MA, @AhmadAkra AS AA, @TigistNegash AS TN, @TizitaNigussie As Tiz;
DECLARE @AgentSettingSave [dbo].SettingForSaveList, @AgentSettingResultJson nvarchar(max)

INSERT INTO @AgentSettingSave
([Field],[Value]) Values(N'TaxAuthority', @ERCA);

EXEC [dbo].[api_Settings__Save]
		@Settings = @AgentSettingSave,
		@ValidationErrorsJson = @ValidationErrorsJson OUTPUT,
		@SettingsResultJson = @AgentSettingResultJson OUTPUT