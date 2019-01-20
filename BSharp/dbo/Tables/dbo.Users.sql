CREATE TABLE [dbo].[Users] (
	[TenantId]			INT,
	[Id]				NVARCHAR (450),
	[Name]				NVARCHAR (255)	NOT NULL,
	[Name2]				NVARCHAR (255),
	[PreferredLanguage] NCHAR(2)		NOT NULL DEFAULT (N'en'), 
	[ProfilePhoto]		VARBINARY (MAX),
	[AgentId]			INT,
	CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED ([TenantId] ASC, [Id] ASC),
	CONSTRAINT [FK_Users_Agents] FOREIGN KEY ([TenantId], [AgentId]) REFERENCES [dbo].[Custodies] ([TenantId], [Id]) ON UPDATE CASCADE,
);
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Users__Name]
  ON [dbo].[Users]([TenantId] ASC, [Name] ASC);
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Users__Name2]
  ON [dbo].[Users]([TenantId] ASC, [Name2] ASC) WHERE [Name2] IS NOT NULL;
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Users__AgentId]
  ON [dbo].[Users]([TenantId] ASC, [AgentId] ASC) WHERE [AgentId] IS NOT NULL;
GO