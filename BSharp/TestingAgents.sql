BEGIN -- Cleanup & Declarations
	DECLARE @A1 AgentForSaveList, @A2 AgentForSaveList;
	DECLARE @MohamadAkra int, @AhmadAkra int, @BadegeKebede int, @TizitaNigussie int, @Ashenafi int, @YisakTegene int, @ZewdineshHora int, @TigistNegash int, @RomanZenebe int, @Mestawet int, @AyelechHora int, @YigezuLegesse int;
	DECLARE @BananIT int, @WaliaSteel int, @Lifan int, @Sesay int, @ERCA int, @Paint int, @Plastic int, @CBE int, @AWB int, @NIB int;
	DECLARE @ExecutiveOffice int, @Production int, @Sales int, @Finance int, @HR int, @Purchasing int;
END
BEGIN -- Users
	IF NOT EXISTS(SELECT * FROM [dbo].Users)
	INSERT INTO [dbo].Users(Id, FriendlyName) VALUES
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
	INSERT INTO @A1
	([AgentType],		[Name],			[IsRelated], [UserId],					[TaxIdentificationNumber], [RegisteredAddress], [Title], [Gender], [BirthDateTime]) VALUES
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

	(N'Organization', N'Banan Information technologies, plc', 1, N'info@banan-it.com',N'0054901530',	N'AA, Bole, 316/3/203 A',	NULL,		NULL, '2017.08.09'),
	(N'Organization', N'Walia Steel Industry, plc', 1, NULL,					N'0001656462',				NULL,				NULL,		NULL,	NULL),
	(N'Organization', N'Yangfan Motors, PLC', 0,	NULL,						N'0005306731',		N'AA, Bole, 06, New',		NULL,		NULL,	NULL),
	(N'Organization', N'Sisay Tesfaye, PLC', 0,	NULL,							N'',						NULL,				NULL,		NULL,	NULL),
	(N'Organization', N'Ethiopian Revenues and Customs Authority', 0, NULL,		NULL,						NULL,				NULL,		NULL,	NULL),
	(N'Organization', N'Best Paint Industry', 0,		NULL,					NULL,						NULL,				NULL,		NULL,	NULL),
	(N'Organization', N'Best Plastic Industry', 0, NULL,						NULL,						NULL,				NULL,		NULL,	NULL),
	(N'Organization', N'Commercial Bank of Ethiopia', 0, NULL,					NULL,						NULL,				NULL,		NULL,	NULL),
	(N'Organization', N'Awash Bank', 0,			NULL,							NULL,						NULL,				NULL,		NULL,	NULL),
	(N'Organization', N'NIB', 0,					NULL,						NULL,						NULL,				NULL,		NULL,	NULL),
		
	(N'OrganizationUnit', N'Executive Office', 0,		NULL,					NULL,						NULL,				NULL,		NULL,	NULL),
	(N'OrganizationUnit', N'Production', 0,		NULL,							NULL,						NULL,				NULL,		NULL,	NULL),
	(N'OrganizationUnit', N'Sales & Marketing', 0, NULL,						NULL,						NULL,				NULL,		NULL,	NULL),
	(N'OrganizationUnit', N'Finance', 0,			NULL,						NULL,						NULL,				NULL,		NULL,	NULL),
	(N'OrganizationUnit', N'Human Resources', 0,	NULL,						NULL,						NULL,				NULL,		NULL,	NULL),
	(N'OrganizationUnit', N'Materials & Purchasing', 0,	NULL,					NULL,						NULL,				NULL,		NULL,	NULL);

	EXEC  [dbo].[api_Agents__Save]
		@Agents = @A1,
		@ValidationErrorsJson = @ValidationErrorsJson OUTPUT,
		@IndexedIdsJson = @IndexedIdsJson OUTPUT

	IF @ValidationErrorsJson IS NOT NULL 
	BEGIN
		Print 'Agents: Location 1'
		GOTO Err_Label;
	END

	DELETE FROM @IndexedIds;
	INSERT INTO @IndexedIds
	SELECT * FROM OpenJson(@IndexedIdsJson)
	WITH ([Index] INT '$.Index', [Id] INT '$.Id');

	DELETE FROM @A1 WHERE [EntityState] IN ('Deleted');

	UPDATE T 
	SET T.[Id] = II.[Id], T.[EntityState] = N'Unchanged'
	FROM @A1 T 
	JOIN @IndexedIds II ON T.[Index] = II.[Index];
END

-- Inserting
INSERT INTO @A2 (
	  [Id], [AgentType], [Name], [Code], [IsRelated], [UserId], [TaxIdentificationNumber], [RegisteredAddress], [Title], [Gender], [BirthDateTime], [EntityState])
SELECT
	A.[Id], [AgentType], [Name], [Code], [IsRelated], [UserId], [TaxIdentificationNumber], [RegisteredAddress], [Title], [Gender], [BirthDateTime], N'Unchanged'
FROM dbo.Agents A
JOIN dbo.Custodies C ON A.Id = C.Id
WHERE [Name] Like N'%Akra' OR [Name] Like N'Y%';

-- Updating MA TIN
	UPDATE @A2
	SET 
		[TaxIdentificationNumber] = N'0059603732',
		[EntityState] = N'Updated'
	WHERE [Name] = N'Mohamad Akra';

	UPDATE @A2 
	SET 
		[Code] = N'MA',
		[EntityState] = N'Updated'
	WHERE [Name] Like N'%Akra';

-- Deleting Legesse record
	UPDATE @A2
	SET [EntityState] = N'Deleted' 
	WHERE [Name] = N'Yigezu Legesse';

	EXEC  [dbo].[api_Agents__Save]
		@Agents = @A2,
		@ValidationErrorsJson = @ValidationErrorsJson OUTPUT,
		@IndexedIdsJson = @IndexedIdsJson OUTPUT

	IF @ValidationErrorsJson IS NOT NULL 
	BEGIN
		Print 'Agents: Location 2'
		GOTO Err_Label;
	END;

	DELETE FROM @IndexedIds;
	INSERT INTO @IndexedIds
	SELECT * FROM OpenJson(@IndexedIdsJson)
	WITH ([Index] INT '$.Index', [Id] INT '$.Id');

	DELETE FROM @A2 WHERE [EntityState] IN ('Deleted');

	UPDATE T 
	SET T.[Id] = II.[Id], T.[EntityState] = N'Unchanged'
	FROM @A2 T 
	JOIN @IndexedIds II ON T.[Index] = II.[Index];
SELECT 
	@MohamadAkra = (SELECT [Id] FROM @A1 WHERE [Name] = N'Mohamad Akra'), 
	@AhmadAkra = (SELECT [Id] FROM @A1 WHERE [Name] = N'Ahmad Akra'), 
	@BadegeKebede = (SELECT [Id] FROM @A1 WHERE [Name] = N'Badege Kebede'), 
	@TizitaNigussie = (SELECT [Id] FROM @A1 WHERE [Name] = N'Tizita Nigussie'), 
	@Ashenafi = (SELECT [Id] FROM @A1 WHERE [Name] = N'Ashenafi Fantahun'), 
	@YisakTegene = (SELECT [Id] FROM @A1 WHERE [Name] = N'Yisak Tegene'), 
	@ZewdineshHora = (SELECT [Id] FROM @A1 WHERE [Name] = N'Zewdinesh Hora'), 
	@TigistNegash = (SELECT [Id] FROM @A1 WHERE [Name] = N'Tigist Negash'), 
	@RomanZenebe = (SELECT [Id] FROM @A1 WHERE [Name] = N'Roman Zenebe'), 
	@Mestawet = (SELECT [Id] FROM @A1 WHERE [Name] = N'Mestawet G/Egziyabhare'), 
	@AyelechHora = (SELECT [Id] FROM @A1 WHERE [Name] = N'Ayelech Hora'), 
	@YigezuLegesse = (SELECT [Id] FROM @A1 WHERE [Name] = N'Yigezu Legesse'), 
	@BananIT = (SELECT [Id] FROM @A1 WHERE [Name] = N'Banan Information technologies, plc'),
	@WaliaSteel = (SELECT [Id] FROM @A1 WHERE [Name] = N'Walia Steel Industry, plc'),
	@Lifan = (SELECT [Id] FROM @A1 WHERE [Name] = N'Yangfan Motors, PLC'),
	@Sesay = (SELECT [Id] FROM @A1 WHERE [Name] = N'Sisay Tesfaye, PLC'),
	@ERCA = (SELECT [Id] FROM @A1 WHERE [Name] = N'Ethiopian Revenues and Customs Authority'),
	@Paint = (SELECT [Id] FROM @A1 WHERE [Name] = N'Best Paint Industry'),
	@Plastic = (SELECT [Id] FROM @A1 WHERE [Name] = N'Best Plastic Industry'),
	@CBE = (SELECT [Id] FROM @A1 WHERE [Name] = N'Commercial Bank of Ethiopia'),
	@AWB = (SELECT [Id] FROM @A1 WHERE [Name] = N'Awash Bank'),
	@NIB = (SELECT [Id] FROM @A1 WHERE [Name] = N'NIB'),

	@ExecutiveOffice = (SELECT [Id] FROM @A1 WHERE [Name] = N'Executive Office'),
	@Production = (SELECT [Id] FROM @A1 WHERE [Name] = N'Production'),
	@Sales = (SELECT [Id] FROM @A1 WHERE [Name] = N'Sales & Marketing'),
	@Finance = (SELECT [Id] FROM @A1 WHERE [Name] = N'Finance'),
	@HR = (SELECT [Id] FROM @A1 WHERE [Name] = N'Human Resources'),
	@Purchasing = (SELECT [Id] FROM @A1 WHERE [Name] = N'Materials & Purchasing');

--		SELECT @MohamadAkra AS MA, @AhmadAkra AS AA, @TigistNegash AS TN, @TizitaNigussie As Tiz;


INSERT INTO @Settings([Field],[Value]) Values(N'TaxAuthority', @ERCA);
DELETE FROM @SettingsResult; INSERT INTO @SettingsResult([Field], [Value], [EntityState])
EXEC  [dbo].[api_Settings__Save]  @Settings = @Settings; DELETE FROM @Settings WHERE [EntityState] IN (N'Inserted', N'Updated', 'Deleted'); INSERT INTO @Settings SELECT * FROM @SettingsResult;
