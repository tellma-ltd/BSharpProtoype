CREATE TABLE [dbo].[Agents] (
	[TenantId]					INT,
	[Id]						INT					IDENTITY,
	[RelationType]				NVARCHAR (255)		NOT NULL, -- N'employee', N'supplier', N'customer', N'general'
	[IsActive]					BIT					NOT NULL DEFAULT (1),
	[Name]						NVARCHAR (255)		NOT NULL,
	[Name2]						NVARCHAR (255),
	[Code]						NVARCHAR (255),
	[SystemCode]				NVARCHAR (255), -- some used are anoymous-employee, anonymous-customer, anonymous-supplier, anonymous-general
--	Agents specific
	[PersonType]				NVARCHAR (255),  -- 'Individual', 'Organization' Organization includes Dept, Team
	[IsRelated]					BIT					NOT NULL DEFAULT (0),
	[TaxIdentificationNumber]	NVARCHAR (255),
	[IsLocal]					BIT,
	[Citizenship]				NCHAR(2),
	[Facebook]					NVARCHAR (255),				
	[Instagram]					NVARCHAR (255),				
	[Twitter]					NVARCHAR (255),
	[PreferredContactChannel1]	INT,			-- Mobile, Email, 
	[PreferredContactAddress1]	NVARCHAR(255),
	[PreferredContactChannel2]	INT,
	[PreferredContactAddress2]	NVARCHAR(255),
--	Individuals only	
	[BirthDateTime]				DATETIMEOFFSET (7),
	[MaritalStatus]				NCHAR (1),		-- S=Single, D=Divorced, M=Married, W=Widowed
	[Religion]					NCHAR (1),		-- I=Islam, C=Christianity, X=Others -- , J=Judaism, H=Hinduism, B=Buddhism
	[Race]						NCHAR (1),		-- W=White, B=Black, A=Asian, H=Hispanic
	[Gender]					NCHAR (1),		-- M=Male, F=Female
	[TribeId]					INT,
	[RegionId]					INT,
	[ResidentialAddress]		NVARCHAR (1024),
	[Title]						NVARCHAR (255), -- for individuals only
--	Organizations only
	[OrganizationType]			NVARCHAR (255), -- Bank/Insurance/Charity/NGO/TaxOrg/Diplomatic/General
	[WebSite]					NVARCHAR (255),
	[ContactPerson]				NVARCHAR (255),
	[RegisteredAddress]			NVARCHAR (1024), -- Physical or virtual, such as Bank account or URL.
	[OwnershipType]				NVARCHAR(255), -- Investment/Shareholder/SisterCompany/Other(Default) -- We Own shares in them, they own share in us, ...
	[OwnershipPercent]			DECIMAL	DEFAULT(0),
--	Employees Only
	[JobTitle]					NVARCHAR (255),
	[EmployeeSince]				DATETIMEOFFSET (7),				
/*	[BasicSalary]				MONEY,
	[TransporationAllowance]	MONEY,
	[OvertimeRate]				MONEY, */
	[EducationLevel]			NVARCHAR (255),					
	[EducationSublevel]			NVARCHAR (255),					
	[BankId]					INT,
	[BankAccountNumber]			NVARCHAR (255),					
	[NumberOfChildren]			TINYINT,
--	Suppliers Only
	[PaymentTerms]				NVARCHAR(255),
	[SupplierRating]			TINYINT,
--	Customers Only
	[ShippingAddress]			NVARCHAR(255),
	[BillingAddress]			NVARCHAR(255),
	[CustomerRating]			TINYINT,
	[CustomerSince]				DATETIMEOFFSET (7),			
	[CreditLine]				MONEY,

	[CreatedAt]					DATETIMEOFFSET(7)	NOT NULL,
	[CreatedById]				INT					NOT NULL,
	[ModifiedAt]				DATETIMEOFFSET(7)	NOT NULL, 
	[ModifiedById]				INT					NOT NULL,
	CONSTRAINT [PK_Agents] PRIMARY KEY CLUSTERED ([TenantId] ASC, [Id] ASC),
	CONSTRAINT [CK_Agents_RelationType] CHECK (
		[RelationType] IN (N'employee', N'supplier', N'customer', N'general')
		),
	CONSTRAINT [CK_Agents_AgentType] CHECK ([PersonType] IN (N'Individual', N'Organization')), -- Organization includes Dept, Team
	CONSTRAINT [FK_Agents_CreatedById] FOREIGN KEY ([TenantId], [CreatedById]) REFERENCES [dbo].[LocalUsers] ([TenantId], [Id]),
	CONSTRAINT [FK_Agents_ModifiedById] FOREIGN KEY ([TenantId], [ModifiedById]) REFERENCES [dbo].[LocalUsers] ([TenantId], [Id])
);
GO
CREATE INDEX [IX_Agents__RelationType]
  ON [dbo].[Agents]([TenantId] ASC, [RelationType] ASC);
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Agents__Name]
  ON [dbo].[Agents]([TenantId] ASC, [Name] ASC);
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Agents__Name2]
  ON [dbo].[Agents]([TenantId] ASC, [Name2] ASC) WHERE [Name2] IS NOT NULL;
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Agents__Code]
  ON [dbo].[Agents]([TenantId] ASC, [Code] ASC) WHERE [Code] IS NOT NULL;
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Agents__SystemCode]
  ON [dbo].[Agents]([TenantId] ASC, [Code] ASC) WHERE [SystemCode] IS NOT NULL;
 GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Agents__Id_AgentType]
  ON [dbo].[Agents]([Id] ASC, [PersonType] ASC) WHERE [PersonType] IS NOT NULL;
GO