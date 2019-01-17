CREATE TABLE [dbo].[AccountsNotes] (
	[TenantId]		INT,
	[Id]			INT					IDENTITY (1, 1),
	[AccountId]		NVARCHAR (255)		NOT NULL,
	[NoteId]		NVARCHAR (255)		NOT NULL,
	[Direction]		SMALLINT			NOT NULL,
	CONSTRAINT [PK_AccountsNotes] PRIMARY KEY NONCLUSTERED ([TenantId] ASC, [Id] ASC),
	CONSTRAINT [CK_AccountsNotes_Direction] CHECK ([Direction] IN (-1, 0, +1)),
	CONSTRAINT [FK_AccountsNotes_Accounts] FOREIGN KEY ([TenantId], [AccountId]) REFERENCES [dbo].[Accounts] ([TenantId], [Id]) ON DELETE CASCADE, 
	CONSTRAINT [FK_AccountsNotes_Notes] FOREIGN KEY ([TenantId], [NoteId]) REFERENCES [dbo].[Notes] ([TenantId], [Id]) ON DELETE CASCADE
);
GO;
CREATE UNIQUE INDEX [IX_AccountsNotes__AccountId_NoteId_Direction]
  ON [dbo].[AccountsNotes]([TenantId] ASC, [AccountId] ASC, [NoteId] ASC, [Direction] ASC);
GO;