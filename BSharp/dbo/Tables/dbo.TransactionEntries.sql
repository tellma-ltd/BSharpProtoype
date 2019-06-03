CREATE TABLE [dbo].[TransactionEntries] (
--	These are for vouchers only. If there are entries from requests or inquiries, etc=> other tables
	[TenantId]				INT,
	[Id]					INT					IDENTITY,
	[DocumentId]			INT					NOT NULL,
--	Upon posting the document, the auto generated entries will be MERGED with the present ones
--	based on TenantId, IsSystem, AccountId, IfrsAccountId, IfrsNoteId, ResponsibilityCenterId, AgentAccountId, ResourceId
--	to minimize Transaction Entries deletions
--	It will be presented ORDER BY IsSystem, Direction, AccountId.Code, IfrsAccountId.Node, IfrsNoteId.Node, ResponsibilityCenterId.Node
	[IsSystem]				BIT					NOT NULL DEFAULT (0),
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
	[ResourceId]			INT,				-- NUll because it may be specified by Account				
-- Tracking additive measures
	[Quantity]				VTYPE				NOT NULL DEFAULT (0), -- measure on which the value is based. If it is MassMeasure then [Mass] must equal [ValueMeasure] and so on.
	[MoneyAmount]			MONEY				NOT NULL DEFAULT (0), -- Amount in foreign Currency 
	[Mass]					DECIMAL				NOT NULL DEFAULT (0), -- MassUnit, like LTZ bar, cement bag, etc
	[Volume]				DECIMAL				NOT NULL DEFAULT (0), -- VolumeUnit, possibly for shipping
	[Count]					DECIMAL				NOT NULL DEFAULT (0), -- CountUnit
	[Time]					DECIMAL				NOT NULL DEFAULT (0), -- ServiceTimeUnit
	[Value]					VTYPE				NOT NULL DEFAULT (0), -- equivalent in functional currency
-- Settling date of assets, liabilities. Examples: Asset Disposal date, Inventory expiry date, loan/borrowing settlement date.
	[ExpectedSettlingDate]	DATETIME2(7),  -- Can be used to decide mobilize split balance between current and non-current
-- Additional information to satisfy reporting requirements
	[Memo]					NVARCHAR (255), -- a textual description for statements and reports
-- for storing an extra string, such as cash machine ref for Tax purposes
	[RelatedReference]		NVARCHAR (255), -- Can be updated after posting
-- for debiting asset accounts, related resource is the good/service acquired from supplier/customer/storage
-- for crediting asset accounts, related resource is the good/service delivered to supplier/customer/storage as resource
-- for debiting VAT purchase account, related resource is the good/service purchased
-- for crediting VAT Sales account, related resource is the good/service sold
-- for crediting VAT purchase, debiting VAT sales, or liability account: related resource is N/A
	[RelatedResourceId]		INT, -- Good, Service, Labor, Machine usage
-- The related agent account is the implicit agent account that had two entries, one debiting and one crediting and hence removed
-- Examples include supplier account in cash purchase, customer account in cash sales, employee account in cash payroll, 
-- supplier account in VAT purchase entry, customer account in VAT sales entry, and WIP account in direct production.
	[RelatedAgentAccountId]	INT,
	[RelatedResponsibilityCenterId] INT, -- used in stock issues for consumption
	[RelatedQuantity]		MONEY ,		-- used in Tax accounts, to store the quantiy of taxable item
	[RelatedMoneyAmount]	MONEY 				NOT NULL DEFAULT (0), -- e.g., amount subject to tax
	[RelatedMass]			DECIMAL				NOT NULL DEFAULT (0), -- MassUnit, like LTZ bar
	[RelatedVolume]			DECIMAL				NOT NULL DEFAULT (0), -- VolumeUnit, possibly for shipping
	[RelatedCount]			DECIMAL				NOT NULL DEFAULT (0), -- CountUnit
	[RelatedTime]			DECIMAL				NOT NULL DEFAULT (0), -- ServiceTimeUnit
	[RelatedValue]			VTYPE				NOT NULL DEFAULT (0), -- 

	[Reference]				NVARCHAR (255), -- Can be updated even after posting.
-- for authenticity when the source document is the record itself, an entry has to be signed by:
--	1) The Agent (of AgentAccount) in the case of Balance sheet account
--	2) The revenue customer or expense consumer in the case of Profit/loss account
--	3) Entries whose accounts that do not have an agent account do not need to be signed
	-- While Voucher Number referes to the voucher representing the transaction, if any,
	-- this refers to any other identifying string that we may need to store, such as Check number
	-- deposit slip reference, invoice number, etc...
	[SignedAt]				DATETIMEOFFSET(7), 
	[SignedById]			INT,
-- for auditing
	[CreatedAt]				DATETIMEOFFSET(7)	NOT NULL,
	[CreatedById]			INT					NOT NULL,
	[ModifiedAt]			DATETIMEOFFSET(7)	NOT NULL, 
	[ModifiedById]			INT					NOT NULL,

	CONSTRAINT [PK_TransactionEntries] PRIMARY KEY CLUSTERED ([TenantId] ASC, [Id] ASC),
	CONSTRAINT [CK_TransactionEntries__Direction]	CHECK ([Direction] IN (-1, 1)),
	CONSTRAINT [FK_TransactionEntries__Documents]	FOREIGN KEY ([TenantId], [DocumentId])	REFERENCES [dbo].[Documents] ([TenantId], [Id]) ON DELETE CASCADE,
	CONSTRAINT [FK_TransactionEntries__Accounts]	FOREIGN KEY ([TenantId], [AccountId])	REFERENCES [dbo].[Accounts] ([TenantId], [Id]),
	CONSTRAINT [FK_TransactionEntries__IfrsNotes]	FOREIGN KEY ([TenantId], [IfrsNoteId])	REFERENCES [dbo].[IfrsNotes] ([TenantId], [Id]),
	CONSTRAINT [FK_TransactionEntries__ResponsibilityCenters]	FOREIGN KEY ([TenantId], [ResponsibilityCenterId]) REFERENCES [dbo].[ResponsibilityCenters] ([TenantId], [Id]),
	CONSTRAINT [FK_TransactionEntries__AgentAccounts]	FOREIGN KEY ([TenantId], [AgentAccountId])	REFERENCES [dbo].[AgentAccounts] ([TenantId], [Id]),
	CONSTRAINT [FK_TransactionEntries__Resources]	FOREIGN KEY ([TenantId], [ResourceId])	REFERENCES [dbo].[Resources] ([TenantId], [Id]),
	CONSTRAINT [FK_TransactionEntries__CreatedById]	FOREIGN KEY ([TenantId], [CreatedById])	REFERENCES [dbo].[LocalUsers] ([TenantId], [Id]),
	CONSTRAINT [FK_TransactionEntries__ModifiedById]FOREIGN KEY ([TenantId], [ModifiedById])REFERENCES [dbo].[LocalUsers] ([TenantId], [Id]),
	CONSTRAINT [FK_TransactionEntries__SignedById]FOREIGN KEY ([TenantId], [SignedById])REFERENCES [dbo].[LocalUsers] ([TenantId], [Id])
);
GO
CREATE INDEX [IX_Entries__DocumentId] ON [dbo].[TransactionEntries]([TenantId] ASC, [DocumentId] ASC);
GO
CREATE INDEX [IX_Entries__ResponsibilityCenterId] ON [dbo].[TransactionEntries]([TenantId] ASC, [ResponsibilityCenterId] ASC);
GO
CREATE INDEX [IX_Entries__AccountId] ON [dbo].[TransactionEntries]([TenantId] ASC, [AccountId] ASC);
GO
CREATE INDEX [IX_Entries__IfrsNoteId] ON [dbo].[TransactionEntries]([TenantId] ASC, [IfrsNoteId] ASC);
GO
ALTER TABLE [dbo].[TransactionEntries] ADD CONSTRAINT [DF_TransactionEntries__TenantId]  DEFAULT (CONVERT(INT, SESSION_CONTEXT(N'TenantId'))) FOR [TenantId];
GO
ALTER TABLE [dbo].[TransactionEntries] ADD CONSTRAINT [DF_TransactionEntries__CreatedAt]  DEFAULT (SYSDATETIMEOFFSET()) FOR [CreatedAt];
GO
ALTER TABLE [dbo].[TransactionEntries] ADD CONSTRAINT [DF_TransactionEntries__CreatedById]  DEFAULT (CONVERT(INT, SESSION_CONTEXT(N'UserId'))) FOR [CreatedById]
GO
ALTER TABLE [dbo].[TransactionEntries] ADD CONSTRAINT [DF_TransactionEntries__ModifiedAt]  DEFAULT (SYSDATETIMEOFFSET()) FOR [ModifiedAt];
GO
ALTER TABLE [dbo].[TransactionEntries] ADD CONSTRAINT [DF_TransactionEntries__ModifiedById]  DEFAULT (CONVERT(INT, SESSION_CONTEXT(N'UserId'))) FOR [ModifiedById]
GO