CREATE TYPE [dbo].[DocumentLineTypeForSaveList] AS TABLE (
	[Index]				INT,
	[LineType]			NVARCHAR (255),
	[BaseLineId]		INT,
	[ScalingFactor]		FLOAT,
	[Memo]				NVARCHAR(255),
	[OperationId]		INT	,
	[AccountId]			NVARCHAR (255),
	[CustodyId]			INT,
	[ResourceId]		INT	,
	[Direction]			SMALLINT,
	[Amount]			MONEY,
	[Value]				VTYPE		NOT NULL,
	[NoteId]			NVARCHAR (255),
	[Reference]			NVARCHAR (255),
	[RelatedReference]	NVARCHAR (255),
	[RelatedAgentId]	INT,
	[RelatedResourceId]	INT,
	[RelatedAmount]		MONEY
	PRIMARY KEY ([Index] ASC, [LineType] ASC)
);
