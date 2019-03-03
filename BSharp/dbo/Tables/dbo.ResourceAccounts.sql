CREATE TABLE [dbo].[ResourceAccounts] (
	[TenantId]					INT,
	[Id]						INT					IDENTITY,
	[ResourceId]				INT					NOT NULL,
	[ResourceAccountType]		NVARCHAR (255)		NOT NULL,
	[IsActive]					BIT					NOT NULL DEFAULT (1),
	[Name]						NVARCHAR (255)		NOT NULL,
	[Name2]						NVARCHAR (255),
	[Code]						NVARCHAR (255),
--	[SystemCode]				NVARCHAR (255), -- some used are anoymous-employee, anonymous-customer, anonymous-supplier, anonymous-general

	[CreatedAt]					DATETIMEOFFSET(7)	NOT NULL,
	[CreatedById]				INT					NOT NULL,
	[ModifiedAt]				DATETIMEOFFSET(7)	NOT NULL, 
	[ModifiedById]				INT					NOT NULL,
	CONSTRAINT [PK_ResourceAccounts] PRIMARY KEY CLUSTERED ([TenantId] ASC, [Id] ASC),
	CONSTRAINT [CK_ResourceAccounts_ResourceAccountType] CHECK (
		[ResourceAccountType] IN (N'received-cheque', N'issued-cheque', N'inventory-batch', N'asset-component' )
	),
);
