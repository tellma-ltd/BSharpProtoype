CREATE TABLE [dbo].[Custodies] (
	[TenantId]					INT,
	[Id]						INT					IDENTITY (1, 1),
	[CustodyType]				NVARCHAR (255)		NOT NULL,
	[Name]						NVARCHAR (255)		NOT NULL,
	[Name2]						NVARCHAR (255),
	[IsActive]					BIT					CONSTRAINT [DF_Custodies_IsActive] DEFAULT (1),
	[Code]						NVARCHAR (255),
	[Address]					NVARCHAR (1024),
	[BirthDateTime]				DATETIMEOFFSET (7),
--	Agents specific
	[AgentType]					NVARCHAR (255),
	[IsRelated]					BIT					CONSTRAINT [DF_Agents_IsRelated] DEFAULT (0),
	[TaxIdentificationNumber]	NVARCHAR (255),
	[Title]						NVARCHAR (255),
	[Gender]					NCHAR (1),
--	Place
	[PlaceType]					NVARCHAR (255),
	[CustodianId]				INT, -- Accountable Id
--
	[CreatedAt]					DATETIMEOFFSET(7)	NOT NULL,
	[CreatedBy]					NVARCHAR(450)		NOT NULL,
	[ModifiedAt]				DATETIMEOFFSET(7)	NOT NULL, 
	[ModifiedBy]				NVARCHAR(450)		NOT NULL,
	CONSTRAINT [PK_Custodies] PRIMARY KEY CLUSTERED ([TenantId] ASC, [Id] ASC),
	CONSTRAINT [CK_Custodies_CustodyType] CHECK ([CustodyType] IN (N'Agent', N'Place')),

	CONSTRAINT [CK_Agents_AgentType] CHECK ([AgentType] IN (N'Individual', N'Organization', N'Position')),

	CONSTRAINT [FK_Places_Agents] FOREIGN KEY ([TenantId], [CustodianId]) REFERENCES [dbo].[Custodies] ([TenantId], [Id]),
	CONSTRAINT [CK_Places_PlaceType] CHECK ([PlaceType] IN (N'CashSafe', N'BankAccount', N'Warehouse', N'Farm', N'ProductionPoint', N'Misc')),

	CONSTRAINT [FK_Custodies_CreatedBy] FOREIGN KEY ([TenantId], [CreatedBy]) REFERENCES [dbo].[Users] ([TenantId], [Id]),
	CONSTRAINT [FK_Custodies_ModifiedBy] FOREIGN KEY ([TenantId], [ModifiedBy]) REFERENCES [dbo].[Users] ([TenantId], [Id])
);
GO
CREATE UNIQUE INDEX [IX_Custodies__Id_CustodyType]
  ON [dbo].[Custodies]([TenantId] ASC, [Id] ASC, [CustodyType] ASC);
GO
CREATE UNIQUE INDEX [IX_Custodies__Code]
  ON [dbo].[Custodies]([TenantId] ASC, [Code] ASC) WHERE [Code] IS NOT NULL;
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Agents__Id_AgentType]
  ON [dbo].[Custodies]([Id] ASC, [AgentType] ASC) WHERE [AgentType] IS NOT NULL;
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Places__Id_PlaceType]
  ON [dbo].[Custodies]([Id] ASC, [PlaceType] ASC) WHERE [PlaceType] IS NOT NULL;