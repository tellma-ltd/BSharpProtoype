CREATE TYPE [dbo].[EntryList] AS TABLE (
	[Id]				INT,
    [LineId]			INT				NOT NULL,
    [EntryNumber]       INT				NOT NULL,
    [OperationId]       INT,
    [Reference]         NVARCHAR (255),
    [AccountId]         NVARCHAR (255),
    [CustodyId]         INT,
    [ResourceId]        INT,
    [Direction]         SMALLINT,
    [Amount]            MONEY,
    [Value]             MONEY,
    [NoteId]            NVARCHAR (255),
    [RelatedReference]  NVARCHAR (255),
    [RelatedAgentId]    INT,
    [RelatedResourceId] INT,
    [RelatedAmount]     MONEY,
	[Status]			NVARCHAR(255)	NOT NULL DEFAULT(N'Inserted'), -- Unchanged, Inserted, Updated, Deleted.
	[TemporaryId]		INT				NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC),
	CHECK ([Direction] IN (-1, 1)),
	CHECK ([Status] IN (N'Unchanged', N'Inserted', N'Updated', N'Deleted'))
);
