CREATE TYPE [dbo].[AgentList] AS TABLE
(
	[Id]						INT NOT NULL,
	[AgentType]				NVARCHAR (50)      NOT NULL,
    [Name]						NVARCHAR (50)      NOT NULL,
    [IsActive]					BIT NOT NULL DEFAULT 1,
	[IsRelated]					BIT		DEFAULT ((0)) NOT NULL,
    [UserId]					NVARCHAR (450)     NULL,
    [TaxIdentificationNumber]	NVARCHAR (50)      NULL,
    [RegisteredAddress]			NVARCHAR (255)     NULL,
    [Title]						NVARCHAR (50)      NULL,
    [Gender]					NCHAR (1)          NULL,
    [BirthDateTime]				DATETIMEOFFSET (7) NULL,
	[Status]					NVARCHAR(10) NOT NULL DEFAULT(N'Inserted'), -- Unchanged, Inserted, Updated, Deleted.
	[TemporaryId]				INT	NULL,
	PRIMARY KEY CLUSTERED ([Id] ASC)
);

