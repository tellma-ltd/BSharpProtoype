CREATE TABLE [dbo].[Assignments] (
	[TenantId]		INT,
	[DocumentId]	INT,
	[AssigneeId]	NVARCHAR (450)	NOT NULL,
	[Comment]		NVARCHAR (1024),
	[AssignedBy]	NVARCHAR (450)	NOT NULL,
	[AssignedAt]	DATETIMEOFFSET (7) NOT NULL,
	[OpenedAt]		DATETIMEOFFSET (7),
	CONSTRAINT [PK_Assignments] PRIMARY KEY CLUSTERED ([TenantId] ASC, [DocumentId] ASC),
	CONSTRAINT [FK_Assignments_DocumentId] FOREIGN KEY ([TenantId], [DocumentId]) REFERENCES [dbo].[Documents] ([TenantId], [Id]) ON DELETE CASCADE,
	CONSTRAINT [FK_Assignments_AssigneeId] FOREIGN KEY ([TenantId], [AssigneeId]) REFERENCES [dbo].[Users] ([TenantId], [Id]),
	CONSTRAINT [FK_Assignments_AssignedBy] FOREIGN KEY ([TenantId], [AssignedBy]) REFERENCES [dbo].[Users] ([TenantId], [Id])
);
GO
CREATE INDEX [IX_Assignments__DocumentId] ON [dbo].[Assignments]([TenantId] ASC, [DocumentId] ASC);
GO
CREATE INDEX [IX_Assignments__AssigneeId] ON [dbo].[Assignments]([TenantId] ASC, [AssigneeId] ASC);
GO
CREATE INDEX [IX_Assignments__AssignedBy] ON [dbo].[Assignments]([TenantId] ASC, [AssignedBy] ASC);
GO

