CREATE TYPE [dbo].[ResourceList] AS TABLE
(
    [Id]				INT,
    [MeasurementUnitId]	INT				NOT NULL, 
    [ResourceType]		NVARCHAR (255)	NOT NULL,
    [Name]				NVARCHAR (255)	NOT NULL,
	[IsActive]			BIT				NOT NULL DEFAULT (1),
	[Source]			NVARCHAR (255), -- Lease In/Acquisition/Production
	[Purpose]			NVARCHAR (255), -- Lease out/Sale/Production/SG&A
	[Code]				NVARCHAR (255),
    [Memo]				NVARCHAR (2048),
    [Lookup1]			NVARCHAR (255),
    [Lookup2]			NVARCHAR (255),
    [Lookup3]			NVARCHAR (255),
    [Lookup4]			NVARCHAR (255),
	[PartOf]			INT, -- for compound assets
    [FungibleParentId]	INT,
	[Status]			NVARCHAR(255)	NOT NULL DEFAULT(N'Inserted'), -- Unchanged, Inserted, Updated, Deleted.
	[TemporaryId]		INT				NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);