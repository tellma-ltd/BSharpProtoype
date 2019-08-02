CREATE TABLE [dbo].[DocumentSignatures] (
-- After each sign/revoke, the system recalculates the new Document state, based on the workflow and account rules
-- Redundant signatures (where actor/role is not specified in the workflow or the accounts) are discarded
-- Duplicate last signatures are discarded.
-- The signatures can only be revoked in the reverse order they were made in
-- A signature can only be removed by the signatiry or by an IT administrator
	[Id]						UNIQUEIDENTIFIER PRIMARY KEY,
	[DocumentId]				UNIQUEIDENTIFIER	NOT NULL,
	
	[State]						NVARCHAR (255)		NOT NULL,
	[ReasonId]					UNIQUEIDENTIFIER,	-- Especially important for states: Rejected/Failed/Declined.
	[ReasonDetails]				NVARCHAR(1024),		-- especially useful when Reason Id = Other.
	-- For a source document, SignedAt = Now(). For a copy, it is manually entered.
	[SignedAt]					DATETIMEOFFSET(7)	NOT NULL DEFAULT SYSDATETIMEOFFSET(),
	-- For a source document, ActorId is the userId. Else, it is editable.
	[AgentId]					UNIQUEIDENTIFIER	NOT NULL DEFAULT CONVERT(UNIQUEIDENTIFIER, SESSION_CONTEXT(N'UserId')),
	-- Role Id is selected from a choice list of the actor's roles of the actor that are compatible with workflow
	[RoleId]					UNIQUEIDENTIFIER,

	[CreatedAt]					DATETIMEOFFSET(7)	NOT NULL DEFAULT SYSDATETIMEOFFSET(),
	[CreatedById]				UNIQUEIDENTIFIER	NOT NULL DEFAULT CONVERT(UNIQUEIDENTIFIER, SESSION_CONTEXT(N'UserId')),
	
	[RevokedAt]					DATETIMEOFFSET(7),
	[RevokedById]				UNIQUEIDENTIFIER,

	CONSTRAINT [FK_DocumentSignatures__Documents] FOREIGN KEY ([DocumentId]) REFERENCES [dbo].[Documents] ([Id]) ON DELETE CASCADE,
	CONSTRAINT [CK_DocumentSignatures__State] CHECK ([State] IN (N'Void', N'Requested', N'Rejected', N'Authorized', N'Failed', N'Completed', N'Invalid', N'Posted')),
	CONSTRAINT [FK_DocumentSignatures__AgentId] FOREIGN KEY ([AgentId]) REFERENCES [dbo].[Agents] ([Id]),
	CONSTRAINT [FK_DocumentSignatures__CreatedById] FOREIGN KEY ([CreatedById]) REFERENCES [dbo].[LocalUsers] ([Id]),
	CONSTRAINT [FK_DocumentSignatures__RevokedById] FOREIGN KEY ([RevokedById]) REFERENCES [dbo].[LocalUsers] ([Id])
);
GO
CREATE INDEX [IX_DocumentSignatures__DocumentId] ON [dbo].[DocumentSignatures]([DocumentId]);
GO