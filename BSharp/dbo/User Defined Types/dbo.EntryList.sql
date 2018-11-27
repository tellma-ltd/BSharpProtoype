CREATE TYPE [dbo].[EntryList] AS TABLE (
	[Id]				INT,
    [LineId]			INT				NOT NULL,
    [EntryNumber]       INT				NOT NULL,
    [OperationId]       INT,
    [Reference]         NVARCHAR (50),
    [AccountId]         NVARCHAR (255),
    [CustodyId]         INT,
    [ResourceId]        INT,
    [Direction]         SMALLINT,
    [Amount]            MONEY,
    [Value]             MONEY,
    [NoteId]            NVARCHAR (255),
    [RelatedReference]  NVARCHAR (50),
    [RelatedAgentId]    INT,
    [RelatedResourceId] INT,
    [RelatedAmount]     MONEY,
	[Status]			NVARCHAR(10)	NOT NULL DEFAULT(N'Inserted'), -- Unchanged, Inserted, Updated, Deleted.
	[TemporaryId]		INT				NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC),
	CHECK ([Status] IN (N'Unchanged', N'Inserted', N'Updated', N'Deleted'))
);
