CREATE TABLE [dbo].[Accounts] (
	[TenantId]					INT					DEFAULT CONVERT(INT, SESSION_CONTEXT(N'TenantId')),
	[Id]						INT					NOT NULL IDENTITY,
	-- For Trial balance reporting based on a custom classification
	[CustomClassificationId]	INT,
	-- For IFRS reporting
	[IfrsAccountId]				NVARCHAR (255), -- Ifrs Concept
	[Name]						NVARCHAR (255)		NOT NULL,
	[Name2]						NVARCHAR (255),
	[Name3]						NVARCHAR (255),
	-- To import accounts, or to control sort order, a code is required. Otherwise, it is not.
	[Code]						NVARCHAR (255), -- how it is referred to by the business entity
	[PartyReference]			NVARCHAR (255), -- how it is referred to by the other party
	[AgentId]					INT,
/*
	An application-wide settings specify whether to activate the following columns:
	[IsActiveIfrsNote], when wanting to generate specific Ifrs statements and notes
	[IsActiveResponsibilityCenter], when using cost accounting
	[IsActiveResource] when using inventory, fixed assets, or services modules
	[IsActiveExpectedSettlingDate] when tracking expiry dates and due dates
	[IsActiveRelaredResource], when activating certain tax reports
	[IsActiveRelatedAgentAccount], when activating certain tax reports
*/

/*
	-- For the following columns, see the corresponding columns in table TransactionEntries for documentation
	-- We show a note to the user: for the columns below, if the value is set at the account level
	-- then it overrides what is set at the entries level.
	If IsFixed = false, the user is expected to specify it in the journal entry line items
*/

--	This field will show only if two requirements are satisfied:
--	IsActiveIfrsNote is true, and if IfrsAccount specs requires specifying Ifrs Note in journal entry line item (JE.LI)
	[IfrsNoteIsFixed]			BIT					NOT NULL DEFAULT 0,
	[IfrsNoteId]				NVARCHAR (255),		-- includes Expense by function

	[ResponsibilityCenterId]	INT,

-- These fields will show only if IsActiveResource, and if IfrsAccount specs require it
	[ResourceIsFixed]			BIT					NOT NULL DEFAULT 1,
	[ResourceId]				INT,
	-- To transfer a document from requested to authorized, we need an evidence that the responsible actor
	-- has authorized it. If responsibility changes frequently, we use roles. 
	-- However, if responsibility center can be external to account, we may have to move these
	-- to a separate table...
	[ResponsibleActorId]		INT, -- e.g., Ashenafi
	[ResponsibleRoleId]			INT, -- e.g., Marketing Dept Manager
	[CustodianActorId]			INT, -- Alex
	[CustodianRoleId]			INT, -- Raw Materials Warehouse Keeper

	[IsActive]					BIT					NOT NULL DEFAULT 1,
	-- Audit details
	[CreatedAt]					DATETIMEOFFSET(7)	NOT NULL DEFAULT SYSDATETIMEOFFSET(),
	[CreatedById]				INT					NOT NULL DEFAULT CONVERT(INT, SESSION_CONTEXT(N'UserId')),
	[ModifiedAt]				DATETIMEOFFSET(7)	NOT NULL DEFAULT SYSDATETIMEOFFSET(),
	[ModifiedById]				INT					NOT NULL DEFAULT CONVERT(INT, SESSION_CONTEXT(N'UserId')),
	CONSTRAINT [PK_Accounts] PRIMARY KEY ([TenantId], [Id]),
	CONSTRAINT [FK_Accounts__IfrsAccountId] FOREIGN KEY ([TenantId], [IfrsAccountId]) REFERENCES [dbo].[IfrsAccounts] ([TenantId], [Id]),
	CONSTRAINT [FK_Accounts__IfrsNoteId] FOREIGN KEY ([TenantId], [IfrsNoteId]) REFERENCES [dbo].[IfrsNotes] ([TenantId], [Id]),
	CONSTRAINT [FK_Accounts__ResponsibilityCenterId] FOREIGN KEY ([TenantId], [ResponsibilityCenterId]) REFERENCES [dbo].[ResponsibilityCenters] ([TenantId], [Id]),
	CONSTRAINT [FK_Accounts__AgentId] FOREIGN KEY ([TenantId], [AgentId]) REFERENCES [dbo].[Agents] ([TenantId], [Id]),
	CONSTRAINT [FK_Accounts__ResourceId] FOREIGN KEY ([TenantId], [ResourceId]) REFERENCES [dbo].[Resources] ([TenantId], [Id]),
	CONSTRAINT [FK_Accounts__CreatedById] FOREIGN KEY ([TenantId], [CreatedById]) REFERENCES [dbo].[LocalUsers] ([TenantId], [Id]),
	CONSTRAINT [FK_Accounts__ModifiedById] FOREIGN KEY ([TenantId], [ModifiedById]) REFERENCES [dbo].[LocalUsers] ([TenantId], [Id])
);
GO
CREATE UNIQUE INDEX [IX_Accounts__Code] ON [dbo].[Accounts]([TenantId], [Code]) WHERE [Code] IS NOT NULL;
GO