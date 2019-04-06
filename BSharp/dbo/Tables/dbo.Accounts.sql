CREATE TABLE [dbo].[Accounts] (
	[TenantId]					INT,
	[Id]						INT					NOT NULL IDENTITY,
	[Node]						HIERARCHYID,
	[Level]						AS [Node].GetLevel(),
	[ParentNode]				AS [Node].GetAncestor(1),
	-- IFRSAccountId becomes immutable once account appears in a (draft/posted) document
	[IFRSAccountId]				NVARCHAR (255)		NOT NULL, -- IFRS Concept
	[IsAggregate]				BIT					NOT NULL,
	[IsActive]					BIT					NOT NULL DEFAULT (1),
	[Name]						NVARCHAR (255)		NOT NULL,
	[Name2]						NVARCHAR (255),
	[Code]						NVARCHAR (255),

	-- For the following columns, see the corresponding columns in table Entries for documentation
	-- They can be set to a new value provided it does not conflict with a (draft/posted) document
	[IFRSNoteId]				NVARCHAR (255),		-- includes Expense by function
	[ResponsibilityCenterId]	INT,
	[AgentAccountId]			INT,
	[ResourceId]				INT,
	[ExpectedSettlingDate]		DATETIME2(7),
	[RelatedResourceId]			INT,
	[RelatedAgentAccountId]		INT,
	-- Audit details
	[CreatedAt]					DATETIMEOFFSET(7)	NOT NULL,
	[CreatedById]				INT					NOT NULL,
	[ModifiedAt]				DATETIMEOFFSET(7)	NOT NULL, 
	[ModifiedById]				INT					NOT NULL,
	CONSTRAINT [PK_Accounts] PRIMARY KEY CLUSTERED ([TenantId] ASC, [Id] ASC),
	CONSTRAINT [FK_Accounts__IFRSAccountId] FOREIGN KEY ([TenantId], [IFRSAccountId]) REFERENCES [dbo].[IFRSAccounts] ([TenantId], [Id]),
	CONSTRAINT [FK_Accounts__IFRSNoteId] FOREIGN KEY ([TenantId], [IFRSNoteId]) REFERENCES [dbo].[IFRSNotes] ([TenantId], [Id]),
	CONSTRAINT [FK_Accounts__ResponsibilityCenterId] FOREIGN KEY ([TenantId], [ResponsibilityCenterId]) REFERENCES [dbo].[ResponsibilityCenters] ([TenantId], [Id]),
	CONSTRAINT [FK_Accounts__AgentAccountId] FOREIGN KEY ([TenantId], [AgentAccountId]) REFERENCES [dbo].[AgentAccounts] ([TenantId], [Id]),
	CONSTRAINT [FK_Accounts__ResourceId] FOREIGN KEY ([TenantId], [ResourceId]) REFERENCES [dbo].[Resources] ([TenantId], [Id]),
	CONSTRAINT [FK_Accounts__RelatedResourceId] FOREIGN KEY ([TenantId], [RelatedResourceId]) REFERENCES [dbo].[Resources] ([TenantId], [Id]),
	CONSTRAINT [FK_Accounts__RelatedAgentAccountId] FOREIGN KEY ([TenantId], [RelatedAgentAccountId]) REFERENCES [dbo].[AgentAccounts] ([TenantId], [Id]),
	CONSTRAINT [FK_Accounts__CreatedById] FOREIGN KEY ([TenantId], [CreatedById]) REFERENCES [dbo].[LocalUsers] ([TenantId], [Id]),
	CONSTRAINT [FK_Accounts__ModifiedById] FOREIGN KEY ([TenantId], [ModifiedById]) REFERENCES [dbo].[LocalUsers] ([TenantId], [Id])
);
GO
CREATE UNIQUE INDEX [IX_Accounts__Node] ON [dbo].[Accounts]([TenantId], [Node]);
GO
CREATE INDEX [IX_Accounts__Level_Node] ON [dbo].[Accounts]([TenantId], [Level], [Node]);
GO
CREATE UNIQUE INDEX [IX_Accounts__Code] ON [dbo].[Accounts]([TenantId], [Code]) WHERE [Code] IS NOT NULL;
GO