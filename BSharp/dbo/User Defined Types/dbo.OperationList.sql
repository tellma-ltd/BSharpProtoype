CREATE TYPE [dbo].[OperationList] AS TABLE
(
    [Id]            INT			  NOT NULL,
    [OperationType] NVARCHAR (50) NOT NULL,
    [Name]          NVARCHAR (50) NOT NULL,
    [Parent]        INT           NULL,
	[Status]		NVARCHAR(10) NOT NULL DEFAULT(N'Inserted'), -- Unchanged, Inserted, Updated, Deleted.
	[TemporaryId]	INT	NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);