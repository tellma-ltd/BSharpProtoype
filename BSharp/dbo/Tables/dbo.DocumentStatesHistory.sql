CREATE TABLE [dbo].[DocumentStatesHistory] (
-- To be filled by a trigger on table Documents
	[TenantId]		INT					DEFAULT CONVERT(INT, SESSION_CONTEXT(N'TenantId')),
	[Id]			INT					IDENTITY,
	[DocumentId]	INT					NOT NULL,
	[State]			NVARCHAR (1024),
	[StateAt]		DATETIMEOFFSET(7)	NOT NULL DEFAULT SYSDATETIMEOFFSET(),
	CONSTRAINT [PK_DocumentStatesHistory] PRIMARY KEY CLUSTERED ([TenantId], [Id]),
	CONSTRAINT [FK_DocumentStatesHistory__DocumentId] FOREIGN KEY ([TenantId], [DocumentId]) REFERENCES [dbo].[Documents] ([TenantId], [Id]) ON DELETE CASCADE,
);
GO
CREATE INDEX [IX_StatesHistory__DocumentId] ON [dbo].[DocumentStatesHistory]([TenantId], [DocumentId]);
GO
