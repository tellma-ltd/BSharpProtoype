﻿CREATE TABLE [dbo].[DocumentAssignmentsHistory] (
-- To be filled by a trigger on table DocumentsAssignments
	[TenantId]		INT					DEFAULT CONVERT(INT, SESSION_CONTEXT(N'TenantId')),
	[Id]			INT					IDENTITY,
	[DocumentId]	INT					NOT NULL,
	[AssigneeId]	INT					NOT NULL,
	[Comment]		NVARCHAR (1024),
	[CreatedAt]		DATETIMEOFFSET(7)	NOT NULL DEFAULT SYSDATETIMEOFFSET(),
	[CreatedById]	INT					NOT NULL DEFAULT CONVERT(INT, SESSION_CONTEXT(N'UserId')),
	[OpenedAt]		DATETIMEOFFSET (7),
	CONSTRAINT [PK_DocumentAssignmentsHistory] PRIMARY KEY CLUSTERED ([TenantId], [Id]),
	CONSTRAINT [FK_DocumentAssignmentsHistory__DocumentId] FOREIGN KEY ([TenantId], [DocumentId]) REFERENCES [dbo].[Documents] ([TenantId], [Id]) ON DELETE CASCADE,
	CONSTRAINT [FK_DocumentAssignmentsHistory__AssigneeId] FOREIGN KEY ([TenantId], [AssigneeId]) REFERENCES [dbo].[LocalUsers] ([TenantId], [Id]),
	CONSTRAINT [FK_DocumentAssignmentsHistory__CreatedById] FOREIGN KEY ([TenantId], [CreatedById]) REFERENCES [dbo].[LocalUsers] ([TenantId], [Id])
);
GO
CREATE INDEX [IX_AssignmentsHistory__DocumentId] ON [dbo].[DocumentAssignmentsHistory]([TenantId], [DocumentId]);
GO
CREATE INDEX [IX_AssignmentsHistory__AssigneeId] ON [dbo].[DocumentAssignmentsHistory]([TenantId], [AssigneeId]);
GO
CREATE INDEX [IX_AssignmentsHistory__CreatedById] ON [dbo].[DocumentAssignmentsHistory]([TenantId], [CreatedById]);
GO