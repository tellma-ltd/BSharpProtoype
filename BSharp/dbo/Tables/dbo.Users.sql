CREATE TABLE [dbo].[Users] (
	[TenantId]			INT,
	[Id]				NVARCHAR (450),
	[Name]				NVARCHAR (255)	NOT NULL,
	[Name2]				NVARCHAR (255),
	[PreferredLanguage] NCHAR(2)		NOT NULL DEFAULT (N'en'), 
	[ProfilePhoto]		VARBINARY (MAX),
	CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED ([TenantId] ASC, [Id] ASC)
);