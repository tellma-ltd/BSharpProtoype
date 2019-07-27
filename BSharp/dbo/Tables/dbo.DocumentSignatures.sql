CREATE TABLE [dbo].[DocumentSignatures] (
-- After each sign/revoke, the system recalculates the new Document state, based on the workflow and account rules
-- Redundant signatures (where actor/role is not specified in the workflow or the accounts) are discarded
-- Duplicate last signatures are discarded.
-- The signatures can only be revoked in the reverse order they were made in
-- A signature can only be removed by the signatiry or by an IT administrator
	[TenantId]		INT					DEFAULT CONVERT(INT, SESSION_CONTEXT(N'TenantId')),
	[Id]			INT IDENTITY,
	[DocumentId]	INT					NOT NULL,
	
	[State]						NVARCHAR (255)		NOT NULL,
	[ReasonId]					INT,				-- Especially important for states: Rejected/Failed/Declined.
	[ReasonDetails]				NVARCHAR(1024),		-- especially useful when Reason Id = Other.
	-- For a source document, SignedAt = Now(). For a copy, it is manually entered.
	[SignedAt]					DATETIMEOFFSET(7)	NOT NULL DEFAULT SYSDATETIMEOFFSET(),
	-- For a source document, ActorId is the userId. Else, it is editable.
	[ActorId]					INT					NOT NULL DEFAULT CONVERT(INT, SESSION_CONTEXT(N'UserId')),
	-- Role Id is selected from a choice list of the actor's roles of the actor that are compatible with workflow
	[RoleId]					INT,

	[CreatedAt]					DATETIMEOFFSET(7)	NOT NULL DEFAULT SYSDATETIMEOFFSET(),
	[CreatedById]				INT					NOT NULL DEFAULT CONVERT(INT, SESSION_CONTEXT(N'UserId')),
	
	[RevokedAt]					DATETIMEOFFSET(7),
	[RevokedById]				INT,

	CONSTRAINT [PK_DocumentSignatures] PRIMARY KEY CLUSTERED ([TenantId] ASC, [Id] ASC),
	CONSTRAINT [FK_DocumentSignatures__Documents] FOREIGN KEY ([TenantId], [DocumentId]) REFERENCES [dbo].[Documents] ([TenantId], [Id]) ON DELETE CASCADE,
	CONSTRAINT [CK_DocumentSignatures__State] CHECK ([State] IN (N'Void', N'Requested', N'Rejected', N'Authorized', N'Failed', N'Completed', N'Invalid', N'Posted')),
	CONSTRAINT [FK_DocumentSignatures__ActorId] FOREIGN KEY ([TenantId], [ActorId]) REFERENCES [dbo].[Agents] ([TenantId], [Id]),
	CONSTRAINT [FK_DocumentSignatures__CreatedById] FOREIGN KEY ([TenantId], [CreatedById]) REFERENCES [dbo].[LocalUsers] ([TenantId], [Id]),
	CONSTRAINT [FK_DocumentSignatures__RevokedById] FOREIGN KEY ([TenantId], [RevokedById]) REFERENCES [dbo].[LocalUsers] ([TenantId], [Id])
);
GO
CREATE INDEX [IX_DocumentSignatures__DocumentId] ON [dbo].[DocumentSignatures]([TenantId], [DocumentId]);
GO