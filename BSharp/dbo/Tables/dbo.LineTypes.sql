CREATE TABLE [dbo].[LineTypes] (
	[TenantId]					INT							DEFAULT CONVERT(INT, SESSION_CONTEXT(N'TenantId')),
	[Id]						NVARCHAR (255) NOT NULL,
	[DocumentCategory]			NVARCHAR (255) NOT NULL,
	[Description]				NVARCHAR (255),
	[Description2]				NVARCHAR (255),
	[Description3]				NVARCHAR (255),
	[CustomerLabel]				NVARCHAR (255),
	[SupplierLabel]				NVARCHAR (255),
	[EmployeeLabel]				NVARCHAR (255),
	[FromCustodyAccountLabel]	NVARCHAR (255),
	[ToCustodyAccountLabel]		NVARCHAR (255),

	CONSTRAINT [PK_LineTypes] PRIMARY KEY CLUSTERED ([TenantId] ASC, [Id] ASC),
	CONSTRAINT [CK_LineTypes__DocumentCategory] CHECK (
		[DocumentCategory] IN (N'Transaction', N'Request', N'Plan', N'Template')
	)
);