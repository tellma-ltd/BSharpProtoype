CREATE TABLE [dbo].[Agents] (
	[TenantId]					INT,
	[Id]						INT					IDENTITY,
--	[RelationType]				NVARCHAR (255)		NOT NULL, -- N'employee', N'supplier', N'customer', N'general'
	[IsActive]					BIT					NOT NULL DEFAULT (1),
	[Name]						NVARCHAR (255)		NOT NULL,
	[Name2]						NVARCHAR (255),
	[Code]						NVARCHAR (255),
	[SystemCode]				NVARCHAR (255), -- some used are anoymous, self, parent
--	Agents specific
	[PersonType]				NVARCHAR (255),  -- 'Individual', 'Organization' Organization includes Dept, Team
	[IsRelated]					BIT					NOT NULL DEFAULT (0),
	[TaxIdentificationNumber]	NVARCHAR (255),
	[IsLocal]					BIT,
	[Citizenship]				NCHAR(2),
	[Facebook]					NVARCHAR (255),				
	[Instagram]					NVARCHAR (255),				
	[Twitter]					NVARCHAR (255),
	[PreferredContactChannel1]	INT,			-- e.g., Mobile
	[PreferredContactAddress1]	NVARCHAR(255),  -- e.g., +251 94 123 4567
	[PreferredContactChannel2]	INT,			-- e.g., email
	[PreferredContactAddress2]	NVARCHAR(255),	-- e.g., info@contoso.com
--	Individuals only
--	--	Personal
	[BirthDateTime]				DATETIME2 (7),
	[Title]						NVARCHAR (255),
	[Gender]					NCHAR (1),		-- M=Male, F=Female
	[ResidentialAddress]		NVARCHAR (1024),
	[ImageId]					UNIQUEIDENTIFIER,
--	--	Social
	[MaritalStatus]				NCHAR (1),		-- S=Single, D=Divorced, M=Married, W=Widowed
	[NumberOfChildren]			TINYINT,
	[Religion]					NCHAR (1),		-- I=Islam, C=Christianity, X=Others -- , J=Judaism, H=Hinduism, B=Buddhism
	[Race]						NCHAR (1),		-- W=White, B=Black, A=Asian, H=Hispanic
	[TribeId]					INT,
	[RegionId]					INT,
--	--	Academic
	[EducationLevel]			NVARCHAR (255),					
	[EducationSublevel]			NVARCHAR (255),	
--	--	Financial
	[BankId]					INT,
	[BankAccountNumber]			NVARCHAR (255),					
--	Organizations only
--	Organization type is defined by the government entity responsible for this organization. For instance, banks
--	are all handled by the central bank. Charities are handled by a different body, and so on.
	[OrganizationType]			NVARCHAR (255), -- General/Bank/Insurance/Charity/NGO/TaxOrg/Diplomatic
	[WebSite]					NVARCHAR (255),
	[ContactPerson]				NVARCHAR (255),
	[RegisteredAddress]			NVARCHAR (1024),
	[OwnershipType]				NVARCHAR (255), -- Investment/Shareholder/SisterCompany/Other(Default) -- We Own shares in them, they own share in us, ...
	[OwnershipPercent]			DECIMAL	DEFAULT(0), -- If investment, how much the entity owns in this agent. If shareholder, how much he owns in the entity

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