CREATE TABLE [dbo].[EntryDetails] (
    [Id]         INT   NOT NULL,
    [EntryId]    INT   NOT NULL,
    [ResourceId] INT   NOT NULL,
    [Value]      MONEY NOT NULL,
    CONSTRAINT [PK_EntryDetails] PRIMARY KEY CLUSTERED ([Id] ASC)
);

