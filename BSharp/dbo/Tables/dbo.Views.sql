CREATE TABLE [dbo].[Views] (
	[TenantId]				INT,
	[Id]					NVARCHAR (255),
	[IsActive]				BIT				NOT NULL
	CONSTRAINT [PK_Views] PRIMARY KEY NONCLUSTERED ([TenantId] ASC, [Id] ASC)
);