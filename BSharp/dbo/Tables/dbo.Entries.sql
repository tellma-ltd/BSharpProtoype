CREATE TABLE [dbo].[Entries] (
	[TenantId]			INT,
	[Id]				INT					IDENTITY (1, 1),
	[LineId]			INT					NOT NULL,
	[EntryNumber]		INT					NOT NULL,
	[OperationId]		INT					NOT NULL,
	[AccountId]			NVARCHAR (255)		NOT NULL,
	[CustodyId]			INT					NOT NULL,
	[ResourceId]		INT					NOT NULL,
	[Direction]			SMALLINT			NOT NULL,
	[Amount]			MONEY				NOT NULL,
	[Value]				MONEY				NOT NULL,
	[NoteId]			NVARCHAR (255),
	[Reference]			NVARCHAR (255),
	[RelatedReference]	NVARCHAR (255),
	[RelatedAgentId]	INT,
	[RelatedResourceId]	INT,
	[RelatedAmount]		MONEY,
	[CreatedAt]			DATETIMEOFFSET(7)	NOT NULL,
	[CreatedBy]			NVARCHAR(450)		NOT NULL,
	[ModifiedAt]		DATETIMEOFFSET(7)	NOT NULL, 
	[ModifiedBy]		NVARCHAR(450)		NOT NULL,
	CONSTRAINT [PK_Entries] PRIMARY KEY CLUSTERED ([TenantId] ASC, [Id] ASC),
	CONSTRAINT [CK_Entries_Direction]	CHECK ([Direction] IN (-1, 1)),
	CONSTRAINT [FK_Entries_Lines]		FOREIGN KEY ([TenantId], [LineId])		REFERENCES [dbo].[Lines] ([TenantId], [Id]) ON DELETE CASCADE,
	CONSTRAINT [FK_Entries_Operations]	FOREIGN KEY ([TenantId], [OperationId]) REFERENCES [dbo].[Operations] ([TenantId], [Id]),
	CONSTRAINT [FK_Entries_Accounts]	FOREIGN KEY ([TenantId], [AccountId])	REFERENCES [dbo].[Accounts] ([TenantId], [Id]),
	CONSTRAINT [FK_Entries_Custodies]	FOREIGN KEY ([TenantId], [CustodyId])	REFERENCES [dbo].[Custodies] ([TenantId], [Id]),
	CONSTRAINT [FK_Entries_Resources]	FOREIGN KEY ([TenantId], [ResourceId])	REFERENCES [dbo].[Resources] ([TenantId], [Id]),
	CONSTRAINT [FK_Entries_Notes]		FOREIGN KEY ([TenantId], [NoteId])		REFERENCES [dbo].[Notes] ([TenantId], [Id])
);
GO
CREATE UNIQUE INDEX [IX_Entries_PK] ON [dbo].[Entries] ([TenantId], [LineId], [EntryNumber]);
GO
CREATE INDEX [IX_Entries__LineId] ON [dbo].[Entries]([TenantId] ASC, [LineId] ASC);
GO
CREATE INDEX [IX_Entries__OperationId] ON [dbo].[Entries]([TenantId] ASC, [OperationId] ASC);
GO
CREATE INDEX [IX_Entries__AccountId] ON [dbo].[Entries]([TenantId] ASC, [AccountId] ASC);
GO
CREATE INDEX [IX_Entries__CustodyId] ON [dbo].[Entries]([TenantId] ASC, [CustodyId] ASC);
GO
CREATE INDEX [IX_Entries__ResourceId] ON [dbo].[Entries]([TenantId] ASC, [ResourceId] ASC);
GO
CREATE INDEX [IX_Entries__NoteId] ON [dbo].[Entries]([TenantId] ASC, [NoteId] ASC);
GO