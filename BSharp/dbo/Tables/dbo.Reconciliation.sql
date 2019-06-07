CREATE TABLE [dbo].[Reconciliation] (
	[TenantId]		INT					DEFAULT CONVERT(INT, SESSION_CONTEXT(N'TenantId')),
	[Id]			INT					IDENTITY,
	[EntryId1]		INT					NOT NULL,
	[EntryId2]		INT					NOT NULL,
	[Amount]		MONEY				NOT NULL,
	[CreatedAt]		DATETIMEOFFSET(7)	NOT NULL DEFAULT SYSDATETIMEOFFSET(),
	[CreatedById]	INT					NOT NULL DEFAULT CONVERT(INT, SESSION_CONTEXT(N'UserId')),
	CONSTRAINT [PK_Reconciliation] PRIMARY KEY CLUSTERED ([TenantId] ASC, [Id] ASC),
	CONSTRAINT [CK_Reconciliation__Amount] CHECK ([Amount] <> 0)
);
-- TODO: Add Foreign keys to table entries and indexes as well