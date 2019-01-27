CREATE TABLE [dbo].[RoleMemberships] (
	[TenantId]			INT,
	[Id]				INT				IDENTITY (1, 1),
	[Userid]			INT				NOT NULL,
	[RoleId]			INT				NOT NULL,
	[Memo]				NVARCHAR(255),
	[CreatedAt]			DATETIMEOFFSET(7)	NOT NULL,
	[CreatedById]		INT		NOT NULL,
	[ModifiedAt]		DATETIMEOFFSET(7)	NOT NULL, 
	[ModifiedById]		INT		NOT NULL,

	CONSTRAINT [PK_RoleMemberships] PRIMARY KEY CLUSTERED ([TenantId] ASC, [Id] ASC),
);