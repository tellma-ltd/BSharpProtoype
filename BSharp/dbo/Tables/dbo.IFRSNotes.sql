CREATE TABLE [dbo].[IFRSNotes] (
	[TenantId]					INT,
	[Id]						NVARCHAR (255), -- IFRS Concept
	[Node]						HIERARCHYID,
	[Level]						AS [Node].GetLevel(),
	[ParentNode]				AS [Node].GetAncestor(1),
/*
	- Regulatory: Proposed by regulatory entity. We may have different flavors for different countries
	- Amendment: Added for consistency, must be amended in the iXBRL tool. Mainly for members vs non members issue
	- Extension: Added for business logic in B#. Is ignored by the iXBRL tool 
*/
	[IFRSType]					NVARCHAR (255)	DEFAULT (N'Regulatory') NOT NULL, -- N'Amendment', N'Extension', N'Regulatory'
	[IsAggregate]				BIT					NOT NULL DEFAULT (1),
	[IsActive]					BIT					NOT NULL DEFAULT (1),
	[Label]						NVARCHAR (1024)		NOT NULL,
	[Label2]					NVARCHAR (1024),
	[Documentation]				NVARCHAR (1024),
	[Documentation2]			NVARCHAR (1024),
	[EffectiveDate]				DATETIME2(7)		NOT NULL DEFAULT('0001-01-01 00:00:00'),
	[ExpiryDate]				DATETIME2(7)		NOT NULL DEFAULT('9999-12-31 23:59:59'),

	[CreatedAt]					DATETIMEOFFSET(7)	NOT NULL,
	[CreatedById]				INT					NOT NULL,
	[ModifiedAt]				DATETIMEOFFSET(7)	NOT NULL, 
	[ModifiedById]				INT					NOT NULL,

	CONSTRAINT [PK_IFRSNotes] PRIMARY KEY ([TenantId], [Id]),
	CONSTRAINT [CK_IFRSNotes_IFRSType] CHECK ([IFRSType] IN (N'Amendment', N'Extension', N'Regulatory')),
	CONSTRAINT [FK_IFRSNotes_CreatedById] FOREIGN KEY ([TenantId], [CreatedById]) REFERENCES [dbo].[LocalUsers] ([TenantId], [Id]),
	CONSTRAINT [FK_IFRSNotes_ModifiedById] FOREIGN KEY ([TenantId], [ModifiedById]) REFERENCES [dbo].[LocalUsers] ([TenantId], [Id])
	);
GO;
CREATE UNIQUE CLUSTERED INDEX IFRSNotes__Node
ON [dbo].[IFRSNotes]([TenantId], [Node]) ;  
GO;
CREATE UNIQUE INDEX IFRSNotes__Level_Node
ON [dbo].[IFRSNotes]([TenantId], [Level], [Node]) ;  
GO;