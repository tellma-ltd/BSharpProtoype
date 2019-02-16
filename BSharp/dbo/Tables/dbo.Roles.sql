CREATE TABLE [dbo].[Roles]  (
	[TenantId]					INT,
	[Id]						INT					IDENTITY,
	[Name]						NVARCHAR (255)		NOT NULL,
	[Name2]						NVARCHAR (255),
	[IsPublic]					BIT					NOT NULL CONSTRAINT [DF_Roles_IsPublic] DEFAULT (0),		
	[IsActive]					BIT					NOT NULL CONSTRAINT [DF_Roles_IsActive] DEFAULT (1),
	[Code]						NVARCHAR (255),
	[CreatedAt]					DATETIMEOFFSET(7)	NOT NULL,
	[CreatedById]				INT		NOT NULL,
	[ModifiedAt]				DATETIMEOFFSET(7)	NOT NULL, 
	[ModifiedById]				INT		NOT NULL,
	CONSTRAINT [PK_Roles] PRIMARY KEY CLUSTERED ([TenantId] ASC, [Id] ASC),
	CONSTRAINT [FK_Roles_CreatedById] FOREIGN KEY ([TenantId], [CreatedById]) REFERENCES [dbo].[LocalUsers] ([TenantId], [Id]),
	CONSTRAINT [FK_Roles_ModifiedById] FOREIGN KEY ([TenantId], [ModifiedById]) REFERENCES [dbo].[LocalUsers] ([TenantId], [Id])
);
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Roles__Name]
  ON [dbo].[Roles]([TenantId] ASC, [Name] ASC);
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Roles__Name2]
  ON [dbo].[Roles]([TenantId] ASC, [Name2] ASC) WHERE [Name2] IS NOT NULL;
GO
CREATE UNIQUE INDEX [IX_Roles__Code]
  ON [dbo].[Roles]([TenantId] ASC, [Code] ASC) WHERE [Code] IS NOT NULL;
GO