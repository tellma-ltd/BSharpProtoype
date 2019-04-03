CREATE TABLE [dbo].[IFRSAccountConceptsNoteConcepts] (
	[TenantId]				INT,
	[Id]					INT					IDENTITY,
	[IFRSAccountConcept]	NVARCHAR (255)		NOT NULL,
	[IFRSNoteConcept]		NVARCHAR (255)		NOT NULL,
	[Direction]				SMALLINT			NOT NULL,
	CONSTRAINT [PK_AccountsNotes] PRIMARY KEY NONCLUSTERED ([TenantId] ASC, [Id] ASC),
	CONSTRAINT [CK_AccountsNotes_Direction] CHECK ([Direction] IN (-1, 0, +1)),
	CONSTRAINT [FK_AccountsNotes_IFRSAccountConcepts] FOREIGN KEY ([TenantId], [IFRSAccountConcept]) REFERENCES [dbo].[IFRSAccounts] ([TenantId], [IFRSConcept]) ON DELETE CASCADE, 
	CONSTRAINT [FK_AccountsNotes_IFRSNoteConcepts] FOREIGN KEY ([TenantId], [IFRSNoteConcept]) REFERENCES [dbo].[IFRSNotes] ([TenantId], [IFRSConcept]) ON DELETE CASCADE
);
GO;
CREATE UNIQUE INDEX [IX_IFRSAccountConceptsNoteConcepts__IFRSAccountConcept_IFRSNoteConcept_Direction]
  ON [dbo].[IFRSAccountConceptsNoteConcepts]([TenantId] ASC, [IFRSAccountConcept] ASC, [IFRSNoteConcept] ASC, [Direction] ASC);
GO;