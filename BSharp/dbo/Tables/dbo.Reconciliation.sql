CREATE TABLE [dbo].[Reconciliation] (
	[TenantId]		INT,
	[Id]			INT					IDENTITY,
	[EntryId1]		INT					NOT NULL,
	[EntryId2]		INT					NOT NULL,
	[Amount]		MONEY				NOT NULL,
	[CreatedAt]		DATETIMEOFFSET(7)	NOT NULL,
	[CreatedById]	INT					NOT NULL,
	CONSTRAINT [PK_Reconciliation] PRIMARY KEY CLUSTERED ([TenantId] ASC, [Id] ASC)
);
-- Add Foreign keys to table entries and indexes as well