CREATE TABLE [dbo].[Workflows] (
	[Id]			UNIQUEIDENTIFIER PRIMARY KEY,
	[DocumentTypeId]NVARCHAR (255)		NOT NULL,
	[FromState]		NVARCHAR (255)		NOT NULL,
	[ToState]		NVARCHAR (255)		NOT NULL,

	[CreatedAt]		DATETIMEOFFSET(7)	NOT NULL DEFAULT SYSDATETIMEOFFSET(),
	[CreatedById]	UNIQUEIDENTIFIER	NOT NULL DEFAULT CONVERT(UNIQUEIDENTIFIER, SESSION_CONTEXT(N'UserId')),
	
	[RevokedAt]		DATETIMEOFFSET(7),
	[RevokedById]	UNIQUEIDENTIFIER,
	CONSTRAINT [FK_Workflows__DocumentTypes] FOREIGN KEY ([DocumentTypeId]) REFERENCES [dbo].[DocumentTypes] ([Id]) ON DELETE CASCADE,
	CONSTRAINT [CK_Workflows__FromState] CHECK ([FromState] IN (N'Void', N'Requested', N'Rejected', N'Authorized', N'Failed', N'Completed', N'Invalid', N'Posted')),
	CONSTRAINT [CK_Workflows__ToState] CHECK ([ToState] IN (N'Void', N'Requested', N'Rejected', N'Authorized', N'Failed', N'Completed', N'Invalid', N'Posted')),
	CONSTRAINT [FK_Workflows__CreatedById] FOREIGN KEY ([CreatedById]) REFERENCES [dbo].[LocalUsers] ([Id]),
	CONSTRAINT [FK_Workflows__RevokedById] FOREIGN KEY ([RevokedById]) REFERENCES [dbo].[LocalUsers] ([Id])
);