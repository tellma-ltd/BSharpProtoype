CREATE TYPE [dbo].[ResourceList] AS TABLE
(
    [Id]				INT,
    [ResourceType]		NVARCHAR (50)	NOT NULL,
    [Name]				NVARCHAR (50)	NOT NULL,
	[UnitOfMeasure]		NVARCHAR (5)	NOT NULL,    
	[Code]				NVARCHAR (50),
    [Memo]				NVARCHAR (2048),
    [Lookup1]			NVARCHAR (50),
    [Lookup2]			NVARCHAR (50),
    [Lookup3]			NVARCHAR (50),
    [Lookup4]			NVARCHAR (50),
	[PartOf]			INT, -- for compound assets
    [FungibleParentId]	INT,
	[Status]			NVARCHAR(10)	NOT NULL DEFAULT(N'Inserted'), -- Unchanged, Inserted, Updated, Deleted.
	[TemporaryId]		INT				NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);