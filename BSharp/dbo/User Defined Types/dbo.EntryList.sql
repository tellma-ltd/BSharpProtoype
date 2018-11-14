CREATE TYPE [dbo].[EntryList] AS TABLE (
	[Id]			INT            NOT NULL,
    [LineId]			INT            NOT NULL,
    [EntryNumber]       INT            NOT NULL,
    [OperationId]       INT            NULL,
    [Reference]         NVARCHAR (50)  NULL,
    [AccountId]         NVARCHAR (255) NULL,
    [CustodyId]         INT            NOT NULL,
    [ResourceId]        INT            NOT NULL,
    [Direction]         SMALLINT       NOT NULL,
    [Amount]            MONEY          NOT NULL,
    [Value]             MONEY          NULL,
    [NoteId]            NVARCHAR (255) NULL,
    [RelatedReference]  NVARCHAR (50)  NULL,
    [RelatedAgentId]    INT            NULL,
    [RelatedResourceId] INT            NULL,
    [RelatedAmount]     MONEY          NULL,
	[Status]					NVARCHAR(10) NOT NULL DEFAULT(N'Inserted'), -- Unchanged, Inserted, Updated, Deleted.
	[TemporaryId]				INT	NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);
