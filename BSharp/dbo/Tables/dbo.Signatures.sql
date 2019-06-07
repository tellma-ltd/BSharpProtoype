CREATE TABLE [dbo].[Signatures] (
	[TenantId]		INT					DEFAULT CONVERT(INT, SESSION_CONTEXT(N'TenantId')),
	[Id]			INT IDENTITY,
	[DocumentId]	INT					NOT NULL,
	[SignedById]	INT					NOT NULL DEFAULT CONVERT(INT, SESSION_CONTEXT(N'UserId')),
	[SignedAt]		DATETIMEOFFSET(7)	NOT NULL DEFAULT SYSDATETIMEOFFSET(),
	[UnsignedAt]	DATETIMEOFFSET(7)
	CONSTRAINT [PK_Signatures] PRIMARY KEY CLUSTERED ([TenantId] ASC, [Id] ASC),
	CONSTRAINT [FK_Signatures__Documents] FOREIGN KEY ([TenantId], [DocumentId]) REFERENCES [dbo].[Documents] ([TenantId], [Id]) ON DELETE CASCADE
);
GO
CREATE INDEX [IX_Signatures__DocumentId] ON [dbo].[Signatures]([TenantId] ASC, [DocumentId] ASC);
GO