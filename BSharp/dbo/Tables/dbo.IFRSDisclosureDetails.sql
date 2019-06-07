CREATE TABLE [dbo].[IfrsDisclosureDetails] (
	[TenantId]			INT					DEFAULT CONVERT(INT, SESSION_CONTEXT(N'TenantId')),
	[Id]				INT					IDENTITY,
	[IfrsDisclosureId]	NVARCHAR (255)		NOT NULL,
	[Value]				NVARCHAR (255),
	[ValidSince]		Date				NOT NULL DEFAULT('0001.01.01'),
	[CreatedAt]			DATETIMEOFFSET(7)	NOT NULL DEFAULT SYSDATETIMEOFFSET(),
	[CreatedById]		INT					NOT NULL DEFAULT CONVERT(INT, SESSION_CONTEXT(N'UserId')),
	[ModifiedAt]		DATETIMEOFFSET(7)	NOT NULL DEFAULT SYSDATETIMEOFFSET(), 
	[ModifiedById]		INT					NOT NULL DEFAULT CONVERT(INT, SESSION_CONTEXT(N'UserId')),
	CONSTRAINT [PK_IfrsDisclosureDetails] PRIMARY KEY CLUSTERED ([TenantId], [Id]),
	CONSTRAINT [FK_IfrsDisclosureDetails__IfrsDisclosures]	FOREIGN KEY ([TenantId], [IfrsDisclosureId])	REFERENCES [dbo].[IfrsDisclosures] ([TenantId], [Id]) ON DELETE CASCADE,
	CONSTRAINT [FK_IfrsDisclosureDetails_CreatedById] FOREIGN KEY ([TenantId], [CreatedById]) REFERENCES [dbo].[LocalUsers] ([TenantId], [Id]),
	CONSTRAINT [FK_IfrsDisclosureDetails_ModifiedById] FOREIGN KEY ([TenantId], [ModifiedById]) REFERENCES [dbo].[LocalUsers] ([TenantId], [Id])
);
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_IfrsDisclosureDetails__IfrsDisclosureId_ValidSince]
  ON [dbo].[IfrsDisclosureDetails]([TenantId], [IfrsDisclosureId], [ValidSince]);
GO