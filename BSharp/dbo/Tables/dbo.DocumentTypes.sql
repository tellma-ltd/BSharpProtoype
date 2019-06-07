CREATE TABLE [dbo].[DocumentTypes] (
-- table managed by Banan, except for the BIT column
	[TenantId]					INT				DEFAULT CONVERT(INT, SESSION_CONTEXT(N'TenantId')),
	[Id]						NVARCHAR (255),
	[DocumentCategory]			NVARCHAR (255),
-- if it is not the main source document, then the VoucherReference field will become visible
-- for the user to enter the reference from the supporting source document.
	[IsMainSourceDocument]		BIT				DEFAULT 0,
	[Description]				NVARCHAR (255),
	[Description2]				NVARCHAR (255),
	[Description3]				NVARCHAR (255),
	CONSTRAINT [PK_DocumentTypeSpecifications] PRIMARY KEY CLUSTERED ([TenantId], [Id]),
	CONSTRAINT [CK_DocumentTypeSpecifications__DocumentCategory] CHECK ([DocumentCategory] IN (N'Transaction', N'Request', N'Plan', N'Template')),
);