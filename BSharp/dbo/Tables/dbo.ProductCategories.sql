CREATE TABLE [dbo].[ProductCategories] (
	[TenantId]					INT,
	[Id]						INT							NOT NULL IDENTITY,
	[ParentId]					INT,
	[Node]						HIERARCHYID					NOT NULL,
	[Level]						AS [Node].GetLevel()		PERSISTED,
	[ParentNode]				AS [Node].GetAncestor(1)	PERSISTED,
	[Name]						NVARCHAR (255)				NOT NULL,
	[Name2]						NVARCHAR (255),
	[Name3]						NVARCHAR (255),
	[Code]						NVARCHAR (255),
	-- Additional properties, IsAggregate ..
	-- Is Active
	[IsActive]					BIT							NOT NULL DEFAULT (1),
	-- Audit details
	[CreatedAt]					DATETIMEOFFSET(7)			NOT NULL,
	[CreatedById]				INT							NOT NULL,
	[ModifiedAt]				DATETIMEOFFSET(7)			NOT NULL, 
	[ModifiedById]				INT							NOT NULL,
	CONSTRAINT [PK_ProductCategories] PRIMARY KEY CLUSTERED ([TenantId], [Id]),
	CONSTRAINT [FK_ProductCategories__CreatedById] FOREIGN KEY ([TenantId], [CreatedById]) REFERENCES [dbo].[LocalUsers] ([TenantId], [Id]),
	CONSTRAINT [FK_ProductCategories__ModifiedById] FOREIGN KEY ([TenantId], [ModifiedById]) REFERENCES [dbo].[LocalUsers] ([TenantId], [Id])
);
GO
CREATE UNIQUE INDEX [IX_ProductCategories__Node] ON [dbo].[ProductCategories]([TenantId], [Node]);
GO
CREATE INDEX [IX_ProductCategories__Level_Node] ON [dbo].[ProductCategories]([TenantId], [Level], [Node]);
GO
CREATE UNIQUE INDEX [IX_ProductCategories__Code] ON [dbo].[ProductCategories]([TenantId], [Code]) WHERE [Code] IS NOT NULL;
GO
ALTER TABLE [dbo].[ProductCategories] ADD CONSTRAINT [DF_ProductCategories__TenantId]  DEFAULT (CONVERT(INT, SESSION_CONTEXT(N'TenantId'))) FOR [TenantId];
GO
ALTER TABLE [dbo].[ProductCategories] ADD CONSTRAINT [DF_ProductCategories__CreatedAt]  DEFAULT (SYSDATETIMEOFFSET()) FOR [CreatedAt];
GO
ALTER TABLE [dbo].[ProductCategories] ADD CONSTRAINT [DF_ProductCategories__CreatedById]  DEFAULT (CONVERT(INT, SESSION_CONTEXT(N'UserId'))) FOR [CreatedById]
GO
ALTER TABLE [dbo].[ProductCategories] ADD CONSTRAINT [DF_ProductCategories__ModifiedAt]  DEFAULT (SYSDATETIMEOFFSET()) FOR [ModifiedAt];
GO
ALTER TABLE [dbo].[ProductCategories] ADD CONSTRAINT [DF_ProductCategories__ModifiedById]  DEFAULT (CONVERT(INT, SESSION_CONTEXT(N'UserId'))) FOR [ModifiedById]
GO