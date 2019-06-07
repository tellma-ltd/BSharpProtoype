CREATE TABLE [dbo].[DocumentAssignments] (
-- When document is assigned to someone, who in turn can only post or assign to someone else
-- if the assignee does not open the document, any user can still forward it to someone else
	[TenantId]		INT					DEFAULT CONVERT(INT, SESSION_CONTEXT(N'TenantId')),
	[DocumentId]	INT, -- Primary Key
-- If the document gets posted or void, this record will be deleted, and recorded in DocumentAssignmentsHistory
-- If it is in draft, it will be automatically assigned to the person who moved it to draft.
	[AssigneeId]	INT					NOT NULL,
-- When moved to draft mode, the comment is automatically To be completed in the user primary language
	[Comment]		NVARCHAR (1024),
	[CreatedAt]		DATETIMEOFFSET(7)	NOT NULL DEFAULT SYSDATETIMEOFFSET(),
	[CreatedById]	INT					NOT NULL DEFAULT CONVERT(INT, SESSION_CONTEXT(N'UserId')),
-- The first time the assignee calls the API to select the document, OpenedAt gets set
	[OpenedAt]		DATETIMEOFFSET (7),
	CONSTRAINT [PK_DocumentAssignments] PRIMARY KEY CLUSTERED ([TenantId], [DocumentId]),
	CONSTRAINT [FK_DocumentAssignments__DocumentId] FOREIGN KEY ([TenantId], [DocumentId]) REFERENCES [dbo].[Documents] ([TenantId], [Id]) ON DELETE CASCADE,
	CONSTRAINT [FK_DocumentAssignments__AssigneeId] FOREIGN KEY ([TenantId], [AssigneeId]) REFERENCES [dbo].[LocalUsers] ([TenantId], [Id]),
	CONSTRAINT [FK_DocumentAssignments__CreatedById] FOREIGN KEY ([TenantId], [CreatedById]) REFERENCES [dbo].[LocalUsers] ([TenantId], [Id])
);
GO
CREATE INDEX [IX_Assignments__AssigneeId] ON [dbo].[DocumentAssignments]([TenantId], [AssigneeId]);
GO
CREATE INDEX [IX_Assignments__CreatedBy] ON [dbo].[DocumentAssignments]([TenantId], [CreatedById]);
GO