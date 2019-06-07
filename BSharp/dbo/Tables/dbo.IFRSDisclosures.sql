CREATE TABLE [dbo].[IfrsDisclosures] (
	[TenantId]			INT					DEFAULT CONVERT(INT, SESSION_CONTEXT(N'TenantId')),
	[Id]				NVARCHAR (255), -- Ifrs Concept
	[CreatedAt]			DATETIMEOFFSET(7)	NOT NULL DEFAULT SYSDATETIMEOFFSET(),
	[CreatedById]		INT					NOT NULL DEFAULT CONVERT(INT, SESSION_CONTEXT(N'UserId')),
	[ModifiedAt]		DATETIMEOFFSET(7)	NOT NULL DEFAULT SYSDATETIMEOFFSET(),
	[ModifiedById]		INT					NOT NULL DEFAULT CONVERT(INT, SESSION_CONTEXT(N'UserId')),
	CONSTRAINT [PK_IfrsDisclosures] PRIMARY KEY NONCLUSTERED ([TenantId] ASC, [Id]),
	CONSTRAINT [FK_IfrsDisclosures__IfrsConcepts]	FOREIGN KEY ([TenantId], [Id]) REFERENCES [dbo].[IfrsConcepts] ([TenantId], [Id]) ON DELETE CASCADE,
	CONSTRAINT [FK_IfrsDisclosures__CreatedById] FOREIGN KEY ([TenantId], [CreatedById]) REFERENCES [dbo].[LocalUsers] ([TenantId], [Id]),
	CONSTRAINT [FK_IfrsDisclosures__ModifiedById] FOREIGN KEY ([TenantId], [ModifiedById]) REFERENCES [dbo].[LocalUsers] ([TenantId], [Id])
)
GO