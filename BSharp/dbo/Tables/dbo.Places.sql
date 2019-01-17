CREATE TABLE [dbo].[Places] (-- غير المكلف
	[TenantId]		INT,
	[Id]			INT	,
	[PlaceType]	NVARCHAR (255) NOT NULL,
	[CustodianId]	INT, -- Accountable Id
	CONSTRAINT [PK_Places] PRIMARY KEY CLUSTERED ([TenantId] ASC, [Id] ASC),
	CONSTRAINT [FK_Places_Agents] FOREIGN KEY ([TenantId], [CustodianId]) REFERENCES [dbo].[Agents] ([TenantId], [Id]),
	CONSTRAINT [FK_Places_Custodies] FOREIGN KEY ([TenantId], [Id], [PlaceType]) REFERENCES [dbo].[Custodies] ([TenantId], [Id], [CustodyType]) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT [CK_Places_PlaceType] CHECK ([PlaceType] IN (N'CashSafe', N'BankAccount', N'Warehouse', N'Farm', N'ProductionPoint', N'Misc'))
);
GO
CREATE INDEX [IX_Places__CustodianId] ON [dbo].[Places]([TenantId] ASC, [CustodianId] ASC);
GO
