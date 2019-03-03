CREATE TABLE [dbo].[Entries] (
	[TenantId]				INT,
	[Id]					INT					IDENTITY,
	[DocumentId]			INT					NOT NULL,
	[LineType]				NVARCHAR(255)		NOT NULL DEFAULT(N'manual-journals'),
	[Direction]				SMALLINT			NOT NULL,
	[AccountId]				INT					NOT NULL, -- specifies IFRS Concept (which has filter on Note) and IFRS Note or additional filter 
-- Presumably specifies the IFRS expense function for expense accounts. Several centers may make an operating segment
-- Sales, Production, Selling & distribution, Admin
	[ResponsibilityCenterId]INT					NOT NULL,
-- Analysis of expense accounts and some current and non current accounts.
	[NoteId]				NVARCHAR (255),		-- Includes expense function. Note that the responsibility center might force it
-- Documentation of assets/liabilites/purchases/sales. Think of inventory and decide what is agent, resource, etc.
	[AgentAccountId]		INT					NOT NULL, -- subaccount of the actual person having custody of asset/or against whom we are liable/or customer for revenues and direct expenses, else n/a
	[ResourceId]			INT					NOT NULL, -- the actual asset, liability, good sold for direct expenses and revenues, good and services consumed for indirect expenses
	[ResourceAccountId]		INT					NOT NULL, -- subaccount of the resource, such as Batch, Check, components of complex asset
-- Tracking measures
	[MoneyAmount]			MONEY				NOT NULL DEFAULT (0), -- AmountCurrency 
	[Mass]					DECIMAL				NOT NULL DEFAULT (0), -- MassUnit, like LTZ bar
	[Volume]				DECIMAL				NOT NULL DEFAULT (0), -- VolumeUnit, possibly for shipping
	[Count]					DECIMAL				NOT NULL DEFAULT (0), -- CountUnit
	[Time]					DECIMAL				NOT NULL DEFAULT (0), -- ServiceTimeUnit
	[Value]					VTYPE				NOT NULL DEFAULT (0), -- equivalent in functional currency
-- settling date. Can be used to decide current/non current
	[ExpectedClosingDate]	DATETIMEOFFSET(7), 
-- useful in statements and reports
	[Reference]				NVARCHAR (255)		NOT NULL DEFAULT  (N''), -- This is Voucher Reference
	[Memo]					NVARCHAR(255),
-- Related details normally appear on another entry
	[RelatedReference]		NVARCHAR (255), -- for storing an extra string, such as cash machine ref for ERCA
-- for debiting asset accounts, related resource is acquired from supplier/customer/storage
-- for crediting asset accounts, related reosurce is the resource delivered to supplier/customer/storage as resource
-- for liability account, related resource is n/a
	[RelatedResourceAccountId]	INT, -- check
	[RelatedResourceId]		INT, -- resource purchased or withdrawn from storage) 	service, Labor, Machine service,
	[RelatedAgentAccountId]	INT, -- Customer/Supplier/Employee in Tax Withholding reports, supplier/warehouse for expenses, customer for revenues
	[RelatedMoneyAmount]	MONEY, -- what about related volumne, mass, etc...
	[RelatedMass]			DECIMAL				NOT NULL DEFAULT (0), -- MassUnit, like LTZ bar
	[RelatedVolume]			DECIMAL				NOT NULL DEFAULT (0), -- VolumeUnit, possibly for shipping
	[RelatedCount]			DECIMAL				NOT NULL DEFAULT (0), -- CountUnit
	[RelatedTime]			DECIMAL				NOT NULL DEFAULT (0), -- ServiceTimeUnit
	[RelatedValue]			VTYPE				NOT NULL DEFAULT (0), -- equivalent in functional currency
-- for auditing
	[CreatedAt]				DATETIMEOFFSET(7)	NOT NULL,
	[CreatedById]			INT					NOT NULL,
	[ModifiedAt]			DATETIMEOFFSET(7)	NOT NULL, 
	[ModifiedById]			INT					NOT NULL,
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