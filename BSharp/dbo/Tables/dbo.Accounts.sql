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
/*
	An application-wide settings specify whether to activate the following columns:
	[IsActiveIFRSNote], when wanting to generate specific IFRS statements and notes
	[IsActiveResponsibilityCenter], when using cost accounting
	[IsActiveResource] when using inventory or fixed assets module
	[IsActiveExpectedSettlingDate] when tracking expiry dates and due dates
	[IsActiveAgentAccount], when using warehouses, or subsidiaries for receivable or payables
	[IsActiveRelaredResource], when activating certain tax reports
	[IsActiveRelatedAgentAccount], when activating certain tax reports
*/

/*
	-- For the following columns, see the corresponding columns in table Entries for documentation
	-- We show a note to the user: for the columns below, if the value is set at the account level
	-- then it overrides what is set at the entries level.
	If IsFixed = false, the user is expected to specify it in the journal entry line ite,s
*/

--	This field will show only if IsActiveIFRSNote, and if IFRSAccount specs require it
	[IFRSNoteId]				NVARCHAR (255),		-- includes Expense by function

--	These fields will show only if IsActiveResponsibilityCenter, and if IFRSAccount specs require it
	[ResponsibilityCenterIsFixed]BIT				NOT NULL DEFAULT (1),
	[ResponsibilityCenterId]	INT,

-- These fields will show only if IsActiveAgentAccount, and if IFRSAccount specs require it
	[AgentAccountIsFixed]		BIT					NOT NULL DEFAULT (1),
	[AgentAccountId]			INT,

-- These fields will show only if IsActiveResource, and if IFRSAccount specs require it
	[ResourceIsFixed]			BIT					NOT NULL DEFAULT (1),
	[ResourceId]				INT,

-- These fields will show only if IsActiveExpectedSettlingDate, and if IFRSAccount specs require it
	[ExpectedSettlingDateIsFixed]BIT				NOT NULL DEFAULT (0),
	[ExpectedSettlingDate]		DATETIME2(7),

-- These fields will show only if IsActiveRelaredResource, and if IFRSAccount specs require it
	[RelatedResourceIsFixed]	BIT					NOT NULL DEFAULT (0),
	[RelatedResourceId]			INT,

-- These fields will show only if IsActiveRelatedAgentAccount, and if IFRSAccount specs require it
	[RelatedAgentAccountIsFixed]BIT					NOT NULL DEFAULT (0),
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