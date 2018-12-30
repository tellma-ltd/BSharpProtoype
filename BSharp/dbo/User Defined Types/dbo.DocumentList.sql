CREATE TYPE [dbo].[DocumentList] AS TABLE (
	[Index]				INT,
	[Id]				INT,
	[State]				NVARCHAR (255)		NOT NULL DEFAULT (N'Voucher'), -- N'Plan', N'Inquiry', N'Template', N'Demand', N'Voucher'
	[DocumentType]		NVARCHAR (255)		NOT NULL DEFAULT (N'ManualJournal'),
	[Frequency]			NVARCHAR (255)		NOT NULL DEFAULT (N'OneTime'),
	[Duration]			INT					NOT NULL DEFAULT (0),
	[StartDateTime]		DATETIMEOFFSET (7)	NOT NULL DEFAULT (SYSDATETIMEOFFSET()),
	[EndDateTime]		DATETIMEOFFSET (7),
	--- Common for all lines, regardless of line type.
	[BaseLineId]		INT, -- this is like FunctionId, good for linear functions.
	[ScalingFactor]		FLOAT, -- Qty sold for Price list, Qty produced for BOM, throughput rate for oil well.	.	
	[Memo]				NVARCHAR (255),
	-- Common for all entries of all lines
	[OperationId]		INT,
	[AccountId]			NVARCHAR (255),
	[CustodyId]			INT,
	[ResourceId]		INT,
	[Direction]			SMALLINT,
	[Amount]			MONEY,
	[Value]				VTYPE,
	[NoteId]			NVARCHAR (255),
	[Reference]			NVARCHAR (255),
	[RelatedReference]	NVARCHAR (255),
	[RelatedAgentId]	INT,
	[RelatedResourceId]	INT,
	[RelatedAmount]		MONEY,
	--- If changing any of the above properties, the state will change
	[EntityState]		NVARCHAR(255)		NOT NULL DEFAULT(N'Inserted'),
	PRIMARY KEY CLUSTERED ([Index] ASC),
	CHECK ([State] IN (N'Plan', N'Inquiry', N'Template', N'Demand', N'Voucher')),
	CHECK ([Frequency] IN (N'OneTime', N'Daily', N'Weekly', N'Monthly', N'Quarterly', N'Yearly')),
	CHECK ([EntityState] IN (N'Unchanged', N'Inserted', N'Updated', N'Deleted')),
	CHECK ([EntityState] <> N'Inserted' OR [Id] IS NULL)
);