CREATE TABLE [dbo].[Entries] (
	[TenantId]					INT,
	[Id]						INT					IDENTITY,
	[DocumentId]				INT					NOT NULL,
-- TODO: Line types are either 1-1, where you enter all the details in a grid, or M-M like production
	[LineType]					NVARCHAR(255)		NOT NULL DEFAULT(N'manual-journals'),
	[Direction]					SMALLINT			NOT NULL,
 -- Account specifies the IFRS Concept (which itself has filter on Note), and additional filters on the other columns
	[AccountId]					INT					NOT NULL,
-- Analysis of accounts including: cash, non current assets, equity, and expenses.
	[IFRSNoteId]				INT,				-- Note that the responsibility center might define the IFRS Note
-- The business segment that "owns" the asset/liablity, and whose performance is assessed by the revenue/expense
	[ResponsibilityCenterId]	INT					NOT NULL, -- SegmentId.. When no needed, we use the entity itself.
-- subaccount of: agent having custody of asset/agent against whom we are liable. N/A for P/L accounts
	[AgentAccountId]			INT					NOT NULL, 
	[ResourceId]				INT					NOT NULL, -- the actual asset, liability, good/service sold for revenues and direct expenses, good/service consumed for indirect expenses
-- Tracking additive measures
	[ValueMeasure]				VTYPE				NOT NULL DEFAULT (0), -- measure on which the value is based. If it is MassMeasure then [Mass] must equal [ValueMeasure] and so on.
	[MoneyAmount]				MONEY				NOT NULL DEFAULT (0), -- Amount in foreign Currency 
	[Mass]						DECIMAL				NOT NULL DEFAULT (0), -- MassUnit, like LTZ bar, cement bag, etc
	[Volume]					DECIMAL				NOT NULL DEFAULT (0), -- VolumeUnit, possibly for shipping
	[Count]						DECIMAL				NOT NULL DEFAULT (0), -- CountUnit
	[Time]						DECIMAL				NOT NULL DEFAULT (0), -- ServiceTimeUnit
	[Value]						VTYPE				NOT NULL DEFAULT (0), -- equivalent in functional currency
-- Settling date of assets, liabilities. Examples: Asset Disposal date, Inventory expiry date, loan/borrowing settlement date.
	[ExpectedSettlingDate]		DATETIME2(7),  -- Can be used to decide mobilize split balance between current and non-current
-- useful to link the system to an external system (bank, paper, etc). 
	[Reference]					NVARCHAR (255)		NOT NULL DEFAULT  (N''), -- Can be updated even after posting.
-- Additional information to satisfy reporting requirements
	[Memo]						NVARCHAR(255), -- a textual description for statements and reports
	[RelatedReference]			NVARCHAR (255), -- for storing an extra string, such as cash machine ref for Tax purposes
-- for debiting asset accounts, related resource is the good/service acquired from supplier/customer/storage
-- for crediting asset accounts, related resource is the good/service delivered to supplier/customer/storage as resource
-- for debiting VAT purchase account, related resource is the good/service purchased
-- for crediting VAT Sales account, related resource is the good/service sold
-- for crediting VAT purchase, debiting VAT sales, or liability account: related resource is N/A
	[RelatedResourceId]			INT, -- Good, Service, Labor, Machine usage
-- The related agent account is the implicit agent account that had two entries, one debiting and one crediting and hence removes
-- Examples include supplier account in cash purchase, customer account in cash sales, employee account in cash payroll, 
-- supplier account in VAT purchase entry, customer account in VAT sales entry, and WIP account in direct production.
	[RelatedAgentAccountId]		INT,
	[RelatedMoneyAmount]		MONEY 				NOT NULL DEFAULT (0), -- e.g., amount subject to tax
	/*
	[RelatedMass]				DECIMAL				NOT NULL DEFAULT (0), -- MassUnit, like LTZ bar
	[RelatedVolume]				DECIMAL				NOT NULL DEFAULT (0), -- VolumeUnit, possibly for shipping
	[RelatedCount]				DECIMAL				NOT NULL DEFAULT (0), -- CountUnit
	[RelatedTime]				DECIMAL				NOT NULL DEFAULT (0), -- ServiceTimeUnit
	[RelatedValue]				VTYPE				NOT NULL DEFAULT (0), -- 
	*/
-- for auditing
	[CreatedAt]					DATETIMEOFFSET(7)	NOT NULL,
	[CreatedById]				INT					NOT NULL,
	[ModifiedAt]				DATETIMEOFFSET(7)	NOT NULL, 
	[ModifiedById]				INT					NOT NULL,
	CONSTRAINT [PK_Entries] PRIMARY KEY CLUSTERED ([TenantId] ASC, [Id] ASC),
	CONSTRAINT [CK_Entries_Direction]	CHECK ([Direction] IN (-1, 1)),
	CONSTRAINT [FK_Entries_Documents]	FOREIGN KEY ([TenantId], [DocumentId])	REFERENCES [dbo].[Documents] ([TenantId], [Id]) ON DELETE CASCADE,
	CONSTRAINT [FK_Entries_LineTypes]	FOREIGN KEY ([TenantId], [LineType])	REFERENCES [dbo].[LineTypes] ([TenantId], [Id]),
--	CONSTRAINT [FK_Entries_Operations]	FOREIGN KEY ([TenantId], [ResponsibilityCenterId]) REFERENCES [dbo].[ResponsibilityCenters] ([TenantId], [Id]),
--	CONSTRAINT [FK_Entries_Accounts]	FOREIGN KEY ([TenantId], [AccountId])	REFERENCES [dbo].[IFRSConcepts] ([TenantId], [Id]),
	CONSTRAINT [FK_Entries_AgentAccounts]	FOREIGN KEY ([TenantId], [AgentAccountId])	REFERENCES [dbo].[AgentAccounts] ([TenantId], [Id]),
	CONSTRAINT [FK_Entries_Resources]	FOREIGN KEY ([TenantId], [ResourceId])	REFERENCES [dbo].[Resources] ([TenantId], [Id]),
--	CONSTRAINT [FK_Entries_Notes]		FOREIGN KEY ([TenantId], [NoteId])		REFERENCES [dbo].[Notes] ([TenantId], [Id]),
--	CONSTRAINT [FK_Entries_AccountsNotes] FOREIGN KEY ([TenantId], [AccountId], [NoteId], [Direction]) REFERENCES [dbo].[AccountsNotes] ([TenantId], [AccountId], [NoteId], [Direction]),
	CONSTRAINT [FK_Entries_CreatedById]	FOREIGN KEY ([TenantId], [CreatedById])	REFERENCES [dbo].[LocalUsers] ([TenantId], [Id]),
	CONSTRAINT [FK_Entries_ModifiedById]	FOREIGN KEY ([TenantId], [ModifiedById])	REFERENCES [dbo].[LocalUsers] ([TenantId], [Id])
);
GO
CREATE INDEX [IX_Entries__DocumentId] ON [dbo].[Entries]([TenantId] ASC, [DocumentId] ASC);
GO
CREATE INDEX [IX_Entries__OperationId] ON [dbo].[Entries]([TenantId] ASC, [ResponsibilityCenterId] ASC);
GO
CREATE INDEX [IX_Entries__AccountId] ON [dbo].[Entries]([TenantId] ASC, [AccountId] ASC);
GO
--CREATE INDEX [IX_Entries__NoteId] ON [dbo].[Entries]([TenantId] ASC, [NoteId] ASC);
--GO