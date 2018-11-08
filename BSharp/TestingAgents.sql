BEGIN -- Cleanup
	SET NOCOUNT ON;
	DELETE FROM dbo.Custodies;
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
	([Id], [AgentType],		[Name],		[IsActive], [IsRelated], [UserId],						[TaxIdentificationNumber], [RegisteredAddress], [Title], [Gender], [BirthDateTime], [Status]) VALUES
	(-100,	N'Individual',	N'Mohamad Akra',	1,		0,		 N'mohamad.akra@banan-it.com',	NULL,						NULL,				N'Dr.',		'M',	'1966.02.19',	N'Inserted'),
	(-99,	N'Individual',	N'Ahmad Akra',		1,		0,		 N'ahmad.akra@banan-it.com',	NULL,						NULL,				N'Mr.',		'M',	'1992.09.21',	N'Inserted');

	DELETE FROM @AgentsResult; INSERT INTO @AgentsResult([Id], [AgentType], [Name], [IsActive], [IsRelated], [UserId], [TaxIdentificationNumber], [RegisteredAddress], [Title], [Gender], [BirthDateTime], [Status], [TemporaryId])
	EXEC  [dbo].[api_Agents__Save]  @Agents = @Agents; DELETE FROM @Agents WHERE Status IN (N'Inserted', N'Updated', 'Deleted'); INSERT INTO @Agents SELECT * FROM @AgentsResult;
	
	SELECT * FROM @Agents;

	-- Updating MA TIN
	UPDATE @Agents 
	SET 
		[TaxIdentificationNumber] = N'0059603732',
		Status = N'Updated'
	WHERE [Id] = 1;

	DELETE FROM @AgentsResult; INSERT INTO @AgentsResult([Id], [AgentType], [Name], [IsActive], [IsRelated], [UserId], [TaxIdentificationNumber], [RegisteredAddress], [Title], [Gender], [BirthDateTime], [Status], [TemporaryId])
	EXEC  [dbo].[api_Agents__Save]  @Agents = @Agents; DELETE FROM @Agents WHERE Status IN (N'Inserted', N'Updated', 'Deleted'); INSERT INTO @Agents SELECT * FROM @AgentsResult;
		
	SELECT * FROM @Agents;

	-- Deleting MA Record
	UPDATE @Agents SET [Status] = N'Deleted' WHERE [Id] = 1;

	DELETE FROM @AgentsResult; INSERT INTO @AgentsResult([Id], [AgentType], [Name], [IsActive], [IsRelated], [UserId], [TaxIdentificationNumber], [RegisteredAddress], [Title], [Gender], [BirthDateTime], [Status], [TemporaryId])
	EXEC  [dbo].[api_Agents__Save]  @Agents = @Agents; DELETE FROM @Agents WHERE Status IN (N'Inserted', N'Updated', 'Deleted'); INSERT INTO @Agents SELECT * FROM @AgentsResult;
	
	SELECT * FROM @Agents;
END