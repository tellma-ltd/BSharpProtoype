CREATE TABLE [dbo].[TransactionLines] (
--	These are for transactions only. If there are Lines from requests or inquiries, etc=> other tables
	[TenantId]				INT					DEFAULT CONVERT(INT, SESSION_CONTEXT(N'TenantId')),
	[Id]					INT					IDENTITY,
	[DocumentId]			INT					NOT NULL,

	[LineTypeId]			NVARCHAR (255)		NOT NULL, -- specifies the number of entries
	[TemplateLineId]		INT, -- depending on the line type, the user may/may not be allowed to edit
	[ScalingFactor]			FLOAT, -- Qty sold for Price list, Qty produced for BOM

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

-- for auditing
	[CreatedAt]				DATETIMEOFFSET(7)	NOT NULL DEFAULT SYSDATETIMEOFFSET(),
	[CreatedById]			INT					NOT NULL DEFAULT CONVERT(INT, SESSION_CONTEXT(N'UserId')),
	[ModifiedAt]			DATETIMEOFFSET(7)	NOT NULL DEFAULT SYSDATETIMEOFFSET(),
	[ModifiedById]			INT					NOT NULL DEFAULT CONVERT(INT, SESSION_CONTEXT(N'UserId')),

	CONSTRAINT [PK_TransactionLines] PRIMARY KEY CLUSTERED ([TenantId] ASC, [Id] ASC),
	CONSTRAINT [FK_TransactionLines__Documents]	FOREIGN KEY ([TenantId], [DocumentId])	REFERENCES [dbo].[Documents] ([TenantId], [Id]) ON DELETE CASCADE,
	CONSTRAINT [FK_TransactionLines__CreatedById]	FOREIGN KEY ([TenantId], [CreatedById])	REFERENCES [dbo].[LocalUsers] ([TenantId], [Id]),
	CONSTRAINT [FK_TransactionLines__ModifiedById]FOREIGN KEY ([TenantId], [ModifiedById])REFERENCES [dbo].[LocalUsers] ([TenantId], [Id]),
);
GO
CREATE INDEX [IX_TransactionLines__DocumentId] ON [dbo].[TransactionLines]([TenantId] ASC, [DocumentId] ASC);
GO