CREATE TABLE [dbo].[Entries] (
	[TenantId]			INT,
	[Id]				INT					IDENTITY (1, 1),
	[DocumentId]		INT					NOT NULL,
	[LineType]			NVARCHAR(255)		NOT NULL DEFAULT(N'manual-journals'),
	[Direction]			SMALLINT			NOT NULL,
	[OperationId]		INT					NOT NULL,
	[AccountId]			NVARCHAR (255)		NOT NULL,
	[CustodyId]			INT					NOT NULL,
	[ResourceId]		INT					NOT NULL,
	[Amount]			MONEY				NOT NULL,
	[Value]				VTYPE				NOT NULL,
	[NoteId]			NVARCHAR (255),
	[Memo]				NVARCHAR(255), 
	[Reference]			NVARCHAR (255),
	[RelatedReference]	NVARCHAR (255),
	[RelatedAgentId]	INT,
	[RelatedResourceId]	INT,
	[RelatedAmount]		MONEY,
	[CreatedAt]			DATETIMEOFFSET(7)	NOT NULL,
	[CreatedById]			INT		NOT NULL,
	[ModifiedAt]		DATETIMEOFFSET(7)	NOT NULL, 
	[ModifiedById]		INT		NOT NULL,
	CONSTRAINT [PK_Entries] PRIMARY KEY CLUSTERED ([TenantId] ASC, [Id] ASC),
	CONSTRAINT [CK_Entries_Direction]	CHECK ([Direction] IN (-1, 1)),
	CONSTRAINT [FK_Entries_Documents]	FOREIGN KEY ([TenantId], [DocumentId])	REFERENCES [dbo].[Documents] ([TenantId], [Id]) ON DELETE CASCADE,
	CONSTRAINT [FK_Entries_LineTypes]	FOREIGN KEY ([TenantId], [LineType])	REFERENCES [dbo].[LineTypes] ([TenantId], [Id]),
	CONSTRAINT [FK_Entries_Operations]	FOREIGN KEY ([TenantId], [OperationId]) REFERENCES [dbo].[Operations] ([TenantId], [Id]),
	CONSTRAINT [FK_Entries_Accounts]	FOREIGN KEY ([TenantId], [AccountId])	REFERENCES [dbo].[Accounts] ([TenantId], [Id]),
	CONSTRAINT [FK_Entries_Custodies]	FOREIGN KEY ([TenantId], [CustodyId])	REFERENCES [dbo].[Custodies] ([TenantId], [Id]),
	CONSTRAINT [FK_Entries_Resources]	FOREIGN KEY ([TenantId], [ResourceId])	REFERENCES [dbo].[Resources] ([TenantId], [Id]),
	CONSTRAINT [FK_Entries_Notes]		FOREIGN KEY ([TenantId], [NoteId])		REFERENCES [dbo].[Notes] ([TenantId], [Id]),
	CONSTRAINT [FK_Entries_AccountsNotes] FOREIGN KEY ([TenantId], [AccountId], [NoteId], [Direction]) REFERENCES [dbo].[AccountsNotes] ([TenantId], [AccountId], [NoteId], [Direction]),
	CONSTRAINT [FK_Entries_CreatedById]	FOREIGN KEY ([TenantId], [CreatedById])	REFERENCES [dbo].[LocalUsers] ([TenantId], [Id]),
	CONSTRAINT [FK_Entries_ModifiedById]	FOREIGN KEY ([TenantId], [ModifiedById])	REFERENCES [dbo].[LocalUsers] ([TenantId], [Id])
);
GO
CREATE INDEX [IX_Entries__DocumentId] ON [dbo].[Entries]([TenantId] ASC, [DocumentId] ASC);
GO
CREATE INDEX [IX_Entries__OperationId] ON [dbo].[Entries]([TenantId] ASC, [OperationId] ASC);
GO
CREATE INDEX [IX_Entries__AccountId] ON [dbo].[Entries]([TenantId] ASC, [AccountId] ASC);
GO
CREATE INDEX [IX_Entries__NoteId] ON [dbo].[Entries]([TenantId] ASC, [NoteId] ASC);
GO