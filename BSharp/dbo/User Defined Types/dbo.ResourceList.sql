CREATE TYPE [dbo].[ResourceList] AS TABLE
(
    [Id]                     INT            NOT NULL,
    [ResourceType]           NVARCHAR (50)  NOT NULL,
    [Name]                   NVARCHAR (50)  NOT NULL,
    [Code]                   NVARCHAR (50)  NULL,
    [UnitOfMeasure]          NVARCHAR (5)   NOT NULL,
    [Memo]                   NVARCHAR (MAX) NULL,
    [Lookup1]                NVARCHAR (50)  NULL,
    [Lookup2]                NVARCHAR (50)  NULL,
    [Lookup3]                NVARCHAR (50)  NULL,
    [Lookup4]                NVARCHAR (50)  NULL,
    [GoodForServiceParentId] INT            NULL,
    [FungibleParentId]       INT            NULL,
	[Status]					NVARCHAR(10) NOT NULL DEFAULT(N'Inserted'), -- Unchanged, Inserted, Updated, Deleted.
	[TemporaryId]				INT	NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);