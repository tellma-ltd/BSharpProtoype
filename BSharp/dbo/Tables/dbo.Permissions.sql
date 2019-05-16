CREATE TABLE [dbo].[Permissions] (
	[TenantId]		INT,
	[Id]			INT					IDENTITY(1,1),
	[RoleId]		INT					NOT NULL,
	[ViewId]		NVARCHAR(255)		NOT NULL,
	[Level]			NVARCHAR(255)		NOT NULL,
	[Criteria]		NVARCHAR(1024), -- compiles into LINQ expression to filter the applicability
	[Memo]			NVARCHAR(255),
	[CreatedAt]		DATETIMEOFFSET(7)	NOT NULL,
	[CreatedById]	INT		NOT NULL,
	[ModifiedAt]	DATETIMEOFFSET(7)	NOT NULL, 
	[ModifiedById]	INT		NOT NULL,
	CONSTRAINT [PK_Permissions] PRIMARY KEY CLUSTERED ([TenantId] ASC, [Id] ASC),
	CONSTRAINT [CK_Permissions_Level] CHECK ([Level] IN (N'Read', N'Create', N'ReadCreate', N'Update', N'Sign')),
	CONSTRAINT [FK_Permissions_Roles] FOREIGN KEY ([TenantId], [RoleId]) REFERENCES [dbo].[Roles] ([TenantId], [Id]) ON DELETE CASCADE,
	CONSTRAINT [FK_Permissions_CreatedById] FOREIGN KEY ([TenantId], [CreatedById]) REFERENCES [dbo].[LocalUsers] ([TenantId], [Id]),
	CONSTRAINT [FK_Permissions_ModifiedById] FOREIGN KEY ([TenantId], [ModifiedById]) REFERENCES [dbo].[LocalUsers] ([TenantId], [Id])
);
GO
CREATE INDEX [IX_Permissions__RoleId] ON [dbo].[Roles]([TenantId] ASC, [Id] ASC);
GO
ALTER TABLE [dbo].[Permissions] ADD CONSTRAINT [DF_Permissions__TenantId]  DEFAULT (CONVERT(INT, SESSION_CONTEXT(N'TenantId'))) FOR [TenantId];
GO
ALTER TABLE [dbo].[Permissions] ADD CONSTRAINT [DF_Permissions__CreatedAt]  DEFAULT (SYSDATETIMEOFFSET()) FOR [CreatedAt];
GO
ALTER TABLE [dbo].[Permissions] ADD CONSTRAINT [DF_Permissions__CreatedById]  DEFAULT (CONVERT(INT, SESSION_CONTEXT(N'UserId'))) FOR [CreatedById]
GO
ALTER TABLE [dbo].[Permissions] ADD CONSTRAINT [DF_Permissions__ModifiedAt]  DEFAULT (SYSDATETIMEOFFSET()) FOR [ModifiedAt];
GO
ALTER TABLE [dbo].[Permissions] ADD CONSTRAINT [DF_Permissions__ModifiedById]  DEFAULT (CONVERT(INT, SESSION_CONTEXT(N'UserId'))) FOR [ModifiedById]
GO