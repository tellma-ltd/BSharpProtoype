CREATE TABLE [dbo].[Reconciliation] (
    [DocumentId1] INT   NOT NULL,
	[LineNumber1] INT   NOT NULL,
	[EntryNumber1] INT   NOT NULL,
    [DocumentId2] INT   NOT NULL,
	[LineNumber2] INT   NOT NULL,
	[EntryNumber2] INT   NOT NULL,
    [Amount]   MONEY NOT NULL,
    CONSTRAINT [PK_Reconciliation] PRIMARY KEY CLUSTERED (	[DocumentId1] ASC, [LineNumber1] ASC, [EntryNumber1] ASC, 
															[DocumentId2] ASC, [LineNumber2] ASC, [EntryNumber2] ASC)
);

