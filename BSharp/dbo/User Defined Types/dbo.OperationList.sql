CREATE TYPE [dbo].[OperationList] AS TABLE
(
    [Id]			INT,
    [OperationType] NVARCHAR (255)	NOT NULL,
    [Name]			NVARCHAR (255)	NOT NULL,
    [ParentId]		INT,
	[Status]		NVARCHAR(255)	NOT NULL DEFAULT(N'Inserted'), -- Unchanged, Inserted, Updated, Deleted.
	[TemporaryId]	INT				NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC),
	CHECK ([OperationType] IN (N'BusinessEntity', N'Investment', N'OperatingSegment'))
);