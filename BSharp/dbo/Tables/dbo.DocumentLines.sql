CREATE TABLE [dbo].[DocumentLines] (
--	These are for transactions only. If there are Lines from requests or inquiries, etc=> other tables
	[TenantId]				INT					DEFAULT CONVERT(INT, SESSION_CONTEXT(N'TenantId')),
	[Id]					INT					IDENTITY,
	[DocumentId]			INT					NOT NULL,

	[LineTypeId]			NVARCHAR (255)		NOT NULL, -- specifies the number of entries
	[TemplateLineId]		INT, -- depending on the line type, the user may/may not be allowed to edit
	[ScalingFactor]			FLOAT, -- Qty sold for Price list, Qty produced for BOM

-- for auditing
	[CreatedAt]				DATETIMEOFFSET(7)	NOT NULL DEFAULT SYSDATETIMEOFFSET(),
	[CreatedById]			INT					NOT NULL DEFAULT CONVERT(INT, SESSION_CONTEXT(N'UserId')),
	[ModifiedAt]			DATETIMEOFFSET(7)	NOT NULL DEFAULT SYSDATETIMEOFFSET(),
	[ModifiedById]			INT					NOT NULL DEFAULT CONVERT(INT, SESSION_CONTEXT(N'UserId')),

	CONSTRAINT [PK_DocumentLines] PRIMARY KEY CLUSTERED ([TenantId], [Id]),
	CONSTRAINT [FK_DocumentLines__DocumentId]	FOREIGN KEY ([TenantId], [DocumentId])	REFERENCES [dbo].[Documents] ([TenantId], [Id]) ON DELETE CASCADE,
	CONSTRAINT [FK_DocumentLines__LineTypeId]	FOREIGN KEY ([TenantId], [LineTypeId])	REFERENCES [dbo].[LineTypes] ([TenantId], [Id]) ON DELETE CASCADE,
	CONSTRAINT [FK_DocumentLines__CreatedById]	FOREIGN KEY ([TenantId], [CreatedById])	REFERENCES [dbo].[LocalUsers] ([TenantId], [Id]),
	CONSTRAINT [FK_DocumentLines__ModifiedById]	FOREIGN KEY ([TenantId], [ModifiedById])REFERENCES [dbo].[LocalUsers] ([TenantId], [Id]),
);
GO
CREATE INDEX [IX_DocumentLines__DocumentId] ON [dbo].[DocumentLines]([TenantId] ASC, [DocumentId] ASC);
GO