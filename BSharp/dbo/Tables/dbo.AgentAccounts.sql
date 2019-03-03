CREATE TABLE [dbo].[AgentAccounts] (
	[TenantId]					INT,
	[Id]						INT					IDENTITY,
	[AgentId]					INT					NOT NULL,
	-- for every customer, supplier, and employee account types: sales, purchase and employment
	[AgentAccountType]			NVARCHAR (255)		NOT NULL,
	[IsActive]					BIT					NOT NULL DEFAULT (1),
	[Name]						NVARCHAR (255)		NOT NULL,
	[Name2]						NVARCHAR (255),
	[Code]						NVARCHAR (255),
	[Reference]					NVARCHAR (255),
--	[SystemCode]				NVARCHAR (255), -- some used are anoymous-employee, anonymous-customer, anonymous-supplier, anonymous-general

	[CreatedAt]					DATETIMEOFFSET(7)	NOT NULL,
	[CreatedById]				INT					NOT NULL,
	[ModifiedAt]				DATETIMEOFFSET(7)	NOT NULL, 
	[ModifiedById]				INT					NOT NULL,
	CONSTRAINT [PK_AgentAccounts] PRIMARY KEY CLUSTERED ([TenantId] ASC, [Id] ASC),
	CONSTRAINT [CK_AgentAccounts_AgentAccountType] CHECK (
		[AgentAccountType] IN (N'cash-on-hand', N'balances-with-bank', N'sales', N'purchase', N'employment', N'loan', N'borrowing', N'storage-location' )
	),
);
