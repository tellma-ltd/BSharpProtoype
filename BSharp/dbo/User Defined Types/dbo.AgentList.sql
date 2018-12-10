CREATE TYPE [dbo].[AgentList] AS TABLE
(
	[Index]						INT,
	[Id]						INT,
	[AgentType]					NVARCHAR (255)		NOT NULL,
    [Name]						NVARCHAR (255)		NOT NULL,
    [IsActive]					BIT					NOT NULL,		
	[Code]						NVARCHAR (255),
    [Address]					NVARCHAR (255),
    [BirthDateTime]				DATETIMEOFFSET (7),
	[IsRelated]					BIT,
    [UserId]					NVARCHAR (450),
    [TaxIdentificationNumber]	NVARCHAR (255),
    [Title]						NVARCHAR (255),
    [Gender]					NCHAR (1),
    [CreatedAt]					DATETIMEOFFSET(7)	NOT NULL,
    [CreatedBy]					NVARCHAR(450)		NOT NULL,
    [ModifiedAt]				DATETIMEOFFSET(7)	NOT NULL, 
    [ModifiedBy]				NVARCHAR(450)		NOT NULL,
	[EntityState]				NVARCHAR(255),
    PRIMARY KEY CLUSTERED ([Index] ASC),
	CHECK ([AgentType] IN (N'Individual', N'Organization', N'OrganizationUnit')),
	CHECK ([EntityState] IN (N'Unchanged', N'Inserted', N'Updated', N'Deleted')),
	CHECK ([EntityState] <> N'Inserted' OR [Id] IS NULL)
);

