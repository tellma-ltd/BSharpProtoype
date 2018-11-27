CREATE TABLE [dbo].[Custodies] (
	[TenantId]		INT,
    [Id]            INT				IDENTITY (1, 1),
    [CustodyType]   NVARCHAR (50)	NOT NULL,
    [Name]			NVARCHAR (50)	NOT NULL,
    [IsActive]		BIT				NOT NULL DEFAULT 1,
    CONSTRAINT [PK_Custodies] PRIMARY KEY CLUSTERED ([TenantId] ASC, [Id] ASC),
	CONSTRAINT [CK_Custodies_CustodyType] CHECK ([CustodyType] IN (N'Individual', N'Organization', N'OrganizationUnit', N'CashSafe', N'BankAccount', N'Warehouse', N'Farm', N'ProductionPoint', N'Address'))
);
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Custodies__Id_CustodyType]
    ON [dbo].[Custodies]([TenantId] ASC, [Id] ASC, [CustodyType] ASC);

