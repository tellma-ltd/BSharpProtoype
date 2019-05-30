CREATE TABLE [dbo].[IfrsAccounts] (
	[TenantId]					INT,
	[Id]						NVARCHAR (255), -- Ifrs Concept
	[Node]						HIERARCHYID,
	[Level]						AS [Node].GetLevel(),
	[ParentNode]				AS [Node].GetAncestor(1),
/*
	- Regulatory: Proposed by regulatory entity. We may have different flavors for different countries
	- Amendment: Added for consistency, must be amended in the iXBRL tool. Mainly for members vs non members issue
	- Extension: Added for business logic in B#. Is ignored by the iXBRL tool 
*/
	--[IfrsType]					NVARCHAR (255)	DEFAULT (N'Regulatory') NOT NULL, -- N'Amendment', N'Extension', N'Regulatory'
	-- Aggregate means, it does not take direct entries, but rather used for aggregation only
	-- IsAggergate = True If and only if isLeaf = False. We used IsAggregate instead since
	-- a leaf is used in computer science to mean a node with no children. So, as we build the tree
	-- leaves are converted into internal nodes. Hence it is a computed property, unlike IsAggregate
	[IsAggregate]				BIT					NOT NULL DEFAULT (1),
	--[IsActive]					BIT					NOT NULL DEFAULT (1),
	--[Label]						NVARCHAR (1024)		NOT NULL,
	--[Label2]					NVARCHAR (1024),
	--[Label3]					NVARCHAR (1024),
	--[Documentation]				NVARCHAR (1024),
	--[Documentation2]			NVARCHAR (1024),
	--[Documentation3]			NVARCHAR (1024),
	--[EffectiveDate]				DATETIME2(7)		NOT NULL DEFAULT('0001-01-01 00:00:00'),
	--[ExpiryDate]				DATETIME2(7)		NOT NULL DEFAULT('9999-12-31 23:59:59'),

--	The settings below apply to the Account with this Ifrs, as well to the JE.LI endowed with this Ifrs
	[IfrsNoteSetting]			NVARCHAR (255)		NOT NULL DEFAULT('N/A'), -- N/A, Optional, Required

	[AgentAccountSetting]		NVARCHAR (255)		NOT NULL DEFAULT('N/A'), -- N/A, Optional, Required
	[AgentRelationTypeList]		NVARCHAR (1024),	-- e.g., OtherCurrentReceivables applies to ALL except supplier & customer
--	[AgentAccountFilter]		NVARCHAR (1024),	
	[AgentAccountLabel]			NVARCHAR (255),
	[AgentAccountLabel2]		NVARCHAR (255),
	[AgentAccountLabel3]		NVARCHAR (255),

	[ResourceSetting]			NVARCHAR (255)		NOT NULL DEFAULT('N/A'), -- N/A, Optional, Required
	[ResourceTypeList]			NVARCHAR (1024),	
--	[ResourceFilter]			NVARCHAR (1024),
	[ResourceLabel]				NVARCHAR (255),
	[ResourceLabel2]			NVARCHAR (255),
	[ResourceLabel3]			NVARCHAR (255),

	[DebitReferenceSetting]		NVARCHAR (255)		NOT NULL DEFAULT('N/A'), -- N/A, Optional, Required
	[DebitReferenceLabel]		NVARCHAR (255),
	[DebitReferenceLabel2]		NVARCHAR (255),
	[DebitReferenceLabel3]		NVARCHAR (255),

	[CreditReferenceSetting]	NVARCHAR (255)		NOT NULL DEFAULT('N/A'), -- N/A, Optional, Required
	[CreditReferenceLabel]		NVARCHAR (255),
	[CreditReferenceLabel2]		NVARCHAR (255),
	[CreditReferenceLabel3]		NVARCHAR (255),

	[DebitRelatedReferenceSetting]		NVARCHAR (255)		NOT NULL DEFAULT('N/A'), -- N/A, Optional, Required
	[DebitRelatedReferenceLabel]		NVARCHAR (255),
	[DebitRelatedReferenceLabel2]		NVARCHAR (255),
	[DebitRelatedReferenceLabel3]		NVARCHAR (255),

	[CreditRelatedReferenceSetting]	NVARCHAR (255)		NOT NULL DEFAULT('N/A'), -- N/A, Optional, Required
	[CreditRelatedReferenceLabel]		NVARCHAR (255),
	[CreditRelatedReferenceLabel2]		NVARCHAR (255),
	[CreditRelatedReferenceLabel3]		NVARCHAR (255),

	[RelatedResourceSetting]	NVARCHAR (255)		NOT NULL DEFAULT('N/A'), -- N/A, Optional, Required
	[RelatedResourceTypeList]	NVARCHAR (1024),	
--	[RelatedResourceFilter]		NVARCHAR (1024),
	[RelatedResourceLabel]		NVARCHAR (255),
	[RelatedResourceLabel2]		NVARCHAR (255),
	[RelatedResourceLabel3]		NVARCHAR (255),
	
	[RelatedAgentAccountSetting]NVARCHAR (255)		NOT NULL DEFAULT('N/A'), -- N/A, Optional, Required
--	[RelatedAgentAccountFilter]	NVARCHAR (1024),
	[RelatedAgentRelationTypeList]NVARCHAR (1024),
	[RelatedAgentAccountLabel]	NVARCHAR (255),
	[RelatedAgentAccountLabel2]	NVARCHAR (255),
	[RelatedAgentAccountLabel3]	NVARCHAR (255),

	[CreatedAt]					DATETIMEOFFSET(7)	NOT NULL,
	[CreatedById]				INT					NOT NULL,
	[ModifiedAt]				DATETIMEOFFSET(7)	NOT NULL, 
	[ModifiedById]				INT					NOT NULL,

	CONSTRAINT [PK_IfrsAccounts] PRIMARY KEY NONCLUSTERED ([TenantId] ASC, [Id]),
	--CONSTRAINT [CK_IfrsAccounts__IfrsType] CHECK ([IfrsType] IN (N'Amendment', N'Extension', N'Regulatory')),
	CONSTRAINT [FK_IfrsAccounts__CreatedById] FOREIGN KEY ([TenantId], [CreatedById]) REFERENCES [dbo].[LocalUsers] ([TenantId], [Id]),
	CONSTRAINT [FK_IfrsAccounts__ModifiedById] FOREIGN KEY ([TenantId], [ModifiedById]) REFERENCES [dbo].[LocalUsers] ([TenantId], [Id])
	);
GO
CREATE UNIQUE CLUSTERED INDEX IfrsAccounts__Node
ON [dbo].[IfrsAccounts]([TenantId], [Node]) ;  
GO
CREATE UNIQUE INDEX IfrsAccounts__Level_FNode
ON [dbo].[IfrsAccounts]([TenantId], [Level], [Node]) ;  
GO
ALTER TABLE [dbo].[IfrsAccounts] ADD CONSTRAINT [DF_IfrsAccounts__TenantId]  DEFAULT (CONVERT(INT, SESSION_CONTEXT(N'TenantId'))) FOR [TenantId];
GO
ALTER TABLE [dbo].[IfrsAccounts] ADD CONSTRAINT [DF_IfrsAccounts__CreatedAt]  DEFAULT (SYSDATETIMEOFFSET()) FOR [CreatedAt];
GO
ALTER TABLE [dbo].[IfrsAccounts] ADD CONSTRAINT [DF_IfrsAccounts__CreatedById]  DEFAULT (CONVERT(INT, SESSION_CONTEXT(N'UserId'))) FOR [CreatedById]
GO
ALTER TABLE [dbo].[IfrsAccounts] ADD CONSTRAINT [DF_IfrsAccounts__ModifiedAt]  DEFAULT (SYSDATETIMEOFFSET()) FOR [ModifiedAt];
GO
ALTER TABLE [dbo].[IfrsAccounts] ADD CONSTRAINT [DF_IfrsAccounts__ModifiedById]  DEFAULT (CONVERT(INT, SESSION_CONTEXT(N'UserId'))) FOR [ModifiedById]
GO