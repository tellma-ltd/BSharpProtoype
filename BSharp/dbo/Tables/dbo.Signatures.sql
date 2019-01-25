CREATE TABLE [dbo].[Signatures] (
	[TenantId]		INT,
	[Id]			INT IDENTITY (1, 1),
	[DocumentId]	INT					NOT NULL,
	[Signatory]		INT		NOT NULL,
	[SignedAt]		DATETIMEOFFSET(7)	NOT NULL,
	[UnsignedAt]	DATETIMEOFFSET(7)
	CONSTRAINT [PK_Signatures] PRIMARY KEY CLUSTERED ([TenantId] ASC, [Id] ASC),
	CONSTRAINT [FK_Signatures_Documents] FOREIGN KEY ([TenantId], [DocumentId]) REFERENCES [dbo].[Documents] ([TenantId], [Id]) ON DELETE CASCADE
);
GO
CREATE INDEX [IX_Signatures__DocumentId] ON [dbo].[Signatures]([TenantId] ASC, [DocumentId] ASC);
GO