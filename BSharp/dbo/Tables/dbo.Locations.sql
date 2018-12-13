CREATE TABLE [dbo].[Locations] (-- غير العاقل
	[TenantId]		INT,
	[Id]			INT	,
	[LocationType]	NVARCHAR (255) NOT NULL,
	[CustodianId]	INT, -- Accountable Id
	CONSTRAINT [PK_Locations] PRIMARY KEY CLUSTERED ([TenantId] ASC, [Id] ASC),
	CONSTRAINT [FK_Locations_Agents] FOREIGN KEY ([TenantId], [CustodianId]) REFERENCES [dbo].[Agents] ([TenantId], [Id]),
	CONSTRAINT [FK_Locations_Custodies] FOREIGN KEY ([TenantId], [Id], [LocationType]) REFERENCES [dbo].[Custodies] ([TenantId], [Id], [CustodyType]) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT [CK_Locations_LocationType] CHECK ([LocationType] IN (N'CashSafe', N'BankAccount', N'Warehouse', N'Farm', N'ProductionPoint', N'Misc'))
);

