CREATE TABLE [dbo].[LocalUsers] (
	[TenantId]			INT							DEFAULT CONVERT(INT, SESSION_CONTEXT(N'TenantId')),
	[Id]				INT				IDENTITY(1,1),
	[Name]				NVARCHAR (255)	NOT NULL,
	[Name2]				NVARCHAR (255),
	[Name3]				NVARCHAR (255),
	[PreferredLanguage] NCHAR(2)		NOT NULL DEFAULT (N'en'), 
	[ProfilePhoto]		VARBINARY (MAX),
	[AgentId]			INT,
	CONSTRAINT [PK_LocalUsers] PRIMARY KEY CLUSTERED ([TenantId] ASC, [Id] ASC),
	CONSTRAINT [FK_LocalUsers_Agents] FOREIGN KEY ([TenantId], [AgentId]) REFERENCES [dbo].[Agents] ([TenantId], [Id]) ON UPDATE CASCADE,
);
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Users__Name]
  ON [dbo].[LocalUsers]([TenantId] ASC, [Name] ASC);
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Users__Name2]
  ON [dbo].[LocalUsers]([TenantId] ASC, [Name2] ASC) WHERE [Name2] IS NOT NULL;
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Users__Name3]
  ON [dbo].[LocalUsers]([TenantId] ASC, [Name3] ASC) WHERE [Name3] IS NOT NULL;
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Users__AgentId]
  ON [dbo].[LocalUsers]([TenantId] ASC, [AgentId] ASC) WHERE [AgentId] IS NOT NULL;
GO