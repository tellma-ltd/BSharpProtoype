CREATE TABLE [dbo].[Custodies] (
	[TenantId]		INT,
    [Id]            INT				IDENTITY (1, 1),
    [CustodyType]   NVARCHAR (255)	NOT NULL,
    [Name]			NVARCHAR (255)	NOT NULL,
    [IsActive]		BIT				NOT NULL CONSTRAINT [DF_Custodies_IsActive] DEFAULT (1),
	[Code]			NVARCHAR (255),
	[Address]			NVARCHAR (255),
    [BirthDateTime]				DATETIMEOFFSET (7),
    [CreatedAt]		DATETIMEOFFSET(7), 
    [CreatedBy]		NVARCHAR(450), 
    [ModifiedAt]	DATETIMEOFFSET(7), 
    [ModifiedBy]	NVARCHAR(450), 
    CONSTRAINT [PK_Custodies] PRIMARY KEY CLUSTERED ([TenantId] ASC, [Id] ASC),
	CONSTRAINT [CK_Custodies_CustodyType] CHECK ([CustodyType] IN (N'Individual', N'Organization', N'OrganizationUnit', N'CashSafe', N'BankAccount', N'Warehouse', N'Farm', N'ProductionPoint', N'Misc'))
);
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Custodies__Id_CustodyType]
    ON [dbo].[Custodies]([TenantId] ASC, [Id] ASC, [CustodyType] ASC);
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Custodies__Code]
    ON [dbo].[Custodies]([TenantId] ASC, [Code] ASC) WHERE [Code] IS NOT NULL;


