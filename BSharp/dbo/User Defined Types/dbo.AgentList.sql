CREATE TYPE [dbo].[AgentList] AS TABLE
(
	[Id]						INT,
	[AgentType]					NVARCHAR (50)		NOT NULL,
    [Name]						NVARCHAR (50)		NOT NULL,
    [IsActive]					BIT	DEFAULT (1)		NOT NULL ,
	[IsRelated]					BIT	DEFAULT (0)		NOT NULL,
    [UserId]					NVARCHAR (450),
    [TaxIdentificationNumber]	NVARCHAR (50),
    [RegisteredAddress]			NVARCHAR (255),
    [Title]						NVARCHAR (50),
    [Gender]					NCHAR (1),
    [BirthDateTime]				DATETIMEOFFSET (7),
	[Status]					NVARCHAR(10)		NOT NULL DEFAULT(N'Inserted'), -- Unchanged, Inserted, Updated, Deleted.
	[TemporaryId]				INT					NOT NULL,
	PRIMARY KEY CLUSTERED ([Id] ASC),
	CHECK ([AgentType] IN (N'Individual', N'Organization', N'OrganizationUnit'))
);

