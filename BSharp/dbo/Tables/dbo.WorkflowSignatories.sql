CREATE TABLE [dbo].[WorkflowSignatories] (
	[Id]			UNIQUEIDENTIFIER PRIMARY KEY,
	-- All roles are needed to get to next positive state, one is enough to get to negative state
	[RoleId]		UNIQUEIDENTIFIER,

	[CreatedAt]		DATETIMEOFFSET(7)	NOT NULL DEFAULT SYSDATETIMEOFFSET(),
	[CreatedById]	UNIQUEIDENTIFIER	NOT NULL DEFAULT CONVERT(UNIQUEIDENTIFIER, SESSION_CONTEXT(N'UserId')),
	
	[RevokedAt]		DATETIMEOFFSET(7),
	[RevokedById]	UNIQUEIDENTIFIER,
	CONSTRAINT [FK_WorkflowSignatories__RoleId] FOREIGN KEY ([RoleId]) REFERENCES [dbo].[Roles] ([Id]),
	CONSTRAINT [FK_WorkflowSignatories__CreatedById] FOREIGN KEY ([CreatedById]) REFERENCES [dbo].[LocalUsers] ([Id]),
	CONSTRAINT [FK_WorkflowSignatories__RevokedById] FOREIGN KEY ([RevokedById]) REFERENCES [dbo].[LocalUsers] ([Id])
);