CREATE TABLE [dbo].[IfrsAccountsIfrsNotes] (
	[TenantId]				INT				DEFAULT CONVERT(INT, SESSION_CONTEXT(N'TenantId')),
	[Id]					INT				IDENTITY,
	[IfrsAccountId]			NVARCHAR (255)	NOT NULL,
	[IfrsNoteId]			NVARCHAR (255)	NOT NULL,
	[Direction]				SMALLINT		NOT NULL,
	CONSTRAINT [PK_IfrsAccountsIfrsNotes] PRIMARY KEY NONCLUSTERED ([TenantId] ASC, [Id] ASC),
	CONSTRAINT [CK_IfrsAccountsIfrsNotes_Direction] CHECK ([Direction] IN (-1, 0, +1)),
	CONSTRAINT [FK_IfrsAccountsIfrsNotes_IfrsAccountId] FOREIGN KEY ([TenantId], [IfrsAccountId]) REFERENCES [dbo].[IfrsAccounts] ([TenantId], [Id]) ON DELETE CASCADE ON UPDATE CASCADE, 
	CONSTRAINT [FK_IfrsAccountsIfrsNotes_IfrsNoteId] FOREIGN KEY ([TenantId], [IfrsNoteId]) REFERENCES [dbo].[IfrsNotes] ([TenantId], [Id])
);
GO;
CREATE UNIQUE INDEX [IX_IfrsAccountConceptsNoteConcepts__IfrsAccountConcept_IfrsNoteConcept_Direction]
  ON [dbo].[IfrsAccountsIfrsNotes]([TenantId] ASC, [IfrsAccountId] ASC, [IfrsNoteId] ASC, [Direction] ASC);
GO;