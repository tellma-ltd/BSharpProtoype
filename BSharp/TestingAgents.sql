BEGIN -- Cleanup
	SET NOCOUNT ON;
	DELETE FROM dbo.Custodies;
	DELETE FROM dbo.Users;
	DBCC CHECKIDENT ('dbo.Custodies', RESEED, 0) WITH NO_INFOMSGS;
	DECLARE @Agents AgentList, @AgentsResult AgentList;
END
BEGIN -- Users
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
	-- Insert two records: MA & AA
	INSERT INTO @Agents
	([Id], [AgentType],		[Name],			[IsRelated], [UserId],						[TaxIdentificationNumber], [RegisteredAddress], [Title], [Gender], [BirthDateTime]) VALUES
	(-100,	N'Individual',	N'Mohamad Akra',	0,		 N'mohamad.akra@banan-it.com',	NULL,						NULL,				N'Dr.',		'M',	'1966.02.19'),
	(-99,	N'Individual',	N'Ahmad Akra',		0,		 N'ahmad.akra@banan-it.com',	NULL,						NULL,				N'Mr.',		'M',	'1992.09.21'),
	(-98, N'Individual',	N'Badege Kebede',	1,		 N'badegek@gmail.com',			NULL,						NULL,				N'ATO',		'M',	NULL),-- @BadegeKebede
	(-97, N'Individual',	N'Tizita Nigussie',	0,		N'mintewelde00@gmail.com',		NULL,						NULL,				N'Ms.', 	'F',	NULL), --@TizitaNigussie
	(-96, N'Individual',	N'Ashenafi Fantahun',0,		N'ashenafi935@gmail.com',		NULL,						NULL,				N'Mr.',		'M',	NULL), -- @Ashenafi
	(-95, N'Individual',	N'Yisak Tegene',	0,		N'yisak.tegene@gmail.com',		NULL,						NULL,				N'Mr.',		'M',	NULL), -- @YisakTegene
	(-94, N'Individual',	N'Zewdinesh Hora',	0,		N'zewdnesh.hora@gmail.com',		NULL,						NULL,				N'Ms.',		'F',	NULL), -- @ZewdineshHora
	(-93, N'Individual',	N'Tigist Negash',	0,		N'tigistnegash74@gmail.com',	NULL,						NULL,				N'Ms.',		'F',	NULL), -- @TigistNegash
	(-88, N'Organization', N'Banan Information technologies, plc', 1, N'info@banan-it.com',N'0054901530',	N'AA, Bole, 316/3/203 A',	NULL,		NULL, '2017.08.09'), -- @BananIT
	(-87, N'Organization', N'Walia Steel Industry, plc', 1, NULL,						N'0001656462',				NULL,				NULL,		NULL,	NULL), -- @WaliaSteel
	(-86, N'Organization', N'Yangfan Motors, PLC', 0,	NULL,							N'0005306731',		N'AA, Bole, 06, New',		NULL,		NULL,	NULL), -- @Lifan
	(-85, N'Organization', N'Sisay Tesfaye, PLC', 0,	NULL,							N'',						NULL,				NULL,		NULL,	NULL),	 -- @Sesay
	(-84, N'Organization', N'Ethiopian Revenues and Customs Authority', 0, NULL,		NULL,						NULL,				NULL,		NULL,	NULL), -- @ERCA
	(-83, N'Organization', N'Best Paint Industry', 0,  NULL,							NULL,						NULL,				NULL,		NULL,	NULL), -- @Paint
	(-82, N'Organization', N'Best Plastic Industry', 0, NULL,							NULL,						NULL,				NULL,		NULL,	NULL); -- @Plastic
	--DECLARE @BananIT int, @WaliaSteel int, @Lifan int, @Sesay int, @ERCA int, @Paint int, @Plastic int;
		--([Id], [AgentType],	[Name],							[IsRelated], [UserId],		[TaxIdentificationNumber], [RegisteredAddress], [Title], [Gender], [BirthDateTime]) VALUES
/*	
	N'Roman Zenebe', N'roman.zen12@gmail.com', N'Ms.', 'F', @RomanZenebe
	N'Mestawet G/Egziyabhare', N'mestawetezige@gmail.com', N'Ms.', 'F', @Mestawet
	N'Ayelech Hora', N'ayelech.hora@gmail.com', N'Ms.', 'F', @AyelechHora
	N'Yigezu Legesse', NULL, N'ATO', 'M', @YigezuLegesse
	*/	
	DELETE FROM @AgentsResult; INSERT INTO @AgentsResult([Id], [AgentType], [Name], [IsActive], [IsRelated], [UserId], [TaxIdentificationNumber], [RegisteredAddress], [Title], [Gender], [BirthDateTime], [Status], [TemporaryId])
	EXEC  [dbo].[api_Agents__Save]  @Agents = @Agents; DELETE FROM @Agents WHERE Status IN (N'Inserted', N'Updated', 'Deleted'); INSERT INTO @Agents SELECT * FROM @AgentsResult;
	
	-- Updating MA TIN
	UPDATE @Agents 
	SET 
		[TaxIdentificationNumber] = N'0059603732',
		Status = N'Updated'
	WHERE [Id] = 1;

	DELETE FROM @AgentsResult; INSERT INTO @AgentsResult([Id], [AgentType], [Name], [IsActive], [IsRelated], [UserId], [TaxIdentificationNumber], [RegisteredAddress], [Title], [Gender], [BirthDateTime], [Status], [TemporaryId])
	EXEC  [dbo].[api_Agents__Save]  @Agents = @Agents; DELETE FROM @Agents WHERE Status IN (N'Inserted', N'Updated', 'Deleted'); INSERT INTO @Agents SELECT * FROM @AgentsResult;
		
	-- Deleting MA Record
	UPDATE @Agents SET [Status] = N'Deleted' WHERE [Id] = 1;

	DELETE FROM @AgentsResult; INSERT INTO @AgentsResult([Id], [AgentType], [Name], [IsActive], [IsRelated], [UserId], [TaxIdentificationNumber], [RegisteredAddress], [Title], [Gender], [BirthDateTime], [Status], [TemporaryId])
	EXEC  [dbo].[api_Agents__Save]  @Agents = @Agents; DELETE FROM @Agents WHERE Status IN (N'Inserted', N'Updated', 'Deleted'); INSERT INTO @Agents SELECT * FROM @AgentsResult;
	
	SELECT * FROM @Agents;
END