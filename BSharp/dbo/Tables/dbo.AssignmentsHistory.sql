CREATE TABLE [dbo].[AssignmentsHistory] (
	[TenantId]		INT,
	[Id]			INT					IDENTITY,
	[DocumentId]	INT NOT NULL,
	[AssigneeId]	INT	NOT NULL,
	[Comment]		NVARCHAR (1024),
	[AssignedBy]	INT	NOT NULL,
	[AssignedAt]	DATETIMEOFFSET (7) NOT NULL,
	[OpenedAt]		DATETIMEOFFSET (7),
	CONSTRAINT [PK_AssignmentsHistory] PRIMARY KEY CLUSTERED ([TenantId] ASC, [Id] ASC),
	CONSTRAINT [FK_AssignmentsHistory_DocumentId] FOREIGN KEY ([TenantId], [DocumentId]) REFERENCES [dbo].[Documents] ([TenantId], [Id]) ON DELETE CASCADE,
	CONSTRAINT [FK_AssignmentsHistory_AssigneeId] FOREIGN KEY ([TenantId], [AssigneeId]) REFERENCES [dbo].[LocalUsers] ([TenantId], [Id]),
	CONSTRAINT [FK_AssignmentsHistory_AssignedBy] FOREIGN KEY ([TenantId], [AssignedBy]) REFERENCES [dbo].[LocalUsers] ([TenantId], [Id])
);
GO
CREATE INDEX [IX_AssignmentsHistory__DocumentId] ON [dbo].[AssignmentsHistory]([TenantId] ASC, [DocumentId] ASC);
GO
CREATE INDEX [IX_AssignmentsHistory__AssigneeId] ON [dbo].[AssignmentsHistory]([TenantId] ASC, [AssigneeId] ASC);
GO
CREATE INDEX [IX_AssignmentsHistory__AssignedBy] ON [dbo].[AssignmentsHistory]([TenantId] ASC, [AssignedBy] ASC);
GO