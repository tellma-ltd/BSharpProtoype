CREATE TABLE [dbo].[Roles]  (
	[TenantId]			INT					DEFAULT CONVERT(INT, SESSION_CONTEXT(N'TenantId')),
	[Id]				INT					IDENTITY,
	[Name]				NVARCHAR (255)		NOT NULL,
	[Name2]				NVARCHAR (255),
	[Name3]				NVARCHAR (255),
	[IsPublic]			BIT					NOT NULL DEFAULT 0,		
	[IsActive]			BIT					NOT NULL DEFAULT 1,
	[Code]				NVARCHAR (255),
	[CreatedAt]			DATETIMEOFFSET(7)	NOT NULL DEFAULT SYSDATETIMEOFFSET(),
	[CreatedById]		INT					NOT NULL DEFAULT CONVERT(INT, SESSION_CONTEXT(N'UserId')),
	[ModifiedAt]		DATETIMEOFFSET(7)	NOT NULL DEFAULT SYSDATETIMEOFFSET(),
	[ModifiedById]		INT					NOT NULL DEFAULT CONVERT(INT, SESSION_CONTEXT(N'UserId')),

	CONSTRAINT [PK_Roles] PRIMARY KEY CLUSTERED ([TenantId] ASC, [Id] ASC),
	CONSTRAINT [FK_Roles__CreatedById] FOREIGN KEY ([TenantId], [CreatedById]) REFERENCES [dbo].[LocalUsers] ([TenantId], [Id]),
	CONSTRAINT [FK_Roles__ModifiedById] FOREIGN KEY ([TenantId], [ModifiedById]) REFERENCES [dbo].[LocalUsers] ([TenantId], [Id])
);
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Roles__Name]
  ON [dbo].[Roles]([TenantId], [Name]);
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Roles__Name2]
  ON [dbo].[Roles]([TenantId], [Name2]) WHERE [Name2] IS NOT NULL;
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Roles__Name3]
  ON [dbo].[Roles]([TenantId], [Name3]) WHERE [Name3] IS NOT NULL;
GO
CREATE UNIQUE INDEX [IX_Roles__Code]
  ON [dbo].[Roles]([TenantId], [Code]) WHERE [Code] IS NOT NULL;
GO