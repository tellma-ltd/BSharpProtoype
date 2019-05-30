CREATE TABLE [dbo].[IFRSDisclosureDetails] (
	[TenantId]					INT,
	[Id]						INT					IDENTITY,
	[IFRSDisclosureId]			NVARCHAR (255)		NOT NULL,
	[Value]						NVARCHAR (255),
	[ValidSince]				Date				NOT NULL DEFAULT('0001.01.01'),
	[CreatedAt]					DATETIMEOFFSET(7)	NOT NULL,
	[CreatedById]				INT					NOT NULL,
	[ModifiedAt]				DATETIMEOFFSET(7)	NOT NULL, 
	[ModifiedById]				INT					NOT NULL,
	CONSTRAINT [PK_IFRSDisclosureDetails] PRIMARY KEY CLUSTERED ([TenantId], [Id]),
	CONSTRAINT [FK_IFRSDisclosureDetails__IFRSDisclosures]	FOREIGN KEY ([TenantId], [IFRSDisclosureId])	REFERENCES [dbo].[IFRSDisclosures] ([TenantId], [Id]) ON DELETE CASCADE,

	CONSTRAINT [FK_IFRSDisclosureDetails_CreatedById] FOREIGN KEY ([TenantId], [CreatedById]) REFERENCES [dbo].[LocalUsers] ([TenantId], [Id]),
	CONSTRAINT [FK_IFRSDisclosureDetails_ModifiedById] FOREIGN KEY ([TenantId], [ModifiedById]) REFERENCES [dbo].[LocalUsers] ([TenantId], [Id])
);
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_IFRSDisclosureDetails__IFRSDisclosureId_ValidSince]
  ON [dbo].[IFRSDisclosureDetails]([TenantId], [IFRSDisclosureId], [ValidSince]);
GO
ALTER TABLE [dbo].[IFRSDisclosureDetails] ADD CONSTRAINT [DF_IFRSDisclosureDetails__TenantId]  DEFAULT (CONVERT(INT, SESSION_CONTEXT(N'TenantId'))) FOR [TenantId];
GO
ALTER TABLE [dbo].[IFRSDisclosureDetails] ADD CONSTRAINT [DF_IFRSDisclosureDetails__CreatedAt]  DEFAULT (SYSDATETIMEOFFSET()) FOR [CreatedAt];
GO
ALTER TABLE [dbo].[IFRSDisclosureDetails] ADD CONSTRAINT [DF_IFRSDisclosureDetails__CreatedById]  DEFAULT (CONVERT(INT, SESSION_CONTEXT(N'UserId'))) FOR [CreatedById]
GO
ALTER TABLE [dbo].[IFRSDisclosureDetails] ADD CONSTRAINT [DF_IFRSDisclosureDetails__ModifiedAt]  DEFAULT (SYSDATETIMEOFFSET()) FOR [ModifiedAt];
GO
ALTER TABLE [dbo].[IFRSDisclosureDetails] ADD CONSTRAINT [DF_IFRSDisclosureDetails__ModifiedById]  DEFAULT (CONVERT(INT, SESSION_CONTEXT(N'UserId'))) FOR [ModifiedById]
GO