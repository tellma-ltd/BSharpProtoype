CREATE TABLE [dbo].[DocumentAssignmentsHistory] (
-- To be filled by a trigger on table DocumentsAssignments
	[Id]								UNIQUEIDENTIFIER PRIMARY KEY,
	[DocumentId]	UNIQUEIDENTIFIER	NOT NULL,
	[AssigneeId]	UNIQUEIDENTIFIER	NOT NULL,
	[Comment]		NVARCHAR (1024),
	[CreatedAt]		DATETIMEOFFSET(7)	NOT NULL DEFAULT SYSDATETIMEOFFSET(),
	[CreatedById]	UNIQUEIDENTIFIER	NOT NULL DEFAULT CONVERT(UNIQUEIDENTIFIER, SESSION_CONTEXT(N'UserId')),
	[OpenedAt]		DATETIMEOFFSET (7),
	CONSTRAINT [FK_DocumentAssignmentsHistory__DocumentId] FOREIGN KEY ([DocumentId]) REFERENCES [dbo].[Documents] ([Id]) ON DELETE CASCADE,
	CONSTRAINT [FK_DocumentAssignmentsHistory__AssigneeId] FOREIGN KEY ([AssigneeId]) REFERENCES [dbo].[LocalUsers] ([Id]),
	CONSTRAINT [FK_DocumentAssignmentsHistory__CreatedById] FOREIGN KEY ([CreatedById]) REFERENCES [dbo].[LocalUsers] ([Id])
);
GO
CREATE INDEX [IX_AssignmentsHistory__DocumentId] ON [dbo].[DocumentAssignmentsHistory]([DocumentId]);
GO
CREATE INDEX [IX_AssignmentsHistory__AssigneeId] ON [dbo].[DocumentAssignmentsHistory]([AssigneeId]);
GO
CREATE INDEX [IX_AssignmentsHistory__CreatedById] ON [dbo].[DocumentAssignmentsHistory]([CreatedById]);
GO