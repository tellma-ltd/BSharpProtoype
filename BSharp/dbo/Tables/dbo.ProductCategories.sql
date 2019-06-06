CREATE TABLE [dbo].[ProductCategories] (
	[TenantId]					INT						DEFAULT (CONVERT(INT, SESSION_CONTEXT(N'TenantId'))),
	[Id]						INT						NOT NULL IDENTITY,
	[ParentId]					INT,
	[Name]						NVARCHAR (255)			NOT NULL,
	[Name2]						NVARCHAR (255),
	[Name3]						NVARCHAR (255),
	[Code]						NVARCHAR (255),
	-- Additional properties, IsAggregate ..
	-- Is Active
	[IsActive]					BIT						NOT NULL DEFAULT (1),
	-- Audit details
	[CreatedAt]					DATETIMEOFFSET(7)		NOT NULL DEFAULT (SYSDATETIMEOFFSET()),
	[CreatedById]				INT						NOT NULL DEFAULT (CONVERT(INT, SESSION_CONTEXT(N'UserId'))),
	[ModifiedAt]				DATETIMEOFFSET(7)		NOT NULL DEFAULT (SYSDATETIMEOFFSET()),
	[ModifiedById]				INT						NOT NULL DEFAULT (CONVERT(INT, SESSION_CONTEXT(N'UserId'))),
	-- Pure SQL properties and computed properties
	[Node]						HIERARCHYID				NOT NULL,
	[ParentNode]				AS [Node].GetAncestor(1),
	CONSTRAINT [PK_ProductCategories] PRIMARY KEY NONCLUSTERED([TenantId], [Id]),
	CONSTRAINT [FK_ProductCategories__ParentId] FOREIGN KEY ([TenantId], [ParentId]) REFERENCES [dbo].[ProductCategories] ([TenantId], [Id]),
	CONSTRAINT [FK_ProductCategories__CreatedById] FOREIGN KEY ([TenantId], [CreatedById]) REFERENCES [dbo].[LocalUsers] ([TenantId], [Id]),
	CONSTRAINT [FK_ProductCategories__ModifiedById] FOREIGN KEY ([TenantId], [ModifiedById]) REFERENCES [dbo].[LocalUsers] ([TenantId], [Id])
);
GO
CREATE UNIQUE INDEX [IX_ProductCategories__Code] ON [dbo].[ProductCategories]([TenantId], [Code]) WHERE [Code] IS NOT NULL;
GO
CREATE UNIQUE CLUSTERED INDEX [IX_ProductCategories__Node] ON [dbo].[ProductCategories]([TenantId], [Node]);
GO