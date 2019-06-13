CREATE TABLE [dbo].[RequestLines] (
--	These are for vouchers only. If there are Lines from requests or inquiries, etc=> other tables
	[TenantId]				INT					DEFAULT CONVERT(INT, SESSION_CONTEXT(N'TenantId')),
	[Id]					INT					IDENTITY,
	[DocumentId]			INT					NOT NULL,

	[RequestLineType]		NVARCHAR (255)		NOT NULL,
	[TemplateLineId]		INT, -- depending on the line type, the user may/may not be allowed to edit
	[ScalingFactor]			FLOAT, -- Qty sold for Price list, Qty produced for BOM

	[Direction]				SMALLINT			NOT NULL,
 -- Account selection enforces additional filters on the other columns
	[AccountId]				INT					NOT NULL,
-- Analysis of accounts including: cash, non current assets, equity, and expenses. Can be updated after posting
	[IfrsNoteId]			NVARCHAR (255),		-- Note that the responsibility center might define the Ifrs Note
-- The business segment that "owns" the asset/liablity, and whose performance is assessed by the revenue/expense
	[ResponsibilityCenterId]INT,				-- called SegmentId in B10. When not needed, we use the entity itself.
-- subaccount of: agent having custody of asset/agent against whom we are liable. N/A for P/L accounts
	[AgentAccountId]		INT, 
-- Resource is defined as
--	The actual asset, liability
--	The good/service sold for revenues and direct expenses
--	The good/service consumed for indirect expenses
	[ResourceId]			INT					NOT NULL DEFAULT CONVERT(INT, SESSION_CONTEXT(N'FunctionalCurrencyId')),
-- Tracking additive measures
	[Quantity]				VTYPE				NOT NULL DEFAULT 0, -- measure on which the value is based. If it is MassMeasure then [Mass] must equal [ValueMeasure] and so on.
	[MoneyAmount]			MONEY				NOT NULL DEFAULT 0, -- Amount in foreign Currency 
	[Mass]					DECIMAL				NOT NULL DEFAULT 0, -- MassUnit, like LTZ bar, cement bag, etc
	[Volume]				DECIMAL				NOT NULL DEFAULT 0, -- VolumeUnit, possibly for shipping
	[Count]					DECIMAL				NOT NULL DEFAULT 0, -- CountUnit
	[Time]					DECIMAL				NOT NULL DEFAULT 0, -- ServiceTimeUnit
	[Value]					VTYPE				NOT NULL DEFAULT 0, -- equivalent in functional currency
--	Percent VAT and VAT
	[PercentVAT]			DECIMAL				NOT NULL DEFAULT 0,
	[ValueAddedTax]			DECIMAL				NOT NULL DEFAULT 0,
-- Settling date of assets, liabilities. Examples: Asset Disposal date, Inventory expiry date, loan/borrowing settlement date.
	[ExpectedSettlingDate]	DATE,  -- Can be used to decide mobilize split balance between current and non-current
-- Additional information to satisfy reporting requirements
	[Memo]					NVARCHAR (255), -- a textual description for statements and reports
-- for storing external voucher references, such as check #, Supplier invoice, Bank Deposit Ref
	[ExternalReference]		NVARCHAR (255), --
-- for debiting asset accounts, related resource is the good/service acquired from supplier/customer/storage
-- for crediting asset accounts, related resource is the good/service delivered to supplier/customer/storage as resource
-- for debiting VAT purchase account, related resource is the good/service purchased
-- for crediting VAT Sales account, related resource is the good/service sold
-- for crediting VAT purchase, debiting VAT sales, or liability account: related resource is N/A
	[RelatedResourceId]		INT, -- Good, Service, Labor, Machine usage
-- The related agent account is the implicit agent account that had two Lines, one debiting and one crediting and hence removed
-- Examples include supplier account in cash purchase, customer account in cash sales, employee account in cash payroll, 
-- supplier account in VAT purchase entry, customer account in VAT sales entry, and WIP account in direct production.
	[RelatedAgentAccountId]	INT,
	[RelatedResponsibilityCenterId] INT, -- used in stock issues for consumption
	[RelatedQuantity]		MONEY ,		-- used in Tax accounts, to store the quantiy of taxable item
	[RelatedMoneyAmount]	MONEY 				NOT NULL DEFAULT 0, -- e.g., amount subject to tax
	[RelatedMass]			DECIMAL				NOT NULL DEFAULT 0, -- MassUnit, like LTZ bar
	[RelatedVolume]			DECIMAL				NOT NULL DEFAULT 0, -- VolumeUnit, possibly for shipping
	[RelatedCount]			DECIMAL				NOT NULL DEFAULT 0, -- CountUnit
	[RelatedTime]			DECIMAL				NOT NULL DEFAULT 0, -- ServiceTimeUnit
	[RelatedValue]			VTYPE				NOT NULL DEFAULT 0, -- 
-- for authenticity when the source document is the record itself, an entry has to be signed by:
--	1) The Agent (of AgentAccount) in the case of Balance sheet account
--	2) The revenue customer or expense consumer in the case of Profit/loss account
--	3) Lines whose accounts that do not have an agent account do not need to be signed
	-- While Voucher Number referes to the voucher representing the Request, if any,
	-- this refers to any other identifying string that we may need to store, such as Check number
	-- deposit slip reference, invoice number, etc...
	[SignedAt]				DATETIMEOFFSET(7), 
	[SignedById]			INT,
-- for auditing
	[CreatedAt]				DATETIMEOFFSET(7)	NOT NULL DEFAULT SYSDATETIMEOFFSET(),
	[CreatedById]			INT					NOT NULL DEFAULT CONVERT(INT, SESSION_CONTEXT(N'UserId')),
	[ModifiedAt]			DATETIMEOFFSET(7)	NOT NULL DEFAULT SYSDATETIMEOFFSET(),
	[ModifiedById]			INT					NOT NULL DEFAULT CONVERT(INT, SESSION_CONTEXT(N'UserId')),

	CONSTRAINT [PK_RequestLines] PRIMARY KEY CLUSTERED ([TenantId] ASC, [Id] ASC),
	CONSTRAINT [CK_RequestLines__Direction]	CHECK ([Direction] IN (-1, 1)),
	CONSTRAINT [FK_RequestLines__Documents]	FOREIGN KEY ([TenantId], [DocumentId])	REFERENCES [dbo].[Documents] ([TenantId], [Id]) ON DELETE CASCADE,
	CONSTRAINT [FK_RequestLines__Accounts]	FOREIGN KEY ([TenantId], [AccountId])	REFERENCES [dbo].[Accounts] ([TenantId], [Id]),
	CONSTRAINT [FK_RequestLines__IfrsNotes]	FOREIGN KEY ([TenantId], [IfrsNoteId])	REFERENCES [dbo].[IfrsNotes] ([TenantId], [Id]),
	CONSTRAINT [FK_RequestLines__ResponsibilityCenters]	FOREIGN KEY ([TenantId], [ResponsibilityCenterId]) REFERENCES [dbo].[ResponsibilityCenters] ([TenantId], [Id]),
	CONSTRAINT [FK_RequestLines__AgentAccounts]	FOREIGN KEY ([TenantId], [AgentAccountId])	REFERENCES [dbo].[AgentAccounts] ([TenantId], [Id]),
	CONSTRAINT [FK_RequestLines__Resources]	FOREIGN KEY ([TenantId], [ResourceId])	REFERENCES [dbo].[Resources] ([TenantId], [Id]),
	CONSTRAINT [FK_RequestLines__CreatedById]	FOREIGN KEY ([TenantId], [CreatedById])	REFERENCES [dbo].[LocalUsers] ([TenantId], [Id]),
	CONSTRAINT [FK_RequestLines__ModifiedById]FOREIGN KEY ([TenantId], [ModifiedById])REFERENCES [dbo].[LocalUsers] ([TenantId], [Id]),
	CONSTRAINT [FK_RequestLines__SignedById]FOREIGN KEY ([TenantId], [SignedById])REFERENCES [dbo].[LocalUsers] ([TenantId], [Id])
);
GO
CREATE INDEX [IX_RequestLines__DocumentId] ON [dbo].[RequestLines]([TenantId] ASC, [DocumentId] ASC);
GO
CREATE INDEX [IX_RequestLines__ResponsibilityCenterId] ON [dbo].[RequestLines]([TenantId] ASC, [ResponsibilityCenterId] ASC);
GO
CREATE INDEX [IX_RequestLines__AccountId] ON [dbo].[RequestLines]([TenantId] ASC, [AccountId] ASC);
GO
CREATE INDEX [IX_RequestLines__IfrsNoteId] ON [dbo].[RequestLines]([TenantId] ASC, [IfrsNoteId] ASC);
GOO