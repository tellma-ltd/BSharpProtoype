CREATE TYPE [dbo].[TransactionList] AS TABLE (
	[Index]									INT,
	[Id]									INT,
	[DocumentType]							NVARCHAR (255)		NOT NULL, -- selected when inserted. Cannot update.
	[DocumentDate]							DATE				NOT NULL DEFAULT (CONVERT (date, SYSDATETIME())),
	[VoucherTypeId]							INT,
	[VoucherReference]						NVARCHAR (255),		-- Overridden by the one in entries. Useful when operating in paper-first mode.
	[DocumentLookup1Id]						INT, -- e.g., cash machine serial in the case of a sale
	[DocumentLookup2Id]						INT,
	[DocumentLookup3Id]						INT,
	[DocumentText1]							NVARCHAR (255),
	[DocumentText2]							NVARCHAR (255),
	[Memo]									NVARCHAR (255),	
	[MemoIsCommon]							BIT				DEFAULT 1,
	[CustomerAccountId]						INT,
	[CustomerAccountIsCommon]				BIT				DEFAULT 1,
	[SupplierAccountId]						INT, 
	[SupplierAccountIsCommon]				BIT				DEFAULT 1,
	[EmployeeAccountId]						INT, 
	[EmployeeAccountIsCommon]				BIT				DEFAULT 1,
	[CurrencyId]							INT, 
	[CurrencyIsCommon]						BIT				DEFAULT 1,
	[SourceCustodianAccountId]				INT, 
	[SourceCustodianAccountIsCommon]		BIT				DEFAULT 1,
	[DestinationCustodianAccountId]			INT, 
	[DestinationCustodianAccountIsCommon]	BIT				DEFAULT 1,
	[InvoiceReference]						NVARCHAR (255),
	[InvoiceReferenceIsCommon]				BIT				DEFAULT 1,

	[Frequency]			NVARCHAR (255)		NOT NULL DEFAULT (N'OneTime'), -- an easy way to define a recurrent document
	[Repetitions]		INT					NOT NULL DEFAULT 0, -- time unit is function of frequency

	[EntityState]		NVARCHAR (255)		NOT NULL DEFAULT(N'Inserted'),
	PRIMARY KEY ([Index] ASC),
	CHECK ([Frequency] IN (N'OneTime', N'Daily', N'Weekly', N'Monthly', N'Quarterly', N'Yearly')),
	CHECK ([EntityState] IN (N'Unchanged', N'Inserted', N'Updated', N'Deleted')),
	CHECK ([EntityState] <> N'Inserted' OR [Id] IS NULL)
);