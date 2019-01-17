BEGIN -- Cleanup & Declarations
	DECLARE @AgentsDTO [dbo].[AgentList];

	DECLARE @MohamadAkra int, @AhmadAkra int, @BadegeKebede int, @TizitaNigussie int, @Ashenafi int, @YisakTegene int,
			@ZewdineshHora int, @TigistNegash int, @RomanZenebe int, @Mestawet int, @AyelechHora int, @YigezuLegesse int,
			@MesfinWolde int;
	DECLARE @BananIT int, @WaliaSteel int, @Lifan int, @Sesay int, @ERCA int, @Paint int, @Plastic int, @CBE int, @AWB int,
			@NIB int, @Regus int;
	DECLARE @GeneralManager int, @ProductionManager int, @SalesManager int, @FinanceManager int, @HRManager int,
			@PurchasingManager int;
END
BEGIN -- Users
	DECLARE @TenantId int = CONVERT(INT, SESSION_CONTEXT(N'TenantId'));
	IF NOT EXISTS(SELECT * FROM [dbo].Users)
	INSERT INTO [dbo].Users([TenantId], [Id], [Name]) VALUES
	(@TenantId, N'system@banan-it.com', N'B#'),
	(@TenantId, N'mohamad.akra@banan-it.com', N'Mohamad Akra'),
	(@TenantId, N'ahmad.akra@banan-it.com', N'Ahmad Akra'),
	(@TenantId, N'badegek@gmail.com', N'Badege'),
	(@TenantId, N'mintewelde00@gmail.com', N'Tizita'),
	(@TenantId, N'ashenafi935@gmail.com', N'Ashenafi'),
	(@TenantId, N'yisak.tegene@gmail.com', N'Yisak'),
	(@TenantId, N'zewdnesh.hora@gmail.com', N'Zewdinesh Hora'),
	(@TenantId, N'tigistnegash74@gmail.com', N'Tigist'),
	(@TenantId, N'roman.zen12@gmail.com', N'Roman'),
	(@TenantId, N'mestawetezige@gmail.com', N'Mestawet'),
	(@TenantId, N'ayelech.hora@gmail.com', N'Ayelech'),
	(@TenantId, N'info@banan-it.com', N'Banan IT'),
	(@TenantId, N'DESKTOP-V0VNDC4\Mohamad Akra', N'Dr. Akra')
END
BEGIN -- Insert individuals and organizations
	INSERT INTO @AgentsDTO
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
		@Entities = @AgentsDTO,
		@ValidationErrorsJson = @ValidationErrorsJson OUTPUT,
		@ResultsJson = @ResultsJson OUTPUT

	IF @ValidationErrorsJson IS NOT NULL 
	BEGIN
		Print 'Agents: Place 1'
		GOTO Err_Label;
	END;

	IF @DebugAgents = 1
		SELECT * FROM [dbo].[fr_Agents__Json](@ResultsJson);
END

-- Inserting
DELETE FROM @AgentsDTO;
INSERT INTO @AgentsDTO (
	[Id], [AgentType], [Name], [Code], [IsRelated], [UserId], [TaxIdentificationNumber], [Address], [Title], [Gender], [BirthDateTime], [EntityState])
SELECT
	[Id], [AgentType], [Name], [Code], [IsRelated], [UserId], [TaxIdentificationNumber], [Address], [Title], [Gender], [BirthDateTime], N'Unchanged'
FROM [dbo].[Custodies]
WHERE [Name] Like N'%Akra' OR [Name] Like N'Y%';

-- Updating MA TIN
	UPDATE @AgentsDTO
	SET 
		[TaxIdentificationNumber] = N'0059603732',
		[EntityState] = N'Updated'
	WHERE [Name] = N'Ahmad Akra';

	--UPDATE @AgentsDTO 
	--SET 
	--	[Code] = N'MA',
	--	[EntityState] = N'Updated'
	--WHERE [Name] Like N'%Akra';

-- Deleting Legesse record
	UPDATE @AgentsDTO
	SET [EntityState] = N'Deleted' 
	WHERE [Name] = N'Yigezu Legesse';

	EXEC [dbo].[api_Agents__Save]
		@Entities = @AgentsDTO,
		@ValidationErrorsJson = @ValidationErrorsJson OUTPUT,
		@ResultsJson = @ResultsJson OUTPUT

	IF @ValidationErrorsJson IS NOT NULL 
	BEGIN
		Print 'Agents: Place 2'
		GOTO Err_Label;
	END;
	
	IF @DebugAgents = 1
		SELECT * FROM [dbo].[fr_Agents__Json](@ResultsJson);

	IF @DebugAgents = 1
		SELECT * FROM [dbo].[Custodies];

SELECT 
	@MohamadAkra = (SELECT [Id] FROM [dbo].[Custodies] WHERE [Name] = N'Mohamad Akra'), 
	@AhmadAkra = (SELECT [Id] FROM [dbo].[Custodies] WHERE [Name] = N'Ahmad Akra'), 
	@BadegeKebede = (SELECT [Id] FROM [dbo].[Custodies] WHERE [Name] = N'Badege Kebede'), 
	@TizitaNigussie = (SELECT [Id] FROM [dbo].[Custodies] WHERE [Name] = N'Tizita Nigussie'), 
	@Ashenafi = (SELECT [Id] FROM [dbo].[Custodies] WHERE [Name] = N'Ashenafi Fantahun'), 
	@YisakTegene = (SELECT [Id] FROM [dbo].[Custodies] WHERE [Name] = N'Yisak Tegene'), 
	@ZewdineshHora = (SELECT [Id] FROM [dbo].[Custodies] WHERE [Name] = N'Zewdinesh Hora'), 
	@TigistNegash = (SELECT [Id] FROM [dbo].[Custodies] WHERE [Name] = N'Tigist Negash'), 
	@RomanZenebe = (SELECT [Id] FROM [dbo].[Custodies] WHERE [Name] = N'Roman Zenebe'), 
	@Mestawet = (SELECT [Id] FROM [dbo].[Custodies] WHERE [Name] = N'Mestawet G/Egziyabhare'), 
	@AyelechHora = (SELECT [Id] FROM [dbo].[Custodies] WHERE [Name] = N'Ayelech Hora'), 
	@YigezuLegesse = (SELECT [Id] FROM [dbo].[Custodies] WHERE [Name] = N'Yigezu Legesse'), 
	@MesfinWolde = (SELECT [Id] FROM [dbo].[Custodies] WHERE [Name] = N'Mesfin Wolde'),
	@BananIT = (SELECT [Id] FROM [dbo].[Custodies] WHERE [Name] = N'Banan Information technologies, plc'),
	@WaliaSteel = (SELECT [Id] FROM [dbo].[Custodies] WHERE [Name] = N'Walia Steel Industry, plc'),
	@Lifan = (SELECT [Id] FROM [dbo].[Custodies] WHERE [Name] = N'Yangfan Motors, PLC'),
	@Sesay = (SELECT [Id] FROM [dbo].[Custodies] WHERE [Name] = N'Sisay Tesfaye, PLC'),
	@ERCA = (SELECT [Id] FROM [dbo].[Custodies] WHERE [Name] = N'Ethiopian Revenues and Customs Authority'),
	@Paint = (SELECT [Id] FROM [dbo].[Custodies] WHERE [Name] = N'Best Paint Industry'),
	@Plastic = (SELECT [Id] FROM [dbo].[Custodies] WHERE [Name] = N'Best Plastic Industry'),
	@CBE = (SELECT [Id] FROM [dbo].[Custodies] WHERE [Name] = N'Commercial Bank of Ethiopia'),
	@AWB = (SELECT [Id] FROM [dbo].[Custodies] WHERE [Name] = N'Awash Bank'),
	@NIB = (SELECT [Id] FROM [dbo].[Custodies] WHERE [Name] = N'NIB'),
	@Regus = (SELECT [Id] FROM [dbo].[Custodies] WHERE [Name] = N'Regus'),

	@GeneralManager = (SELECT [Id] FROM [dbo].[Custodies] WHERE [Name] = N'General Manager'),
	@ProductionManager = (SELECT [Id] FROM [dbo].[Custodies] WHERE [Name] = N'Production Manager'),
	@SalesManager = (SELECT [Id] FROM [dbo].[Custodies] WHERE [Name] = N'Sales & Marketing Manager'),
	@FinanceManager = (SELECT [Id] FROM [dbo].[Custodies] WHERE [Name] = N'Finance Manager'),
	@HRManager = (SELECT [Id] FROM [dbo].[Custodies] WHERE [Name] = N'Human Resources Manager'),
	@PurchasingManager = (SELECT [Id] FROM [dbo].[Custodies] WHERE [Name] = N'Materials & Purchasing Manager');

--		SELECT @MohamadAkra AS MA, @AhmadAkra AS AA, @TigistNegash AS TN, @TizitaNigussie As Tiz;
DECLARE @AgentSettingSave [dbo].SettingList, @AgentSettingResultJson nvarchar(max)

INSERT INTO @AgentSettingSave
([Field],[Value]) Values(N'TaxAuthority', @ERCA);

EXEC [dbo].[api_Settings__Save]
		@Settings = @AgentSettingSave,
		@ValidationErrorsJson = @ValidationErrorsJson OUTPUT,
		@ResultsJson = @AgentSettingResultJson OUTPUT
