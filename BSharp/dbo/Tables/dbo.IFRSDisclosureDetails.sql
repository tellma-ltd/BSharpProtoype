CREATE TABLE [dbo].[IfrsDisclosureDetails] (
	[Id]				UNIQUEIDENTIFIER PRIMARY KEY,
	[IfrsDisclosureId]	NVARCHAR (255)		NOT NULL,
	[Value]				NVARCHAR (255),
	[ValidSince]		Date				NOT NULL DEFAULT '0001.01.01',
	[IsDeleted]			BIT					NOT NULL DEFAULT 0,
	[CreatedAt]			DATETIMEOFFSET(7)	NOT NULL DEFAULT SYSDATETIMEOFFSET(),
	[CreatedById]		UNIQUEIDENTIFIER	NOT NULL DEFAULT CONVERT(UNIQUEIDENTIFIER, SESSION_CONTEXT(N'UserId')),
	[ModifiedAt]		DATETIMEOFFSET(7)	NOT NULL DEFAULT SYSDATETIMEOFFSET(), 
	[ModifiedById]		UNIQUEIDENTIFIER	NOT NULL DEFAULT CONVERT(UNIQUEIDENTIFIER, SESSION_CONTEXT(N'UserId')),
	CONSTRAINT [FK_IfrsDisclosureDetails__IfrsDisclosures]	FOREIGN KEY ([IfrsDisclosureId])	REFERENCES [dbo].[IfrsDisclosures] ([Id]) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT [FK_IfrsDisclosureDetails__CreatedById] FOREIGN KEY ([CreatedById]) REFERENCES [dbo].[LocalUsers] ([Id]),
	CONSTRAINT [FK_IfrsDisclosureDetails__ModifiedById] FOREIGN KEY ([ModifiedById]) REFERENCES [dbo].[LocalUsers] ([Id])
);
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_IfrsDisclosureDetails__IfrsDisclosureId_ValidSince]
  ON [dbo].[IfrsDisclosureDetails]([IfrsDisclosureId], [ValidSince]);
GO