CREATE TABLE [dbo].[Reconciliation] (
    [EntryId1] INT   NOT NULL,
    [EntryId2] INT   NOT NULL,
    [Amount]   MONEY NOT NULL,
    CONSTRAINT [PK_Reconciliation] PRIMARY KEY CLUSTERED ([EntryId1] ASC, [EntryId2] ASC)
);

