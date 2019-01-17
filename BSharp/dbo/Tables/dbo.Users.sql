CREATE TABLE [dbo].[Users] (
	[TenantId]			INT,
	[Id]				NVARCHAR (450) NOT NULL,
	[FriendlyName]		NVARCHAR (255)  NOT NULL,
	[PreferredLanguage] NCHAR(2) NOT NULL DEFAULT (N'EN'), 
	[ProfilePhoto]		VARBINARY (MAX) NULL,
	CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED ([TenantId] ASC, [Id] ASC)
);

