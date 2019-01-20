CREATE TABLE [dbo].[Views] (
	[TenantId]			INT,
	[Id]				NVARCHAR (255),
	[IsActive]			BIT					NOT NULL DEFAULT(0),
	[CreatedAt]			DATETIMEOFFSET(7)	NOT NULL,
	[CreatedBy]			NVARCHAR(450)		NOT NULL,
	[ModifiedAt]		DATETIMEOFFSET(7)	NOT NULL, 
	[ModifiedBy]		NVARCHAR(450)		NOT NULL,
	CONSTRAINT [PK_Views] PRIMARY KEY NONCLUSTERED ([TenantId] ASC, [Id] ASC),
	CONSTRAINT [FK_Views_CreatedBy] FOREIGN KEY ([TenantId], [CreatedBy]) REFERENCES [dbo].[Users] ([TenantId], [Id]),
	CONSTRAINT [FK_Views_ModifiedBy] FOREIGN KEY ([TenantId], [ModifiedBy]) REFERENCES [dbo].[Users] ([TenantId], [Id])
);