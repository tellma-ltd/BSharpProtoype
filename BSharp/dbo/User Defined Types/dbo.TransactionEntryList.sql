CREATE TYPE [dbo].[TransactionEntryList] AS TABLE (
	[Index]					INT,
	[DocumentIndex]			INT					NOT NULL,
	[Id]					INT,
	[DocumentId]			INT,
	[IsSystem]				BIT					NOT NULL DEFAULT (0),
	[Direction]				SMALLINT			NOT NULL,
	[AccountId]				INT		NOT NULL,
	[IfrsNoteId]			NVARCHAR (255),		-- Note that the responsibility center might define the Ifrs Note
	[ResponsibilityCenterId]INT,				-- called SegmentId in B10. When not needed, we use the entity itself.
	[AgentAccountId]		INT, 
	[ResourceId]			INT,				-- NUll because it may be specified by Account				
	[ValueMeasure]			VTYPE				NOT NULL DEFAULT (0), -- measure on which the value is based. If it is MassMeasure then [Mass] must equal [ValueMeasure] and so on.
	[MoneyAmount]			MONEY				NOT NULL DEFAULT (0), -- Amount in foreign Currency 
	[Mass]					DECIMAL				NOT NULL DEFAULT (0), -- MassUnit, like LTZ bar, cement bag, etc
	[Volume]				DECIMAL				NOT NULL DEFAULT (0), -- VolumeUnit, possibly for shipping
	[Count]					DECIMAL				NOT NULL DEFAULT (0), -- CountUnit
	[Time]					DECIMAL				NOT NULL DEFAULT (0), -- ServiceTimeUnit
	[Value]					VTYPE				NOT NULL DEFAULT (0), -- equivalent in functional currency
	[ExpectedSettlingDate]	DATETIME2(7),  -- Can be used to decide mobilize split balance between current and non-current
	[Reference]				NVARCHAR (255)		NOT NULL DEFAULT  (N''), -- Can be updated even after posting.
	[Memo]					NVARCHAR (255), -- a textual description for statements and reports
	[RelatedReference]		NVARCHAR (255), -- Can be updated after posting
	[RelatedResourceId]		INT, -- Good, Service, Labor, Machine usage
	[RelatedAgentAccountId]	INT,
	[RelatedMoneyAmount]	MONEY 				NOT NULL DEFAULT (0), -- e.g., amount subject to tax
	/*
	[RelatedMass]			DECIMAL				NOT NULL DEFAULT (0), -- MassUnit, like LTZ bar
	[RelatedVolume]			DECIMAL				NOT NULL DEFAULT (0), -- VolumeUnit, possibly for shipping
	[RelatedCount]			DECIMAL				NOT NULL DEFAULT (0), -- CountUnit
	[RelatedTime]			DECIMAL				NOT NULL DEFAULT (0), -- ServiceTimeUnit
	[RelatedValue]			VTYPE				NOT NULL DEFAULT (0), -- 
	*/
	[EntityState]			NVARCHAR (255)		NOT NULL DEFAULT(N'Inserted'),
	PRIMARY KEY ([Index] ASC),
	INDEX IX_EntryList_DocumentIndex ([DocumentIndex]),
	CHECK ([Direction] IN (-1, 1)),
	CHECK ([EntityState] IN (N'Unchanged', N'Inserted', N'Updated', N'Deleted')),
	CHECK ([EntityState] <> N'Inserted' OR [Id] IS NULL)
);