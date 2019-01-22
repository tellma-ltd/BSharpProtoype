CREATE TABLE [dbo].[SpecialEntries] (
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
	[Value]				VTYPE		NOT NULL,
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
	CONSTRAINT [PK_SpecialEntries] PRIMARY KEY CLUSTERED ([TenantId] ASC, [Id] ASC),
	CONSTRAINT [CK_SpecialEntries_Direction]	CHECK ([Direction] IN (-1, 1)),
	CONSTRAINT [FK_SpecialEntries_Lines]		FOREIGN KEY ([TenantId], [LineId])		REFERENCES [dbo].[Lines] ([TenantId], [Id]) ON DELETE CASCADE,
	CONSTRAINT [FK_SpecialEntries_Operations]	FOREIGN KEY ([TenantId], [OperationId]) REFERENCES [dbo].[Operations] ([TenantId], [Id]),
	CONSTRAINT [FK_SpecialEntries_AccountClassifications]	FOREIGN KEY ([TenantId], [AccountId])	REFERENCES [dbo].[Accounts] ([TenantId], [Id]),
	CONSTRAINT [FK_SpecialEntries_Custodies]	FOREIGN KEY ([TenantId], [CustodyId])	REFERENCES [dbo].[Custodies] ([TenantId], [Id]),
	CONSTRAINT [FK_SpecialEntries_Resources]	FOREIGN KEY ([TenantId], [ResourceId])	REFERENCES [dbo].[Resources] ([TenantId], [Id]),
	CONSTRAINT [FK_SpecialEntries_Notes]		FOREIGN KEY ([TenantId], [NoteId])		REFERENCES [dbo].[Notes] ([TenantId], [Id]),
	CONSTRAINT [FK_SpecialEntries_AccountsNotes] FOREIGN KEY ([TenantId], [AccountId], [NoteId], [Direction]) REFERENCES [dbo].[AccountsNotes] ([TenantId], [AccountId], [NoteId], [Direction]),
	CONSTRAINT [FK_SpecialEntries_CreatedBy]	FOREIGN KEY ([TenantId], [CreatedBy])	REFERENCES [dbo].[Users] ([TenantId], [Id]),
	CONSTRAINT [FK_SpecialEntries_ModifiedBy]	FOREIGN KEY ([TenantId], [ModifiedBy])	REFERENCES [dbo].[Users] ([TenantId], [Id])
);
GO
CREATE UNIQUE INDEX [IX_SpecialEntries_PK] ON [dbo].[SpecialEntries] ([TenantId], [LineId], [EntryNumber]);
GO
CREATE INDEX [IX_SpecialEntries__LineId] ON [dbo].[SpecialEntries]([TenantId] ASC, [LineId] ASC);
GO
CREATE INDEX [IX_SpecialEntries__OperationId] ON [dbo].[SpecialEntries]([TenantId] ASC, [OperationId] ASC);
GO
CREATE INDEX [IX_SpecialEntries__AccountId] ON [dbo].[SpecialEntries]([TenantId] ASC, [AccountId] ASC);
GO
CREATE INDEX [IX_SpecialEntries__CustodyId] ON [dbo].[SpecialEntries]([TenantId] ASC, [CustodyId] ASC);
GO
CREATE INDEX [IX_SpecialEntries__ResourceId] ON [dbo].[SpecialEntries]([TenantId] ASC, [ResourceId] ASC);
GO
CREATE INDEX [IX_SpecialEntries__NoteId] ON [dbo].[SpecialEntries]([TenantId] ASC, [NoteId] ASC);
GO