CREATE TABLE [dbo].[IfrsNotes] (
	[TenantId]					INT,
	[Id]						NVARCHAR (255), -- Ifrs Concept
	[Node]						HIERARCHYID,
	[Level]						AS [Node].GetLevel(),
	[ParentNode]				AS [Node].GetAncestor(1),
	[IsAggregate]				BIT					NOT NULL DEFAULT (1),
--	If [ForDebit] = 1, Note can be used with Debit entries
	[ForDebit]					BIT					NOT NULL DEFAULT (1),
--	If [ForCredit] = 1, Note can be used with Credit entries
	[ForCredit]					BIT					NOT NULL DEFAULT (1),
	CONSTRAINT [PK_IfrsNotes] PRIMARY KEY NONCLUSTERED ([TenantId], [Id]),
	CONSTRAINT [CK_IfrsNotes__ForDebit_ForCredit] CHECK ([ForDebit] = 1 OR [ForCredit] = 1),
	CONSTRAINT [FK_IfrsNotes__IfrsConcepts]	FOREIGN KEY ([TenantId], [Id])	REFERENCES [dbo].[IfrsConcepts] ([TenantId], [Id]) ON DELETE CASCADE
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