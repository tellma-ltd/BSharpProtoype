CREATE TABLE [dbo].[AgentsResources]
(
	[TenantId]			INT,
	[Id]				INT					IDENTITY,
	[AgentId]			INT					NOT NULL,
	[RelationType]		NVARCHAR(255)		NOT NULL,
	[ResourceId]		INT					NOT NULL,
	[UnitCost]			MONEY				NOT NULL DEFAULT(1),				
	[CreatedAt]			DATETIMEOFFSET(7)	NOT NULL,
	[CreatedById]			INT		NOT NULL,
	[ModifiedAt]		DATETIMEOFFSET(7)	NOT NULL, 
	[ModifiedById]		INT		NOT NULL,
	CONSTRAINT [PK_AgentsResources] PRIMARY KEY CLUSTERED ([TenantId] ASC, [Id] ASC),
	CONSTRAINT [CK_AgentsResources] CHECK ([RelationType] IN (
		N'Employee',	-- Individual: Overtime hours (4 types), Labor hours 
		N'Employer',	-- Organization: N/A
		N'Supplier',	-- Organization: Raw Materials, Trade Merchandise, PPE
		N'Customer',	-- Individual, Organization: Finished Goods,
		N'Lessor',		-- Individual, Organization
		N'Lessee',		-- Individual, Organization
		N'Investee',	-- Organization
		N'Investor',	-- Individual, Organization
		N'Debtor',		-- Individual, Organization
		N'Creditor',	-- Individual, Organization
		N'CashSafe',	-- Individual, Vault
		N'BankAccount', -- Digital account
		N'Warehouse',	-- Vault, Limited Access, Public Access
		N'Farm',		-- Limited Access, Public Access
		N'ProductionPoint'-- Limited Access
		)),
	CONSTRAINT [FK_AgentsResources_Agents] FOREIGN KEY ([TenantId], [AgentId]) REFERENCES [dbo].[Agents] ([TenantId], [Id])ON DELETE CASCADE,
	CONSTRAINT [FK_AgentsResources_Resources] FOREIGN KEY ([TenantId], [ResourceId]) REFERENCES [dbo].[Resources] ([TenantId], [Id])ON DELETE CASCADE
);
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_AgentsResources__AgentId_RelationType_ResourceId]
  ON [dbo].[AgentsResources]([TenantId] ASC, [AgentId] ASC, [RelationType] ASC, [ResourceId] ASC);
