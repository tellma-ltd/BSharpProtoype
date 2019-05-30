CREATE TABLE [dbo].[IfrsDisclosureDetails] (
	[TenantId]					INT,
	[Id]						INT					IDENTITY,
	[IfrsDisclosureId]			NVARCHAR (255)		NOT NULL,
	[Value]						NVARCHAR (255),
	[ValidSince]				Date				NOT NULL DEFAULT('0001.01.01'),
	[CreatedAt]					DATETIMEOFFSET(7)	NOT NULL,
	[CreatedById]				INT					NOT NULL,
	[ModifiedAt]				DATETIMEOFFSET(7)	NOT NULL, 
	[ModifiedById]				INT					NOT NULL,
	CONSTRAINT [PK_IfrsDisclosureDetails] PRIMARY KEY CLUSTERED ([TenantId], [Id]),
	CONSTRAINT [FK_IfrsDisclosureDetails__IfrsDisclosures]	FOREIGN KEY ([TenantId], [IfrsDisclosureId])	REFERENCES [dbo].[IfrsDisclosures] ([TenantId], [Id]) ON DELETE CASCADE,

	CONSTRAINT [FK_IfrsDisclosureDetails_CreatedById] FOREIGN KEY ([TenantId], [CreatedById]) REFERENCES [dbo].[LocalUsers] ([TenantId], [Id]),
	CONSTRAINT [FK_IfrsDisclosureDetails_ModifiedById] FOREIGN KEY ([TenantId], [ModifiedById]) REFERENCES [dbo].[LocalUsers] ([TenantId], [Id])
);
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_IfrsDisclosureDetails__IfrsDisclosureId_ValidSince]
  ON [dbo].[IfrsDisclosureDetails]([TenantId], [IfrsDisclosureId], [ValidSince]);
GO
ALTER TABLE [dbo].[IfrsDisclosureDetails] ADD CONSTRAINT [DF_IfrsDisclosureDetails__TenantId]  DEFAULT (CONVERT(INT, SESSION_CONTEXT(N'TenantId'))) FOR [TenantId];
GO
ALTER TABLE [dbo].[IfrsDisclosureDetails] ADD CONSTRAINT [DF_IfrsDisclosureDetails__CreatedAt]  DEFAULT (SYSDATETIMEOFFSET()) FOR [CreatedAt];
GO
ALTER TABLE [dbo].[IfrsDisclosureDetails] ADD CONSTRAINT [DF_IfrsDisclosureDetails__CreatedById]  DEFAULT (CONVERT(INT, SESSION_CONTEXT(N'UserId'))) FOR [CreatedById]
GO
ALTER TABLE [dbo].[IfrsDisclosureDetails] ADD CONSTRAINT [DF_IfrsDisclosureDetails__ModifiedAt]  DEFAULT (SYSDATETIMEOFFSET()) FOR [ModifiedAt];
GO
ALTER TABLE [dbo].[IfrsDisclosureDetails] ADD CONSTRAINT [DF_IfrsDisclosureDetails__ModifiedById]  DEFAULT (CONVERT(INT, SESSION_CONTEXT(N'UserId'))) FOR [ModifiedById]
GO