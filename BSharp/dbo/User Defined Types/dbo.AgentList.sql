CREATE TYPE [dbo].[AgentList] AS TABLE
(
	[Id]						INT,
	[AgentType]					NVARCHAR (255)		NOT NULL,
    [Name]						NVARCHAR (255)		NOT NULL,
    [IsActive]					BIT					NOT NULL DEFAULT (1),
	[IsRelated]					BIT					NOT NULL DEFAULT (0),
    [UserId]					NVARCHAR (450),
    [TaxIdentificationNumber]	NVARCHAR (255),
    [RegisteredAddress]			NVARCHAR (255),
    [Title]						NVARCHAR (255),
    [Gender]					NCHAR (1),
    [BirthDateTime]				DATETIMEOFFSET (7),
	[Status]					NVARCHAR(255)		NOT NULL DEFAULT(N'Inserted'), -- Unchanged, Inserted, Updated, Deleted.
	[TemporaryId]				INT					NOT NULL,
	PRIMARY KEY CLUSTERED ([Id] ASC),
	CHECK ([AgentType] IN (N'Individual', N'Organization', N'OrganizationUnit'))
);

