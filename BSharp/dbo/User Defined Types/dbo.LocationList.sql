CREATE TYPE [dbo].[LocationList] AS TABLE
(
	[Id]           INT           NOT NULL,
    [LocationType] NVARCHAR (50) NOT NULL,
    [Name]						NVARCHAR (50)      NOT NULL,
    [IsActive]					BIT NOT NULL DEFAULT 1,
    [Address]      NVARCHAR (50) NULL,
    [Parent]       INT           NULL,
    [Custodian]    INT           NULL,
	[Status]					NVARCHAR(10) NOT NULL DEFAULT(N'Inserted'), -- Unchanged, Inserted, Updated, Deleted.
	[TemporaryId]				INT	NULL,
	PRIMARY KEY CLUSTERED ([Id] ASC)
);