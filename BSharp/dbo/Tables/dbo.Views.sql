CREATE TABLE [dbo].[Views] (
	[TenantId]		INT,
	[Id]			NVARCHAR (255),
	[IsActive]		BIT					NOT NULL DEFAULT (1),
	[CreatedAt]		DATETIMEOFFSET(7)	NOT NULL,
	[CreatedById]	INT					NOT NULL,
	[ModifiedAt]	DATETIMEOFFSET(7)	NOT NULL, 
	[ModifiedById]	INT					NOT NULL,
	CONSTRAINT [PK_Views] PRIMARY KEY NONCLUSTERED ([TenantId] ASC, [Id] ASC),
	CONSTRAINT [FK_Views_CreatedById] FOREIGN KEY ([TenantId], [CreatedById]) REFERENCES [dbo].[LocalUsers] ([TenantId], [Id]),
	CONSTRAINT [FK_Views_ModifiedById] FOREIGN KEY ([TenantId], [ModifiedById]) REFERENCES [dbo].[LocalUsers] ([TenantId], [Id])
);