CREATE TABLE [dbo].[DocumentActions] (
	[TenantId]			INT,
	[Id]				INT IDENTITY (1, 1),
	[DocumentId]		INT					NOT NULL,
	[Action]			NVARCHAR(255)		NOT NULL DEFAULT (N'New'),
	[ActionByUserId]	NVARCHAR (450)		NOT NULL DEFAULT SUSER_SNAME(),
	[ActionDateTime]	DATETIMEOFFSET(7)	NOT NULL DEFAULT SYSDATETIMEOFFSET(),
	CONSTRAINT [PK_DocumentActions] PRIMARY KEY CLUSTERED ([TenantId] ASC, [Id] ASC),
	CONSTRAINT [FK_DocumentActions_Documents] FOREIGN KEY ([TenantId], [DocumentId]) REFERENCES [dbo].[Documents] ([TenantId], [Id]) ON DELETE CASCADE,
	CONSTRAINT [CK_DocumentActions_Action] CHECK ([Action] IN (N'New', N'DraftToSubmitted', N'DraftToVoid',
				N'SubmittedToDraft', N'SubmittedToPosted', N'PostedToSubmitted', N'Signed', N'Unsigned',
				N'Delegated', N'Merged', N'Splitted', N'Decomposed'))
)
