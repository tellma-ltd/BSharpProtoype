CREATE TABLE [dbo].[Users] (
	[Id]				NVARCHAR (450) NOT NULL,
	[FriendlyName]		NVARCHAR (255)  NOT NULL,
	[PreferredLanguage] NCHAR(2) NOT NULL DEFAULT (N'EN'), 
	[ProfilePhoto]		VARBINARY (MAX) NULL,
	CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED ([Id] ASC)
);

