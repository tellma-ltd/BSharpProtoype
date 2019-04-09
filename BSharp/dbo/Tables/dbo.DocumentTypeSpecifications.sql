CREATE TABLE [dbo].[DocumentTypeSpecifications] ( -- table managed by Banan, no UI for it in B11
	[TenantId]		INT,
	[Id]			NVARCHAR (255),
	[Description]	NVARCHAR (255),
	[Description2]	NVARCHAR (255),
	[Description3]	NVARCHAR (255),
	CONSTRAINT [PK_DocumentTypeSpecifications] PRIMARY KEY CLUSTERED ([TenantId], [Id])
);