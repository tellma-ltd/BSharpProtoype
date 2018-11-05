CREATE TYPE [dbo].[EntryList] AS TABLE (
    [DocumentId]        INT            NOT NULL,
    [LineNumber]        INT            NOT NULL,
    [EntryNumber]       INT            NOT NULL,
    [OperationId]       INT            NULL,
    [Reference]         NVARCHAR (50)  NULL,
    [AccountId]         NVARCHAR (255) NULL,
    [CustodyId]         INT            NULL,
    [ResourceId]        INT            NULL,
    [Direction]         INT            NULL,
    [Amount]            MONEY          NULL,
    [Value]             MONEY          NULL,
    [NoteId]            NVARCHAR (255) NULL,
    [RelatedReference]  NVARCHAR (50)  NULL,
    [RelatedAgentId]    INT            NULL,
    [RelatedResourceId] INT            NULL,
    [RelatedAmount]     MONEY          NULL,
    PRIMARY KEY CLUSTERED ([DocumentId] ASC, [LineNumber] ASC, [EntryNumber] ASC));

