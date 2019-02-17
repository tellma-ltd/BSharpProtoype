CREATE TABLE [dbo].[Entries] (
	[TenantId]				INT,
	[Id]					INT					IDENTITY,
	[DocumentId]			INT					NOT NULL,
	[LineType]				NVARCHAR(255)		NOT NULL DEFAULT(N'manual-journals'),
	[Direction]				SMALLINT			NOT NULL,
	[AccountId]				INT					NOT NULL, -- specifies IFRS Concept (which has filter on Note) and IFRS Note or additional filter 
-- Analysis of expense accounts and some current and non crrent accounts.
	[NoteId]				NVARCHAR (255),		-- Includes IFRS expense nature...
	-- [OperatingSegmentId]?
	[OperationId]			INT					NOT NULL, -- still needed? more like operating segment?
	-- some redundancy between org and function, especially if organization is by function :)
	[OrganizationUnitId]	INT					NOT NULL, -- e.g., general, admin, S&D, services to GSA, , producton, services to production (maintenance/accommodation/inventory)
	[FunctionId]			INT					NOT NULL, -- e.g., general, admin, S&M, HR, finance, production, maintenance, accommodation
	[ProductCategoryId]		INT					NOT NULL, -- e.g., general, sales, services OR, Steel, Real Estate, Coffee, ..
	[GeographicRegionId]	INT					NOT NULL, -- e.g., general, Oromia, Bole, Kersa
	[CustomerSegmentId]		INT					NOT NULL, -- e.g., general, then corporate, individual or M, F or Adult youth, etc...
	[TaxSegmentId]			INT					NOT NULL, -- e.g., general, existing (30%), expansion (0%)
-- Documentation of assets/liabilites/purchases/sales.
	[AgentId]				INT					NOT NULL, -- the actual person having custody of asset/or against whom we are liable/or consumer of expense or provider of revenues (customer)
	[AgentAccountId]		INT					NOT NULL, -- subaccount of the agent
	[ResourceId]			INT					NOT NULL, -- the actual asset, liability, good sold, good and services consumed (map to IFRS Resource)
	-- Tracking measures
	[MoneyAmount]			MONEY				NOT NULL DEFAULT (0), -- AmountCurrency 
	[Mass]					DECIMAL				NOT NULL DEFAULT (0), -- MassUnit
	[Volume]				DECIMAL				NOT NULL DEFAULT (0), -- VolumeUnit
	[Count]					DECIMAL				NOT NULL DEFAULT (0), -- CountUnit
	[ServiceTime]			DECIMAL				NOT NULL DEFAULT (0), -- UsageTimeUnit
	[ServiceCount]			DECIMAL				NOT NULL DEFAULT (0), -- UsageCountUnit
	[ServiceDistance]		DECIMAL				NOT NULL DEFAULT (0), -- UsageDistanceUnit
	[Value]					VTYPE				NOT NULL DEFAULT (0), -- equivalent in functional currency

	[Reference]				NVARCHAR (255)		NOT NULL DEFAULT  (N''), -- This is Entry Reference
	[Memo]					NVARCHAR(255),
	[ExpectedClosingDate]	DATETIMEOFFSET(7),
	[RelatedResourceId]		INT,
	[RelatedReference]		NVARCHAR (255),
	[RelatedAgentId]		INT,
	[RelatedAmount]			MONEY, -- what about related volumne, mass, etc...
	[CreatedAt]				DATETIMEOFFSET(7)	NOT NULL,
	[CreatedById]			INT					NOT NULL,
	[ModifiedAt]			DATETIMEOFFSET(7)	NOT NULL, 
	[ModifiedById]			INT					NOT NULL,
	CONSTRAINT [PK_Entries] PRIMARY KEY CLUSTERED ([TenantId] ASC, [Id] ASC),
	CONSTRAINT [CK_Entries_Direction]	CHECK ([Direction] IN (-1, 1)),
	CONSTRAINT [FK_Entries_Documents]	FOREIGN KEY ([TenantId], [DocumentId])	REFERENCES [dbo].[Documents] ([TenantId], [Id]) ON DELETE CASCADE,
	CONSTRAINT [FK_Entries_LineTypes]	FOREIGN KEY ([TenantId], [LineType])	REFERENCES [dbo].[LineTypes] ([TenantId], [Id]),
	CONSTRAINT [FK_Entries_Operations]	FOREIGN KEY ([TenantId], [OperationId]) REFERENCES [dbo].[Operations] ([TenantId], [Id]),
--	CONSTRAINT [FK_Entries_Accounts]	FOREIGN KEY ([TenantId], [AccountId])	REFERENCES [dbo].[IFRSConcepts] ([TenantId], [Id]),
	CONSTRAINT [FK_Entries_Agents]	FOREIGN KEY ([TenantId], [AgentId])	REFERENCES [dbo].[Agents] ([TenantId], [Id]),
	CONSTRAINT [FK_Entries_Resources]	FOREIGN KEY ([TenantId], [ResourceId])	REFERENCES [dbo].[Resources] ([TenantId], [Id]),
	CONSTRAINT [FK_Entries_Notes]		FOREIGN KEY ([TenantId], [NoteId])		REFERENCES [dbo].[Notes] ([TenantId], [Id]),
--	CONSTRAINT [FK_Entries_AccountsNotes] FOREIGN KEY ([TenantId], [AccountId], [NoteId], [Direction]) REFERENCES [dbo].[AccountsNotes] ([TenantId], [AccountId], [NoteId], [Direction]),
	CONSTRAINT [FK_Entries_CreatedById]	FOREIGN KEY ([TenantId], [CreatedById])	REFERENCES [dbo].[LocalUsers] ([TenantId], [Id]),
	CONSTRAINT [FK_Entries_ModifiedById]	FOREIGN KEY ([TenantId], [ModifiedById])	REFERENCES [dbo].[LocalUsers] ([TenantId], [Id])
);
GO
CREATE INDEX [IX_Entries__DocumentId] ON [dbo].[Entries]([TenantId] ASC, [DocumentId] ASC);
GO
CREATE INDEX [IX_Entries__OperationId] ON [dbo].[Entries]([TenantId] ASC, [OperationId] ASC);
GO
CREATE INDEX [IX_Entries__AccountId] ON [dbo].[Entries]([TenantId] ASC, [AccountId] ASC);
GO
CREATE INDEX [IX_Entries__NoteId] ON [dbo].[Entries]([TenantId] ASC, [NoteId] ASC);
GO