CREATE TABLE [dbo].[Custodies] (
	[TenantId]		INT,
	[Id]			INT					IDENTITY (1, 1),
	[CustodyType]	NVARCHAR (255)		NOT NULL,
	[Name]			NVARCHAR (255)		NOT NULL,
	[IsActive]		BIT					NOT NULL CONSTRAINT [DF_Custodies_IsActive] DEFAULT (1),
	[Code]			NVARCHAR (255),
	[Address]		NVARCHAR (1024),
	[BirthDateTime]	DATETIMEOFFSET (7),
	[CreatedAt]		DATETIMEOFFSET(7)	NOT NULL,
	[CreatedBy]		NVARCHAR(450)		NOT NULL,
	[ModifiedAt]	DATETIMEOFFSET(7)	NOT NULL, 
	[ModifiedBy]	NVARCHAR(450)		NOT NULL,
	CONSTRAINT [PK_Custodies] PRIMARY KEY CLUSTERED ([TenantId] ASC, [Id] ASC),
	CONSTRAINT [CK_Custodies_CustodyType] CHECK ([CustodyType] IN (N'Individual', N'Organization', N'Position', N'CashSafe', N'BankAccount', N'Warehouse', N'Farm', N'ProductionPoint', N'Misc')),
	CONSTRAINT [FK_Custodies_CreatedBy] FOREIGN KEY ([TenantId], [CreatedBy]) REFERENCES [dbo].[Users] ([TenantId], [Id]),
	CONSTRAINT [FK_Custodies_ModifiedBy] FOREIGN KEY ([TenantId], [ModifiedBy]) REFERENCES [dbo].[Users] ([TenantId], [Id])
);
GO
CREATE UNIQUE INDEX [IX_Custodies__Id_CustodyType]
  ON [dbo].[Custodies]([TenantId] ASC, [Id] ASC, [CustodyType] ASC);
GO
CREATE UNIQUE INDEX [IX_Custodies__Code]
  ON [dbo].[Custodies]([TenantId] ASC, [Code] ASC) WHERE [Code] IS NOT NULL;