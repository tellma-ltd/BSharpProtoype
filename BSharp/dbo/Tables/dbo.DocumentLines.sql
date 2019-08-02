CREATE TABLE [dbo].[DocumentLines] (
--	These are for transactions only. If there are Lines from requests or inquiries, etc=> other tables
	[Id]					UNIQUEIDENTIFIER PRIMARY KEY,
	[DocumentId]			UNIQUEIDENTIFIER	NOT NULL,

	[LineTypeId]			NVARCHAR (255)		NOT NULL, -- specifies the number of entries
	[TemplateLineId]		UNIQUEIDENTIFIER, -- depending on the line type, the user may/may not be allowed to edit
	[ScalingFactor]			FLOAT, -- Qty sold for Price list, Qty produced for BOM
	[AgentId]				UNIQUEIDENTIFIER, -- useful for storing the conversion agent in conversion transactions
-- for auditing
	[CreatedAt]				DATETIMEOFFSET(7)	NOT NULL DEFAULT SYSDATETIMEOFFSET(),
	[CreatedById]			UNIQUEIDENTIFIER	NOT NULL DEFAULT CONVERT(UNIQUEIDENTIFIER, SESSION_CONTEXT(N'UserId')),
	[ModifiedAt]			DATETIMEOFFSET(7)	NOT NULL DEFAULT SYSDATETIMEOFFSET(),
	[ModifiedById]			UNIQUEIDENTIFIER	NOT NULL DEFAULT CONVERT(UNIQUEIDENTIFIER, SESSION_CONTEXT(N'UserId')),

	CONSTRAINT [FK_DocumentLines__DocumentId]	FOREIGN KEY ([DocumentId])	REFERENCES [dbo].[Documents] ([Id]) ON DELETE CASCADE,
	CONSTRAINT [FK_DocumentLines__LineTypeId]	FOREIGN KEY ([LineTypeId])	REFERENCES [dbo].[LineTypes] ([Id]) ON DELETE CASCADE,
	CONSTRAINT [FK_DocumentLines__CreatedById]	FOREIGN KEY ([CreatedById])	REFERENCES [dbo].[LocalUsers] ([Id]),
	CONSTRAINT [FK_DocumentLines__ModifiedById]	FOREIGN KEY ([ModifiedById])REFERENCES [dbo].[LocalUsers] ([Id]),
);
GO
CREATE INDEX [IX_DocumentLines__DocumentId] ON [dbo].[DocumentLines]([DocumentId]);
GO