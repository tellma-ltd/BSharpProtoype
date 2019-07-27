CREATE TABLE [dbo].[VoucherTypes](
-- table managed by Banan, except for the VoucherPrefix and  column
-- Note that, in steel production: CTS, HSP, and SM are considered 3 different document types.
	[TenantId]					INT				DEFAULT CONVERT(INT, SESSION_CONTEXT(N'TenantId')),
	[Id]						NVARCHAR (255),
	[Description]				NVARCHAR (255)	NOT NULL,
	[Description2]				NVARCHAR (255),
	[Description3]				NVARCHAR (255),
	[CustomerLabel]				NVARCHAR (255),
	[SupplierLabel]				NVARCHAR (255),
	[EmployeeLabel]				NVARCHAR (255),
	[FromCustodyAccountLabel]	NVARCHAR (255),
	[ToCustodyAccountLabel]		NVARCHAR (255),
	CONSTRAINT [PK_VoucherTypes] PRIMARY KEY CLUSTERED ([TenantId], [Id])
);
GO;