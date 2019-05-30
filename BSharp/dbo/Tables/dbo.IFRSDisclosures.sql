CREATE TABLE [dbo].[IfrsDisclosures] (
	[TenantId]					INT,
	[Id]						NVARCHAR (255), -- Ifrs Concept
	[CreatedAt]					DATETIMEOFFSET(7)	NOT NULL,
	[CreatedById]				INT					NOT NULL,
	[ModifiedAt]				DATETIMEOFFSET(7)	NOT NULL, 
	[ModifiedById]				INT					NOT NULL
	CONSTRAINT [PK_IfrsDisclosures] PRIMARY KEY NONCLUSTERED ([TenantId] ASC, [Id]),
	CONSTRAINT [FK_IfrsDisclosures__IfrsConcepts]	FOREIGN KEY ([TenantId], [Id])	REFERENCES [dbo].[IfrsConcepts] ([TenantId], [Id]) ON DELETE CASCADE,
	CONSTRAINT [FK_IfrsDisclosures__CreatedById] FOREIGN KEY ([TenantId], [CreatedById]) REFERENCES [dbo].[LocalUsers] ([TenantId], [Id]),
	CONSTRAINT [FK_IfrsDisclosures__ModifiedById] FOREIGN KEY ([TenantId], [ModifiedById]) REFERENCES [dbo].[LocalUsers] ([TenantId], [Id])
)
GO
ALTER TABLE [dbo].[IfrsDisclosures] ADD CONSTRAINT [DF_IfrsDisclosures__TenantId]  DEFAULT (CONVERT(INT, SESSION_CONTEXT(N'TenantId'))) FOR [TenantId];
GO
ALTER TABLE [dbo].[IfrsDisclosures] ADD CONSTRAINT [DF_IfrsDisclosures__CreatedAt]  DEFAULT (SYSDATETIMEOFFSET()) FOR [CreatedAt];
GO
ALTER TABLE [dbo].[IfrsDisclosures] ADD CONSTRAINT [DF_IfrsDisclosures__CreatedById]  DEFAULT (CONVERT(INT, SESSION_CONTEXT(N'UserId'))) FOR [CreatedById]
GO
ALTER TABLE [dbo].[IfrsDisclosures] ADD CONSTRAINT [DF_IfrsDisclosures__ModifiedAt]  DEFAULT (SYSDATETIMEOFFSET()) FOR [ModifiedAt];
GO
ALTER TABLE [dbo].[IfrsDisclosures] ADD CONSTRAINT [DF_IfrsDisclosures__ModifiedById]  DEFAULT (CONVERT(INT, SESSION_CONTEXT(N'UserId'))) FOR [ModifiedById]
GO
