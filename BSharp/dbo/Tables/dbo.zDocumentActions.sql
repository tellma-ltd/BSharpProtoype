CREATE TABLE [dbo].[DocumentActions] ( -- old table, not sure still useful
	[TenantId]			INT,
	[Id]				INT IDENTITY,
	[DocumentId]		INT					NOT NULL,
	[Action]			NVARCHAR(255)		NOT NULL DEFAULT (N'New'),
	[ActionByUserId]	INT					NOT NULL DEFAULT SUSER_SNAME(),
	[ActionDateTime]	DATETIMEOFFSET(7)	NOT NULL DEFAULT SYSDATETIMEOFFSET(),
	CONSTRAINT [PK_DocumentActions] PRIMARY KEY CLUSTERED ([TenantId] ASC, [Id] ASC),
	CONSTRAINT [FK_DocumentActions_Documents] FOREIGN KEY ([TenantId], [DocumentId]) REFERENCES [dbo].[Documents] ([TenantId], [Id]) ON DELETE CASCADE,
	CONSTRAINT [CK_DocumentActions_Action] CHECK ([Action] IN (N'New', N'DraftToVoid', N'DraftToPosted', N'PostedToDraft'))
);