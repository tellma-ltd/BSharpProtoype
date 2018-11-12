CREATE TABLE [dbo].[Operations] (
	[TenantId]				 INT				NOT NULL,
    [Id]            INT           IDENTITY (1, 1) NOT NULL,
    [OperationType] NVARCHAR (50) NOT NULL,
    [Name]          NVARCHAR (50) NOT NULL,
    [Parent]        INT           NULL,
    CONSTRAINT [PK_Operations] PRIMARY KEY CLUSTERED ([TenantId] ASC, [Id] ASC),
    CONSTRAINT [FK_Operations_Operations] FOREIGN KEY ([TenantId], [Parent]) REFERENCES [dbo].[Operations] ([TenantId], [Id]),
    CONSTRAINT [FK_Operations_OperationTypes] FOREIGN KEY ([OperationType]) REFERENCES [dbo].[OperationTypes] ([Id]) ON UPDATE CASCADE
);