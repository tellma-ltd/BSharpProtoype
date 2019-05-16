CREATE TABLE [dbo].[Signatures] (
	[TenantId]		INT,
	[Id]			INT IDENTITY,
	[DocumentId]	INT					NOT NULL,
	[SignatoryId]	INT					NOT NULL,
	[SignedAt]		DATETIMEOFFSET(7)	NOT NULL,
	[UnsignedAt]	DATETIMEOFFSET(7)
	CONSTRAINT [PK_Signatures] PRIMARY KEY CLUSTERED ([TenantId] ASC, [Id] ASC),
	CONSTRAINT [FK_Signatures__Documents] FOREIGN KEY ([TenantId], [DocumentId]) REFERENCES [dbo].[Documents] ([TenantId], [Id]) ON DELETE CASCADE
);
GO
CREATE INDEX [IX_Signatures__DocumentId] ON [dbo].[Signatures]([TenantId] ASC, [DocumentId] ASC);
GO
ALTER TABLE [dbo].[Signatures] ADD CONSTRAINT [DF_Signatures__SignedAt]  DEFAULT (SYSDATETIMEOFFSET()) FOR [SignedAt];
GO
ALTER TABLE [dbo].[Signatures] ADD CONSTRAINT [DF_Signatures__SignatoryId]  DEFAULT (CONVERT(INT, SESSION_CONTEXT(N'UserId'))) FOR [SignatoryId]
GO