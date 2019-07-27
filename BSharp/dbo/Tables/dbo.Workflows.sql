CREATE TABLE [dbo].[Workflows] (
	[TenantId]		INT					DEFAULT CONVERT(INT, SESSION_CONTEXT(N'TenantId')),
	[Id]			INT IDENTITY,
	[DocumentTypeId]NVARCHAR (255)		NOT NULL,
	[FromState]		NVARCHAR (255)		NOT NULL,
	[ToState]		NVARCHAR (255)		NOT NULL,

	[CreatedAt]		DATETIMEOFFSET(7)	NOT NULL DEFAULT SYSDATETIMEOFFSET(),
	[CreatedById]	INT					NOT NULL DEFAULT CONVERT(INT, SESSION_CONTEXT(N'UserId')),
	
	[RevokedAt]		DATETIMEOFFSET(7),
	[RevokedById]	INT,
	CONSTRAINT [PK_Workflows] PRIMARY KEY CLUSTERED ([TenantId] ASC, [Id] ASC),
	CONSTRAINT [FK_Workflows__DocumentTypes] FOREIGN KEY ([TenantId], [DocumentTypeId]) REFERENCES [dbo].[DocumentTypes] ([TenantId], [Id]) ON DELETE CASCADE,
	CONSTRAINT [CK_Workflows__FromState] CHECK ([FromState] IN (N'Void', N'Requested', N'Rejected', N'Authorized', N'Failed', N'Completed', N'Invalid', N'Posted')),
	CONSTRAINT [CK_Workflows__ToState] CHECK ([ToState] IN (N'Void', N'Requested', N'Rejected', N'Authorized', N'Failed', N'Completed', N'Invalid', N'Posted')),
	CONSTRAINT [FK_Workflows__CreatedById] FOREIGN KEY ([TenantId], [CreatedById]) REFERENCES [dbo].[LocalUsers] ([TenantId], [Id]),
	CONSTRAINT [FK_Workflows__RevokedById] FOREIGN KEY ([TenantId], [RevokedById]) REFERENCES [dbo].[LocalUsers] ([TenantId], [Id])
);