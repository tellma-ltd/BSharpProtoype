CREATE TABLE [dbo].[Custodies] (
	[TenantId]					INT,
	[Id]						INT					IDENTITY (1, 1),
	[CustodyType]				NVARCHAR (255)		NOT NULL,
	[IsActive]					BIT					NOT NULL DEFAULT (1),
	[Name]						NVARCHAR (255)		NOT NULL,
	[Name2]						NVARCHAR (255),
	[Code]						NVARCHAR (255),
	[Address]					NVARCHAR (1024), -- Physical or virtual, such as Bank account or URL.
	[BirthDateTime]				DATETIMEOFFSET (7),
--	Agents specific
	[AgentType]					NVARCHAR (255),
	[IsRelated]					BIT					DEFAULT (0),
	[TaxIdentificationNumber]	NVARCHAR (255),
	[Title]						NVARCHAR (255), -- for individuals only
	[Gender]					NCHAR (1),		-- for individuals only
	[PreferredContactChannel]	NVARCHAR(255),
	[PreferredContactAddress]	NVARCHAR(255),	-- where is preferred contact person, for organization?
--	Place
	[PlaceType]					NVARCHAR (255),		-- A place has an address, physical or virtual
	[CustodianId]				INT, -- Accountable Id, Agent or relation?
--
	[CreatedAt]					DATETIMEOFFSET(7)	NOT NULL,
	[CreatedBy]					NVARCHAR(450)		NOT NULL,
	[ModifiedAt]				DATETIMEOFFSET(7)	NOT NULL, 
	[ModifiedBy]				NVARCHAR(450)		NOT NULL,
	CONSTRAINT [PK_Custodies] PRIMARY KEY CLUSTERED ([TenantId] ASC, [Id] ASC),
	CONSTRAINT [CK_Custodies_CustodyType] CHECK ([CustodyType] IN (N'Agent', N'Place')),

	CONSTRAINT [CK_Agents_AgentType] CHECK ([AgentType] IN (N'Individual', N'Organization')), -- Organization includes Dept, Team

	CONSTRAINT [FK_Places_Agents] FOREIGN KEY ([TenantId], [CustodianId]) REFERENCES [dbo].[Custodies] ([TenantId], [Id]),
	CONSTRAINT [CK_Places_PlaceType] CHECK ([PlaceType] IN (N'CashSafe', N'BankAccount', N'Warehouse', N'Farm', N'ProductionPoint', N'Misc')),
	-- More accurate types: Vault, Drawer, DigitalAccount, Limited Access land, Public Access Land .. PlaceOwner.
	-- Since the same place can be used as a warehouse and - say - as a farm.
	CONSTRAINT [FK_Custodies_CreatedBy] FOREIGN KEY ([TenantId], [CreatedBy]) REFERENCES [dbo].[Users] ([TenantId], [Id]),
	CONSTRAINT [FK_Custodies_ModifiedBy] FOREIGN KEY ([TenantId], [ModifiedBy]) REFERENCES [dbo].[Users] ([TenantId], [Id])
);
GO
CREATE UNIQUE INDEX [IX_Custodies__Id_CustodyType]
  ON [dbo].[Custodies]([TenantId] ASC, [Id] ASC, [CustodyType] ASC);
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Custodies__Name]
  ON [dbo].[Custodies]([TenantId] ASC, [Name] ASC);
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Custodies__Name2]
  ON [dbo].[Custodies]([TenantId] ASC, [Name2] ASC) WHERE [Name2] IS NOT NULL;
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Custodies__Code]
  ON [dbo].[Custodies]([TenantId] ASC, [Code] ASC) WHERE [Code] IS NOT NULL;
GO

CREATE UNIQUE NONCLUSTERED INDEX [IX_Agents__Id_AgentType]
  ON [dbo].[Custodies]([Id] ASC, [AgentType] ASC) WHERE [AgentType] IS NOT NULL;
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Places__Id_PlaceType]
  ON [dbo].[Custodies]([Id] ASC, [PlaceType] ASC) WHERE [PlaceType] IS NOT NULL;