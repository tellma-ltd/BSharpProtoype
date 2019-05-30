CREATE TABLE [dbo].[AgentsResources] (
-- This table is used as a filter to show which resources are compatible with which Agent account, or relations.
-- But we may be able to simulate it using the filters on tables Ifrs and Accounts...
	[TenantId]			INT,
	[Id]				INT					IDENTITY,
	[AgentAccountId]	INT					NOT NULL,
	[ResourceId]		INT					NOT NULL,
	[UnitCost]			MONEY				NOT NULL DEFAULT(1), -- is this the right place for it? May be not...
	[CreatedAt]			DATETIMEOFFSET(7)	NOT NULL,
	[CreatedById]		INT					NOT NULL,
	[ModifiedAt]		DATETIMEOFFSET(7)	NOT NULL, 
	[ModifiedById]		INT					NOT NULL,
	CONSTRAINT [PK_AgentsResources] PRIMARY KEY CLUSTERED ([TenantId] ASC, [Id] ASC),
	CONSTRAINT [FK_AgentsResources_AgentAccounts] FOREIGN KEY ([TenantId], [AgentAccountId]) REFERENCES [dbo].[AgentAccounts] ([TenantId], [Id])ON DELETE CASCADE,
	CONSTRAINT [FK_AgentsResources_Resources] FOREIGN KEY ([TenantId], [ResourceId]) REFERENCES [dbo].[Resources] ([TenantId], [Id])ON DELETE CASCADE
);
GO