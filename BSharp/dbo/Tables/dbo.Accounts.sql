CREATE TABLE [dbo].[Accounts] (
	[TenantId]						INT,
	[AccountNode]					HIERARCHYID,
	[Level]							AS [AccountNode].GetLevel(),
	[ParentNode]					AS [AccountNode].GetAncestor(1),
	[Id]							INT					NOT NULL IDENTITY(1,1),
	[Code]							NVARCHAR (255),
	-- Next one should be IsLeaf or HasData instead.
	[HasEntries]					BIT					NOT NULL,
	[IsActive]						BIT					NOT NULL DEFAULT (1),
	[Name]							NVARCHAR (255)		NOT NULL,
	[Name2]							NVARCHAR (255),
	-- Users are not allowed to change the IFRS Concept if it appears in draft or posted. because it messes the rules
	[IFRSAccountConcept]			NVARCHAR (255)		NOT NULL, -- Sort of Account Type
	[ResponsibilityCenterId]		INT,
	[IFRSNoteConcept]				NVARCHAR (255), -- includes Expense by function
--	[TaxSegmentId]					INT,
--	[LocationId]					INT,
	[AgentAccountId]				INT,	-- SupplierAccount, PurchaseOrderAccount, PurchaseInvoiceAccount, EmployeeAccount, EmployeePayPeriodAccount, EmployeeLoanAccount, TaxAccount
	[ResourceId]					INT,
	[RelatedResourceId]				INT,
	[RelatedAgentAccountId]			INT,	-- Sales rep for revenues
	[CreatedAt]						DATETIMEOFFSET(7)	NOT NULL,
	[CreatedById]					INT					NOT NULL,
	[ModifiedAt]					DATETIMEOFFSET(7)	NOT NULL, 
	[ModifiedById]					INT					NOT NULL,
	CONSTRAINT [PK_Accounts] PRIMARY KEY CLUSTERED ([TenantId] ASC, [AccountNode] ASC),
	CONSTRAINT [FK_Accounts_IFRSAccounts] FOREIGN KEY ([TenantId], [IFRSAccountConcept]) REFERENCES [dbo].[IFRSAccounts] ([TenantId], [IFRSConcept]) ON UPDATE CASCADE,
	CONSTRAINT [FK_Accounts_IFRSNotes] FOREIGN KEY ([TenantId], [IFRSNoteConcept]) REFERENCES [dbo].[IFRSNotes] ([TenantId], [IFRSConcept]) ON UPDATE CASCADE,
--	CONSTRAINT [FK_Accounts_Locations] FOREIGN KEY ([TenantId], [LocationId]) REFERENCES [dbo].[ResponsibilityCenters] ([TenantId], [Id]),
	CONSTRAINT [FK_Accounts_AgentAccounts] FOREIGN KEY ([TenantId], [AgentAccountId]) REFERENCES [dbo].[AgentAccounts] ([TenantId], [Id]),
	CONSTRAINT [FK_Accounts_Resources] FOREIGN KEY ([TenantId], [ResourceId]) REFERENCES [dbo].[Resources] ([TenantId], [Id]),
	CONSTRAINT [FK_Accounts_CreatedById] FOREIGN KEY ([TenantId], [CreatedById]) REFERENCES [dbo].[LocalUsers] ([TenantId], [Id]),
	CONSTRAINT [FK_Accounts_ModifiedById] FOREIGN KEY ([TenantId], [ModifiedById]) REFERENCES [dbo].[LocalUsers] ([TenantId], [Id])
);
GO
CREATE INDEX [IX_Accounts_Id] ON [dbo].[Accounts]([TenantId] ASC, [Id] ASC);
GO
CREATE INDEX [IX_Accounts_Code] ON [dbo].[Accounts]([TenantId] ASC, [Code] ASC);
GO