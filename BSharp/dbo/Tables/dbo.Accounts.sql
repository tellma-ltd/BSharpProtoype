CREATE TABLE [dbo].[Accounts] (
	[TenantId]					INT,
	[AccountNode]				HIERARCHYID,
	[Level]						AS [AccountNode].GetLevel(),
	[ParentNode]				AS [AccountNode].GetAncestor(1),
	[Id]						INT					NOT NULL IDENTITY(1,1),
	[Code]						NVARCHAR (255),
	[AccountType]				NVARCHAR (255)		NOT NULL, -- same as in peachtree
	[AccountCategory]			TINYINT				NOT NULL, -- 0: header, 1: detail, 2:smart (works only when no active descendants)
	[IsActive]					BIT					NOT NULL DEFAULT (1),
	[Name]						NVARCHAR (255)		NOT NULL,
	[Name2]						NVARCHAR (255),
	[IFRSConceptId]				NVARCHAR (255), -- here we know whether to require NoteId
	[DefaultNoteId]				NVARCHAR (255),

	-- Edit Modes, 0=invisible, 1=readonly, 2=editable
	-- always visible
	[DefaultOperationId]		INT,
	[OperationEditMode]			TINYINT NOT NULL DEFAULT (0),
	-- visible for edit mode = 2
	-- [OperationFilter]			NVARCHAR(1024),

	[DefaultFunctionId]			INT					NOT NULL, -- e.g., general, admin, S&M, HR, finance, production, maintenance, accommodation
	[FunctionEditMode]			TINYINT NOT NULL DEFAULT (0),
	--[FunctionFilter]			NVARCHAR(1024), -- e.g., RelationType = N'employee' OR ..

	[DefaultProductCategoryId]	INT					NOT NULL, -- e.g., general, sales, services OR, Steel, Real Estate, Coffee, ..
	[ProductCategoryEditMode]	TINYINT NOT NULL DEFAULT (0),	
	--[ProductCategoryFilter]		NVARCHAR(1024), 
	
	[DefaultGeographicRegionId]	INT					NOT NULL, -- e.g., general, Oromia, Bole, Kersa
	[GeorgaphicRegionEditMode]	TINYINT NOT NULL DEFAULT (0),
	--[GeorgaphicRegionFilter]		NVARCHAR(1024), 

	[DefaultCustomerSegmentId]	INT					NOT NULL, -- e.g., general, then corporate, individual or M, F or Adult youth, etc...
	[CustomerSegmentEditMode]	INT					NOT NULL,
	--[CustomerSegmentFilter]		NVARCHAR(1024), 
	
	[DefaultTaxSegmentId]		INT					NOT NULL,
	[TaxSegmentEditMode]		TINYINT NOT NULL DEFAULT (0),
	--[TaxSegmentFilter]		NVARCHAR(1024), 

	[DefaultAgentId]			INT NOT NULL,	-- DEFAULT(if IFRS filter returns singleton, use it, else if anonymous from filter returns 1 use it, else force user to enter) results) 
	[AgentEditMode]				TINYINT NOT NULL DEFAULT (0),
	[AgentFilter]				NVARCHAR(1024), -- e.g., RelationType = N'employee' OR ..

	[DefaultAgentAccountId]		INT,	-- SupplierAccount, PurchaseOrderAccount, PurchaseInvoiceAccount, EmployeeAccount, EmployeePayPeriodAccount, EmployeeLoanAccount, TaxAccount
	[AgentAccountEditMode]		TINYINT NOT NULL DEFAULT (0),
	[AgentAccountFilter]		NVARCHAR(1024), -- e.g., contract type = trade, OR inventory

	[DefaultResourceId]			INT,
	[ResourceEditMode]			TINYINT NOT NULL DEFAULT (0),
	[ResourceFilter]			NVARCHAR(1024), -- e.g., ResourceType = SalaryComponent

	[RelatedAgentEditMode]		TINYINT NOT NULL DEFAULT (0),
	[RelatedAgentFilter]		NVARCHAR(1024), -- e.g., RelationType = N'employee' OR ..

	[CreatedAt]				DATETIMEOFFSET(7)	NOT NULL,
	[CreatedById]			INT					NOT NULL,
	[ModifiedAt]			DATETIMEOFFSET(7)	NOT NULL, 
	[ModifiedById]			INT					NOT NULL,
	CONSTRAINT [PK_Accounts] PRIMARY KEY CLUSTERED ([TenantId] ASC, [AccountNode] ASC),
	CONSTRAINT [CK_Accounts_AccountType] CHECK ([AccountType] IN (N'Accounts Payable', N'Accounts Receivable', N'Accumulated Depreciation', N'Cash',
		N'Cost of Sales', N'Equity - doesn''t close (Corporation)', N'Equity - gets closed (Proprietorship)', N'Equity - Retained Earnings', N'Expenses',
		N'Fixed Assets', N'Income', N'Inventory', N'Long term liabilities', N'Other assets', N'Other current assets', N'Other current liabilities',
		N'Payables Retainage', N'Receivables Retainage'
		-- We also need: Raw Materials, Inventories In Transit, Finished Goods
		-- N'DistributionCosts', N'AdministrativeExpense', N'OtherExpenseByFunction'
		-- N'CurrentEmployeeIncomeTaxPayable', N'CurrentValueAddedTaxReceivables' (VATPurchases)
		-- N'CurrentValueAddedTaxPayables' (VATSales), CurrentWithholdingTaxPayable (WT Purchases)
	)),
	CONSTRAINT [CK_Accounts_AccountCategory] CHECK ([AccountCategory] IN (0, 1, 2)),
	CONSTRAINT [FK_Accounts_IFRSConcepts] FOREIGN KEY ([TenantId], [IFRSConceptId]) REFERENCES [dbo].[IFRSConcepts] ([TenantId], [IFRSConceptId]) ON UPDATE CASCADE,
	CONSTRAINT [FK_Accounts_Operations] FOREIGN KEY ([TenantId], [DefaultOperationId]) REFERENCES [dbo].[Operations] ([TenantId], [Id]),
	CONSTRAINT [FK_Accounts_Agents] FOREIGN KEY ([TenantId], [DefaultAgentId]) REFERENCES [dbo].[Agents] ([TenantId], [Id]),
	CONSTRAINT [FK_Accounts_Resources] FOREIGN KEY ([TenantId], [DefaultResourceId]) REFERENCES [dbo].[Resources] ([TenantId], [Id]),
	CONSTRAINT [FK_Accounts_CreatedById] FOREIGN KEY ([TenantId], [CreatedById]) REFERENCES [dbo].[LocalUsers] ([TenantId], [Id]),
	CONSTRAINT [FK_Accounts_ModifiedById] FOREIGN KEY ([TenantId], [ModifiedById]) REFERENCES [dbo].[LocalUsers] ([TenantId], [Id])
);
GO
CREATE INDEX [IX_Accounts_Id] ON [dbo].[Accounts]([TenantId] ASC, [Id] ASC);
GO
CREATE INDEX [IX_Accounts_Code] ON [dbo].[Accounts]([TenantId] ASC, [Code] ASC);
GO