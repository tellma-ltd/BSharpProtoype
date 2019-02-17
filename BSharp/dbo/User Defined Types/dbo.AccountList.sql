CREATE TYPE [dbo].[AccountList] AS TABLE (
	[Index]				INT				IDENTITY(0, 1),
	[Id]				INT,
	[Code]				NVARCHAR (255),
	[AccountType]		NVARCHAR (255)	NOT NULL, -- same as in peachtree
	[AccountCategory]	TINYINT			NOT NULL, -- 0: header, 1: detail, 2:smart (works only when no active descendants)
	[IsActive]			BIT				NOT NULL DEFAULT (1),
	[Name]				NVARCHAR (255)	NOT NULL,
	[Name2]				NVARCHAR (255),
	[IFRSConceptId]		NVARCHAR (255),
	[OperationId]		INT,
	[AgentId]			INT,
	[Reference]			NVARCHAR (255)	DEFAULT(N''),
	[ResourceId]		INT,
	[ParentIndex]		INT,
	[ParentId]			INT,  
	[EntityState]		NVARCHAR(255)	NOT NULL DEFAULT(N'Inserted'),
	PRIMARY KEY ([Index] ASC),
	INDEX IX_AgentList__Code ([Code]),
	CHECK ([AccountType] IN (N'Accounts Payable', N'Accounts Receivable', N'Accumulated Depreciation', N'Cash',
		N'Cost of Sales', N'Equity - doesn''t close (Corporation)', N'Equity - gets closed (Proprietorship)', N'Equity - Retained Earnings', N'Expenses',
		N'Fixed Assets', N'Income', N'Inventory', N'Long term liabilities', N'Other assets', N'Other current assets', N'Other current liabilities',
		N'Payables Retainage', N'Receivables Retainage'
	)),
	CHECK ([AccountCategory] IN (0, 1, 2)),
	CHECK ([EntityState] IN (N'Unchanged', N'Inserted', N'Updated', N'Deleted')),
	CHECK ([EntityState] <> N'Inserted' OR [Id] IS NULL)
);