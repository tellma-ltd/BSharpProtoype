CREATE TABLE [dbo].[WorkflowSignatories] (
	[TenantId]		INT					DEFAULT CONVERT(INT, SESSION_CONTEXT(N'TenantId')),
	[Id]			INT IDENTITY,
	-- All roles are needed to get to next positive state, one is enough to get to negative state
	[RoleId]		INT,

	[CreatedAt]		DATETIMEOFFSET(7)	NOT NULL DEFAULT SYSDATETIMEOFFSET(),
	[CreatedById]	INT					NOT NULL DEFAULT CONVERT(INT, SESSION_CONTEXT(N'UserId')),
	
	[RevokedAt]		DATETIMEOFFSET(7),
	[RevokedById]	INT,
	CONSTRAINT [PK_WorkflowSignatories] PRIMARY KEY CLUSTERED ([TenantId] ASC, [Id] ASC),
	CONSTRAINT [FK_WorkflowSignatories__RoleId] FOREIGN KEY ([TenantId], [RoleId]) REFERENCES [dbo].[Roles] ([TenantId], [Id]),
	CONSTRAINT [FK_WorkflowSignatories__CreatedById] FOREIGN KEY ([TenantId], [CreatedById]) REFERENCES [dbo].[LocalUsers] ([TenantId], [Id]),
	CONSTRAINT [FK_WorkflowSignatories__RevokedById] FOREIGN KEY ([TenantId], [RevokedById]) REFERENCES [dbo].[LocalUsers] ([TenantId], [Id])
);