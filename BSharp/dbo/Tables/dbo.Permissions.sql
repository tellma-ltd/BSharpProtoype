﻿CREATE TABLE [dbo].[Permissions] (
	[TenantId]		INT					DEFAULT CONVERT(INT, SESSION_CONTEXT(N'TenantId')),
	[Id]			INT					IDENTITY,
	[RoleId]		INT					NOT NULL,
	[ViewId]		NVARCHAR (255)		NOT NULL,
	[Level]			NVARCHAR (255)		NOT NULL,
	[Criteria]		NVARCHAR(1024), -- compiles into LINQ expression to filter the applicability
	[Memo]			NVARCHAR (255),
	[CreatedAt]		DATETIMEOFFSET(7)	NOT NULL DEFAULT SYSDATETIMEOFFSET(),
	[CreatedById]	INT					NOT NULL DEFAULT CONVERT(INT, SESSION_CONTEXT(N'UserId')),
	[ModifiedAt]	DATETIMEOFFSET(7)	NOT NULL DEFAULT SYSDATETIMEOFFSET(), 
	[ModifiedById]	INT					NOT NULL DEFAULT CONVERT(INT, SESSION_CONTEXT(N'UserId')),
	CONSTRAINT [PK_Permissions] PRIMARY KEY CLUSTERED ([TenantId] ASC, [Id] ASC),
	CONSTRAINT [CK_Permissions__Level] CHECK ([Level] IN (N'Read', N'Create', N'ReadCreate', N'Update')),--, N'Sign')),
	CONSTRAINT [FK_Permissions__Roles] FOREIGN KEY ([TenantId], [RoleId]) REFERENCES [dbo].[Roles] ([TenantId], [Id]) ON DELETE CASCADE,
	CONSTRAINT [FK_Permissions__Views] FOREIGN KEY ([TenantId], [ViewId]) REFERENCES [dbo].[Views] ([TenantId], [Id]) ON DELETE CASCADE,
	CONSTRAINT [FK_Permissions__CreatedById] FOREIGN KEY ([TenantId], [CreatedById]) REFERENCES [dbo].[LocalUsers] ([TenantId], [Id]),
	CONSTRAINT [FK_Permissions__ModifiedById] FOREIGN KEY ([TenantId], [ModifiedById]) REFERENCES [dbo].[LocalUsers] ([TenantId], [Id])
);
GO
CREATE INDEX [IX_Permissions__RoleId] ON [dbo].[Roles]([TenantId] ASC, [Id] ASC);
GO