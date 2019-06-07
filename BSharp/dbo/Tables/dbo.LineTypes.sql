CREATE TABLE [dbo].[LineTypes] (
	[TenantId]		INT							DEFAULT CONVERT(INT, SESSION_CONTEXT(N'TenantId')),	[Id]			NVARCHAR (255) NOT NULL,
	[Description]	NVARCHAR (255),
	[Description2]	NVARCHAR (255),
	[Description3]	NVARCHAR (255),
	CONSTRAINT [PK_LineTypes] PRIMARY KEY CLUSTERED ([TenantId] ASC, [Id] ASC)
);