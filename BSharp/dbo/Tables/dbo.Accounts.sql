CREATE TABLE [dbo].[Accounts] (
	[TenantId]			INT,
	[AccountNode]		HIERARCHYID,
	[Level]				AS [AccountNode].GetLevel(),
	[ParentNode]		AS [AccountNode].GetAncestor(1),
	[Id]				INT					NOT NULL IDENTITY(1,1),
	[Code]				NVARCHAR (255),
	[AccountType]		NVARCHAR (255)		NOT NULL, -- same as in peachtree
	[AccountCategory]	TINYINT				NOT NULL, -- 0: header, 1: detail, 2:smart (works only when no active descendants)
	[IsActive]			BIT					NOT NULL DEFAULT (1),
	[Name]				NVARCHAR (255)		NOT NULL,
	[Name2]				NVARCHAR (255),
	[IFRSConceptId]		NVARCHAR (255),
	[OperationId]		INT,
	[CustodyId]			INT,	-- Type: BankAccount, BankLoanAccount, CashOnHandAccount, CustomerAccount, SalesOrderAccount, InventoryLocationAccount, ShareholderAccount 
								-- SupplierAccount, PurchaseOrderAccount, PurchaseInvoiceAccount, EmployeeAccount, EmployeePayPeriodAccount, EmployeeLoanAccount, TaxAccount
	[ResourceId]		INT,	-- Resource Type: Money, Materials (mass 3,0, volumm, count), PPE (lifetime, count), CompanyStock (count),
	[CreatedAt]			DATETIMEOFFSET(7)	NOT NULL,
	[CreatedById]		INT					NOT NULL,
	[ModifiedAt]		DATETIMEOFFSET(7)	NOT NULL, 
	[ModifiedById]		INT					NOT NULL,
	CONSTRAINT [PK_Accounts] PRIMARY KEY CLUSTERED ([TenantId] ASC, [AccountNode] ASC),
	CONSTRAINT [CK_Accounts_AccountType] CHECK ([AccountType] IN (N'Accounts Payable', N'Accounts Receivable', N'Accumulated Depreciation', N'Cash',
		N'Cost of Sales', N'Equity - doesn''t close (Corporation)', N'Equity - gets closed (Proprietorship)', N'Equity - Retained Earnings', N'Expenses',
		N'Fixed Assets', N'Income', N'Inventory', N'Long term liabilities', N'Other assets', N'Other current assets', N'Other current liabilities',
		N'Payables Retainage', N'Receivables Retainage'
	)),
	CONSTRAINT [CK_Accounts_AccountCategory] CHECK ([AccountCategory] IN (0, 1, 2)),
	CONSTRAINT [FK_Accounts_IFRSConcepts] FOREIGN KEY ([TenantId], [IFRSConceptId]) REFERENCES [dbo].[IFRSConcepts] ([TenantId], [IFRSConceptId]) ON UPDATE CASCADE,
	CONSTRAINT [FK_Accounts_Operations] FOREIGN KEY ([TenantId], [OperationId]) REFERENCES [dbo].[Operations] ([TenantId], [Id]),
	CONSTRAINT [FK_Accounts_Custodies] FOREIGN KEY ([TenantId], [CustodyId]) REFERENCES [dbo].[Agents] ([TenantId], [Id]),
	CONSTRAINT [FK_Accounts_Resources] FOREIGN KEY ([TenantId], [ResourceId]) REFERENCES [dbo].[Resources] ([TenantId], [Id]),
	CONSTRAINT [FK_Accounts_CreatedById] FOREIGN KEY ([TenantId], [CreatedById]) REFERENCES [dbo].[LocalUsers] ([TenantId], [Id]),
	CONSTRAINT [FK_Accounts_ModifiedById] FOREIGN KEY ([TenantId], [ModifiedById]) REFERENCES [dbo].[LocalUsers] ([TenantId], [Id])
);
GO
CREATE INDEX [IX_Accounts_Id] ON [dbo].[Accounts]([TenantId] ASC, [Id] ASC);
GO
CREATE INDEX [IX_Accounts_Code] ON [dbo].[Accounts]([TenantId] ASC, [Code] ASC);
GO