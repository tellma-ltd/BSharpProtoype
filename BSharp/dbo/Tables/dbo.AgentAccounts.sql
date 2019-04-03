CREATE TABLE [dbo].[AgentAccounts] (
	[TenantId]					INT,
	[Id]						INT					IDENTITY,
	[AgentId]					INT					NOT NULL,
	-- for every customer, supplier, and employee account types: sales, purchase and employment
	[AgentAccountType]			NVARCHAR (255)		NOT NULL,
	[IsActive]					BIT					NOT NULL DEFAULT (1),
	[Name]						NVARCHAR (255)		NOT NULL,
	[Name2]						NVARCHAR (255),
	[Code]						NVARCHAR (255),
	[Reference]					NVARCHAR (255),
	[StartDate]					DATETIME2 (7)		DEFAULT (CONVERT (date, SYSDATETIME())),
-- Employees Only
	[JobTitle]					NVARCHAR (255), -- current job
	[BasicSalary]				MONEY,			-- As of now, typically part of direct labor expenses
	[TransporationAllowance]	MONEY,			-- As of now, typically part of overhead expenses.
	[OvertimeRate]				MONEY,			-- probably better moved to a template table
--	Suppliers Only
	[PaymentTerms]				NVARCHAR(255),
	[SupplierRating]			TINYINT, -- user defined list
--	Customers Only
	[ShippingAddress]			NVARCHAR(255), -- default, the whole list is in a separate table
	[BillingAddress]			NVARCHAR(255),
	[CustomerRating]			TINYINT, -- user defined list
	[CreditLine]				MONEY,

	[CreatedAt]					DATETIMEOFFSET(7)	NOT NULL,
	[CreatedById]				INT					NOT NULL,
	[ModifiedAt]				DATETIMEOFFSET(7)	NOT NULL, 
	[ModifiedById]				INT					NOT NULL,
	CONSTRAINT [PK_AgentAccounts] PRIMARY KEY CLUSTERED ([TenantId] ASC, [Id] ASC),
	CONSTRAINT [CK_AgentAccounts_AgentAccountType] CHECK (
		[AgentAccountType] IN (N'cash-on-hand', N'balances-with-bank', N'sales', N'purchase', N'employment', N'loan', N'borrowing', N'storage-location' )
	),
	/*
	CONSTRAINT [CK_AgentsResources] CHECK ([AgentAccountType] IN (
		N'Employee',	-- Individual: Overtime hours (4 types), Labor hours 
		N'Employer',	-- Organization: N/A

		N'Customer',	-- Individual, Organization: Finished Goods,
		N'Lessor',		-- Individual, Organization
		N'Lessee',		-- Individual, Organization
		N'Investee',	-- Organization
		N'Investor',	-- Individual, Organization

		N'CashSafe',	-- Individual, Vault
		N'BankAccount', -- Digital account
		N'Warehouse',	-- Vault, Limited Access, Public Access
		N'Farm',		-- Limited Access, Public Access
		N'ProductionPoint'-- Limited Access
		)), */
);
