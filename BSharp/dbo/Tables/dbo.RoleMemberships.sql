CREATE TABLE [dbo].[RoleMemberships] (
	[TenantId]			INT				DEFAULT CONVERT(INT, SESSION_CONTEXT(N'TenantId')),
	[Id]				INT				IDENTITY,
	[Userid]			INT				NOT NULL,
	[RoleId]			INT				NOT NULL,
	[Memo]				NVARCHAR (255),
	[CreatedAt]			DATETIMEOFFSET(7)	NOT NULL DEFAULT SYSDATETIMEOFFSET(),
	[CreatedById]		INT					NOT NULL DEFAULT CONVERT(INT, SESSION_CONTEXT(N'UserId')),
	[ModifiedAt]		DATETIMEOFFSET(7)	NOT NULL DEFAULT SYSDATETIMEOFFSET(),
	[ModifiedById]		INT					NOT NULL DEFAULT CONVERT(INT, SESSION_CONTEXT(N'UserId')),
	CONSTRAINT [PK_RoleMemberships] PRIMARY KEY CLUSTERED ([TenantId], [Id]),
	CONSTRAINT [FK_RoleMemberships__UserId] FOREIGN KEY ([TenantId], [Userid]) REFERENCES [dbo].[LocalUsers] ([TenantId], [Id]),
	CONSTRAINT [FK_RoleMemberships__RoleId] FOREIGN KEY ([TenantId], [RoleId]) REFERENCES [dbo].[Roles] ([TenantId], [Id]),
	CONSTRAINT [FK_RoleMemberships__CreatedById] FOREIGN KEY ([TenantId], [CreatedById]) REFERENCES [dbo].[LocalUsers] ([TenantId], [Id]),
	CONSTRAINT [FK_RoleMemberships__ModifiedById] FOREIGN KEY ([TenantId], [ModifiedById]) REFERENCES [dbo].[LocalUsers] ([TenantId], [Id])
);
GO