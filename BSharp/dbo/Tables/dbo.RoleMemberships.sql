CREATE TABLE [dbo].[RoleMemberships] (
	[TenantId]			INT,
	[Id]				INT				IDENTITY,
	[Userid]			INT				NOT NULL,
	[RoleId]			INT				NOT NULL,
	[Memo]				NVARCHAR(255),
	[CreatedAt]			DATETIMEOFFSET(7)	NOT NULL,
	[CreatedById]		INT				NOT NULL,
	[ModifiedAt]		DATETIMEOFFSET(7)	NOT NULL, 
	[ModifiedById]		INT				NOT NULL,

	CONSTRAINT [PK_RoleMemberships] PRIMARY KEY CLUSTERED ([TenantId] ASC, [Id] ASC),
);
GO
ALTER TABLE [dbo].[RoleMemberships] ADD CONSTRAINT [DF_RoleMemberships__TenantId]  DEFAULT (CONVERT(INT, SESSION_CONTEXT(N'TenantId'))) FOR [TenantId];
GO
ALTER TABLE [dbo].[RoleMemberships] ADD CONSTRAINT [DF_RoleMemberships__CreatedAt]  DEFAULT (SYSDATETIMEOFFSET()) FOR [CreatedAt];
GO
ALTER TABLE [dbo].[RoleMemberships] ADD CONSTRAINT [DF_RoleMemberships__CreatedById]  DEFAULT (CONVERT(INT,SESSION_CONTEXT(N'UserId'))) FOR [CreatedById]
GO
ALTER TABLE [dbo].[RoleMemberships] ADD CONSTRAINT [DF_RoleMemberships__ModifiedAt]  DEFAULT (SYSDATETIMEOFFSET()) FOR [ModifiedAt];
GO
ALTER TABLE [dbo].[RoleMemberships] ADD CONSTRAINT [DF_RoleMemberships__ModifiedById]  DEFAULT (CONVERT(INT,SESSION_CONTEXT(N'UserId'))) FOR [ModifiedById]
GO