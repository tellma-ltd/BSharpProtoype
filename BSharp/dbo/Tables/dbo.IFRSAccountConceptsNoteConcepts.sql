CREATE TABLE [dbo].[IfrsAccountConceptsNoteConcepts] (
	[TenantId]				INT,
	[Id]					INT					IDENTITY,
	[IfrsAccountConcept]	NVARCHAR (255)		NOT NULL,
	[IfrsNoteConcept]		NVARCHAR (255)		NOT NULL,
	[Direction]				SMALLINT			NOT NULL,
	CONSTRAINT [PK_AccountsNotes] PRIMARY KEY NONCLUSTERED ([TenantId] ASC, [Id] ASC),
	CONSTRAINT [CK_AccountsNotes_Direction] CHECK ([Direction] IN (-1, 0, +1)),
	CONSTRAINT [FK_AccountsNotes_IfrsAccountConcepts] FOREIGN KEY ([TenantId], [IfrsAccountConcept]) REFERENCES [dbo].[IfrsAccounts] ([TenantId], [Id]) ON DELETE CASCADE, 
	CONSTRAINT [FK_AccountsNotes_IfrsNoteConcepts] FOREIGN KEY ([TenantId], [IfrsNoteConcept]) REFERENCES [dbo].[IfrsNotes] ([TenantId], [Id]) ON DELETE CASCADE
);
GO;
CREATE UNIQUE INDEX [IX_IfrsAccountConceptsNoteConcepts__IfrsAccountConcept_IfrsNoteConcept_Direction]
  ON [dbo].[IfrsAccountConceptsNoteConcepts]([TenantId] ASC, [IfrsAccountConcept] ASC, [IfrsNoteConcept] ASC, [Direction] ASC);
GO;