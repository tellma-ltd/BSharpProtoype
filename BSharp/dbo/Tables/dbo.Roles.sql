CREATE TABLE [dbo].[Roles]  (
	[TenantId]					INT,
	[Id]						INT					IDENTITY (1, 1),
	[Name]						NVARCHAR (255)		NOT NULL,
	[Name2]						NVARCHAR (255),
	[IsPublic]					BIT					NOT NULL CONSTRAINT [DF_Roles_IsPublic] DEFAULT (0),		
	[IsActive]					BIT					NOT NULL CONSTRAINT [DF_Roles_IsActive] DEFAULT (1),
	[Code]						NVARCHAR (255),
	[CreatedAt]					DATETIMEOFFSET(7)	NOT NULL,
	[CreatedBy]					NVARCHAR(450)		NOT NULL,
	[ModifiedAt]				DATETIMEOFFSET(7)	NOT NULL, 
	[ModifiedBy]				NVARCHAR(450)		NOT NULL,
	CONSTRAINT [PK_Roles] PRIMARY KEY CLUSTERED ([TenantId] ASC, [Id] ASC),
	CONSTRAINT [FK_Roles_CreatedBy] FOREIGN KEY ([TenantId], [CreatedBy]) REFERENCES [dbo].[Users] ([TenantId], [Id]),
	CONSTRAINT [FK_Roles_ModifiedBy] FOREIGN KEY ([TenantId], [ModifiedBy]) REFERENCES [dbo].[Users] ([TenantId], [Id])
);
GO
CREATE UNIQUE INDEX [IX_Roles__Code]
  ON [dbo].[Roles]([TenantId] ASC, [Code] ASC) WHERE [Code] IS NOT NULL;
GO