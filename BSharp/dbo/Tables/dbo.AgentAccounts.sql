CREATE TABLE [dbo].[AgentAccounts] (
	[TenantId]					INT,
	[Id]						INT					IDENTITY,
	[AgentId]					INT					NOT NULL,
	-- for every customer, supplier, and employee account types: sales, purchase and employment
	[AgentAccountType]			NVARCHAR (255)		NOT NULL,
	[IsActive]					BIT					NOT NULL DEFAULT (1),
	[Name]						NVARCHAR (255)		NOT NULL,
	[Name2]						NVARCHAR (255),
	[Name3]						NVARCHAR (255),
	[Code]						NVARCHAR (255), -- location code for storage locations
	[Reference]					NVARCHAR (255),
	[StartDate]					DATETIME2 (7)		DEFAULT (CONVERT (date, SYSDATETIME())),
--	employee-accounts
	[JobTitle]					NVARCHAR (255), -- FK to table Jobs
	[BasicSalary]				MONEY,			-- As of now, typically part of direct labor expenses
	[TransporationAllowance]	MONEY,			-- As of now, typically part of overhead expenses.
	[OvertimeRate]				MONEY,			-- probably better moved to a template table
--	supplier-accounts
	-- for the supplier in general
	[SupplierRating]			INT,			-- user defined list
	[PaymentTerms]				NVARCHAR(255),
	-- details per account, e.g., PO, LC, etc...

--	customer-accounts
	[CustomerRating]			INT,			-- user defined list
	[ShippingAddress]			NVARCHAR(255), -- default, the whole list is in a separate table
	[BillingAddress]			NVARCHAR(255),

	[CreditLine]				MONEY,

	[CreatedAt]					DATETIMEOFFSET(7)	NOT NULL,
	[CreatedById]				INT					NOT NULL,
	[ModifiedAt]				DATETIMEOFFSET(7)	NOT NULL, 
	[ModifiedById]				INT					NOT NULL,
	CONSTRAINT [PK_AgentAccounts] PRIMARY KEY CLUSTERED ([TenantId], [Id]),
	CONSTRAINT [CK_AgentAccounts_AgentAccountType] CHECK ([AgentAccountType] IN (
			N'investor-accounts', N'investment-accounts' ,
			N'cash-accounts', N'bank-accounts', N'customer-accounts', N'supplier-accounts',
			N'employee-accounts', N'loans', N'borrowings', N'storage-locations',
			N'employer-accounts'
	)),
	/*
		Agent Account type		UDL (can only have ONE default account per (agent, account type)
		N'investor-accounts'	-- Default
		N'investment-accounts'	-- Default, per investment contract
		N'cash-accounts'		-- Petty cash, POS cash, Imprest fund
		N'bank-accounts'		-- Checking, Savings, etc..
		N'customer-accounts'	-- Default, per Sales order, per lease out, ...
		N'supplier-accounts'	-- Default, per Purchase Order, per LC, per lease in
		N'employee-accounts'	-- Default, per Contract
		N'loans'				-- per Loan
		N'borrowings'			-- per Loan
		N'storage-locations'	-- per storage location. Use the code to define the location structure
								-- Includes warehouse/aisles/shelves/bins, factory/line/unit, farm/zone/..
		N'employer-accounts'	-- Default, per contract
								-- used for companies providing outsourcing services
		)),
	*/
);
