CREATE TABLE [dbo].[CustodiesResources]
(
	[TenantId]			INT,
	[Id]				INT					IDENTITY (1, 1),
	[CustodyId]			INT					NOT NULL,
	[RelationType]		NVARCHAR(255)		NOT NULL,
	[ResourceId]		INT					NOT NULL,
	[CreatedAt]			DATETIMEOFFSET(7)	NOT NULL,
	[CreatedBy]			NVARCHAR(450)		NOT NULL,
	[ModifiedAt]		DATETIMEOFFSET(7)	NOT NULL, 
	[ModifiedBy]		NVARCHAR(450)		NOT NULL,
	CONSTRAINT [PK_CustodiesResources] PRIMARY KEY CLUSTERED ([TenantId] ASC, [Id] ASC),
	CONSTRAINT [CK_CustodiesResources] CHECK ([RelationType] IN (
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
	CONSTRAINT [FK_CustodiesResources_Custodies] FOREIGN KEY ([TenantId], [CustodyId]) REFERENCES [dbo].[Custodies] ([TenantId], [Id])ON DELETE CASCADE,
	CONSTRAINT [FK_CustodiesResources_Resources] FOREIGN KEY ([TenantId], [ResourceId]) REFERENCES [dbo].[Resources] ([TenantId], [Id])ON DELETE CASCADE
);
GO
CREATE NONCLUSTERED INDEX [IX_CustodiesResources__CustodyId]
  ON [dbo].[CustodiesResources]([TenantId] ASC, [CustodyId] ASC);
GO
CREATE NONCLUSTERED INDEX [IX_CustodiesResources__ResourceId]
  ON [dbo].[CustodiesResources]([TenantId] ASC, [ResourceId] ASC);