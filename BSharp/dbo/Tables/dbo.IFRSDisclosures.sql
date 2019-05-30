CREATE TABLE [dbo].[IFRSDisclosures] (
	[TenantId]					INT,
	[Id]						NVARCHAR (255), -- IFRS Concept
	[CreatedAt]					DATETIMEOFFSET(7)	NOT NULL,
	[CreatedById]				INT					NOT NULL,
	[ModifiedAt]				DATETIMEOFFSET(7)	NOT NULL, 
	[ModifiedById]				INT					NOT NULL
	CONSTRAINT [PK_IFRSDisclosures] PRIMARY KEY NONCLUSTERED ([TenantId] ASC, [Id]),
	--CONSTRAINT [CK_IFRSDisclosures__IFRSType] CHECK ([IFRSType] IN (N'Amendment', N'Extension', N'Regulatory')),
	CONSTRAINT [FK_IFRSDisclosures__CreatedById] FOREIGN KEY ([TenantId], [CreatedById]) REFERENCES [dbo].[LocalUsers] ([TenantId], [Id]),
	CONSTRAINT [FK_IFRSDisclosures__ModifiedById] FOREIGN KEY ([TenantId], [ModifiedById]) REFERENCES [dbo].[LocalUsers] ([TenantId], [Id])
)
GO
ALTER TABLE [dbo].[IFRSDisclosures] ADD CONSTRAINT [DF_IFRSDisclosures__TenantId]  DEFAULT (CONVERT(INT, SESSION_CONTEXT(N'TenantId'))) FOR [TenantId];
GO
ALTER TABLE [dbo].[IFRSDisclosures] ADD CONSTRAINT [DF_IFRSDisclosures__CreatedAt]  DEFAULT (SYSDATETIMEOFFSET()) FOR [CreatedAt];
GO
ALTER TABLE [dbo].[IFRSDisclosures] ADD CONSTRAINT [DF_IFRSDisclosures__CreatedById]  DEFAULT (CONVERT(INT, SESSION_CONTEXT(N'UserId'))) FOR [CreatedById]
GO
ALTER TABLE [dbo].[IFRSDisclosures] ADD CONSTRAINT [DF_IFRSDisclosures__ModifiedAt]  DEFAULT (SYSDATETIMEOFFSET()) FOR [ModifiedAt];
GO
ALTER TABLE [dbo].[IFRSDisclosures] ADD CONSTRAINT [DF_IFRSDisclosures__ModifiedById]  DEFAULT (CONVERT(INT, SESSION_CONTEXT(N'UserId'))) FOR [ModifiedById]
GO
