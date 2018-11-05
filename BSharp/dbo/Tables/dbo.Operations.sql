CREATE TABLE [dbo].[Operations] (
    [Id]            INT           IDENTITY (1, 1) NOT NULL,
    [OperationType] NVARCHAR (50) NOT NULL,
    [Name]          NVARCHAR (50) NOT NULL,
    [Parent]        INT           NULL,
    CONSTRAINT [PK_Operations] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_Operations_Operations] FOREIGN KEY ([Parent]) REFERENCES [dbo].[Operations] ([Id]),
    CONSTRAINT [FK_Operations_OperationTypes] FOREIGN KEY ([OperationType]) REFERENCES [dbo].[OperationTypes] ([Id]) ON UPDATE CASCADE
);

