CREATE TABLE [dbo].[Workflows] (
	[TenantId]		INT,
	[Id]			INT					IDENTITY(1,1),
	[Securable]		NVARCHAR(255)		NOT NULL,
	[RoleId]		INT					NOT NULL,
	[Criteria]		NVARCHAR(1024), -- Any document of the said type satisfying the criteria must be signed by all roles
	[CreatedAt]		DATETIMEOFFSET(7)	NOT NULL,
	[CreatedBy]		NVARCHAR(450)		NOT NULL,
	[ModifiedAt]	DATETIMEOFFSET(7)	NOT NULL, 
	[ModifiedBy]	NVARCHAR(450)		NOT NULL,
	CONSTRAINT [PK_Workflows] PRIMARY KEY CLUSTERED ([TenantId] ASC, [Id] ASC),
);