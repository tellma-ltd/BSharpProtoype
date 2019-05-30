CREATE TABLE [dbo].[IfrsNotes] (
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
	[IsAggregate]				BIT					NOT NULL DEFAULT (1),
	--[IsActive]					BIT					NOT NULL DEFAULT (1),
	--[Label]						NVARCHAR (1024)		NOT NULL,
	--[Label2]					NVARCHAR (1024),
	--[Label3]					NVARCHAR (1024),
	--[Documentation]				NVARCHAR (1024),
	--[Documentation2]			NVARCHAR (1024),
	--[Documentation3]			NVARCHAR (1024),
--	If [ForDebit] = 1, Note can be used with Debit entries
	[ForDebit]					BIT					NOT NULL DEFAULT (1),
--	If [ForCredit] = 1, Note can be used with Credit entries
	[ForCredit]					BIT					NOT NULL DEFAULT (1),
-- Concept lifetime according to regulatry body
	[CreatedAt]					DATETIMEOFFSET(7)	NOT NULL,
	[CreatedById]				INT					NOT NULL,
	[ModifiedAt]				DATETIMEOFFSET(7)	NOT NULL,
	[ModifiedById]				INT					NOT NULL,

	CONSTRAINT [PK_IfrsNotes] PRIMARY KEY NONCLUSTERED ([TenantId], [Id]),
	--CONSTRAINT [CK_IfrsNotes__IfrsType] CHECK ([IfrsType] IN (N'Amendment', N'Extension', N'Regulatory')),
	CONSTRAINT [CK_IfrsNotes__ForDebit_ForCredit] CHECK ([ForDebit] = 1 OR [ForCredit] = 1),

	CONSTRAINT [FK_IfrsNotes__CreatedById] FOREIGN KEY ([TenantId], [CreatedById]) REFERENCES [dbo].[LocalUsers] ([TenantId], [Id]),
	CONSTRAINT [FK_IfrsNotes__ModifiedById] FOREIGN KEY ([TenantId], [ModifiedById]) REFERENCES [dbo].[LocalUsers] ([TenantId], [Id])
	);
GO
CREATE UNIQUE CLUSTERED INDEX IfrsNotes__Node
ON [dbo].[IfrsNotes]([TenantId], [Node]) ;  
GO
CREATE UNIQUE INDEX IfrsNotes__Level_Node
ON [dbo].[IfrsNotes]([TenantId], [Level], [Node]) ;  
GO
ALTER TABLE [dbo].[IfrsNotes] ADD CONSTRAINT [DF_IfrsNotes__TenantId]  DEFAULT (CONVERT(INT, SESSION_CONTEXT(N'TenantId'))) FOR [TenantId];
GO
ALTER TABLE [dbo].[IfrsNotes] ADD CONSTRAINT [DF_IfrsNotes__CreatedAt]  DEFAULT (SYSDATETIMEOFFSET()) FOR [CreatedAt];
GO
ALTER TABLE [dbo].[IfrsNotes] ADD CONSTRAINT [DF_IfrsNotes__CreatedById]  DEFAULT (CONVERT(INT, SESSION_CONTEXT(N'UserId'))) FOR [CreatedById]
GO
ALTER TABLE [dbo].[IfrsNotes] ADD CONSTRAINT [DF_IfrsNotes__ModifiedAt]  DEFAULT (SYSDATETIMEOFFSET()) FOR [ModifiedAt];
GO
ALTER TABLE [dbo].[IfrsNotes] ADD CONSTRAINT [DF_IfrsNotes__ModifiedById]  DEFAULT (CONVERT(INT, SESSION_CONTEXT(N'UserId'))) FOR [ModifiedById]
GO