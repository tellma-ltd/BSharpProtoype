CREATE TABLE [dbo].[IFRSSettings] (
	[TenantId]					INT,
	[Id]						INT					IDENTITY,
	[Field]						NVARCHAR (255)		NOT NULL,
	[Value]						NVARCHAR (255),
	[ValidSince]				Date				NOT NULL DEFAULT('01.01.0001'),
	[CreatedAt]					DATETIMEOFFSET(7)	NOT NULL,
	[CreatedById]				INT					NOT NULL,
	[ModifiedAt]				DATETIMEOFFSET(7)	NOT NULL, 
	[ModifiedById]				INT					NOT NULL,
	CONSTRAINT [PK_IFRSSettings] PRIMARY KEY CLUSTERED ([TenantId], [Id]),
	CONSTRAINT [FK_IFRSSettings_CreatedById] FOREIGN KEY ([TenantId], [CreatedById]) REFERENCES [dbo].[LocalUsers] ([TenantId], [Id]),
	CONSTRAINT [FK_IFRSSettings_ModifiedById] FOREIGN KEY ([TenantId], [ModifiedById]) REFERENCES [dbo].[LocalUsers] ([TenantId], [Id])
);
GO
ALTER TABLE [dbo].[IFRSSettings] ADD CONSTRAINT [DF_IFRSSettings__TenantId]  DEFAULT (CONVERT(INT, SESSION_CONTEXT(N'TenantId'))) FOR [TenantId];
GO
ALTER TABLE [dbo].[IFRSSettings] ADD CONSTRAINT [DF_IFRSSettings__CreatedAt]  DEFAULT (SYSDATETIMEOFFSET()) FOR [CreatedAt];
GO
ALTER TABLE [dbo].[IFRSSettings] ADD CONSTRAINT [DF_IFRSSettings__CreatedById]  DEFAULT (CONVERT(INT, SESSION_CONTEXT(N'UserId'))) FOR [CreatedById]
GO
ALTER TABLE [dbo].[IFRSSettings] ADD CONSTRAINT [DF_IFRSSettings__ModifiedAt]  DEFAULT (SYSDATETIMEOFFSET()) FOR [ModifiedAt];
GO
ALTER TABLE [dbo].[IFRSSettings] ADD CONSTRAINT [DF_IFRSSettings__ModifiedById]  DEFAULT (CONVERT(INT, SESSION_CONTEXT(N'UserId'))) FOR [ModifiedById]
GO