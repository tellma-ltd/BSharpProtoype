CREATE TABLE [dbo].[Views] (
	[TenantId]		INT,
	[Id]			NVARCHAR (255),
	[IsActive]		BIT					NOT NULL DEFAULT (1),
	[CreatedAt]		DATETIMEOFFSET(7)	NOT NULL,
	[CreatedBy]		INT					NOT NULL,
	[ModifiedAt]	DATETIMEOFFSET(7)	NOT NULL, 
	[ModifiedBy]	INT					NOT NULL,
	CONSTRAINT [PK_Views] PRIMARY KEY NONCLUSTERED ([TenantId] ASC, [Id] ASC),
	CONSTRAINT [FK_Views_CreatedBy] FOREIGN KEY ([TenantId], [CreatedBy]) REFERENCES [dbo].[LocalUsers] ([TenantId], [Id]),
	CONSTRAINT [FK_Views_ModifiedBy] FOREIGN KEY ([TenantId], [ModifiedBy]) REFERENCES [dbo].[LocalUsers] ([TenantId], [Id])
);