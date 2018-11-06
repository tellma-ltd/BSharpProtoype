CREATE TABLE [dbo].[EventTypes] (
    [TransactionType] NVARCHAR (50) NOT NULL,
    [State]    NVARCHAR (10) NOT NULL,
    [Name]     NVARCHAR (50) NULL,
    CONSTRAINT [PK_EventTypes] PRIMARY KEY CLUSTERED ([TransactionType] ASC, [State] ASC),
    CONSTRAINT [FK_EventTypes_TransactionTypes] FOREIGN KEY ([TransactionType]) REFERENCES [dbo].[TransactionTypes] ([Id]) ON UPDATE CASCADE,
    CONSTRAINT [FK_EventTypes_States] FOREIGN KEY ([State]) REFERENCES [dbo].[States] ([Id])
);

