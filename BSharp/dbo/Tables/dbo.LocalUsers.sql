CREATE TABLE [dbo].[LocalUsers] (
	[Id]				INT	PRIMARY KEY NONCLUSTERED,
	[Name]				NVARCHAR (255)		NOT NULL,
	[Name2]				NVARCHAR (255),
	[Name3]				NVARCHAR (255),
	[PreferredLanguage] NCHAR(2)			NOT NULL DEFAULT (N'en'), 
	[ProfilePhoto]		VARBINARY (MAX),
	[AgentId]			INT,
	[SortKey]			DECIMAL (9,4),
	CONSTRAINT [FK_LocalUsers_Agents] FOREIGN KEY ([AgentId]) REFERENCES [dbo].[Agents] ([Id]) ON UPDATE CASCADE,
);
GO
CREATE CLUSTERED INDEX [IX_LocalUsers__TenantId_SortKey]
  ON [dbo].[LocalUsers]([SortKey]);
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Users__Name]
  ON [dbo].[LocalUsers]([Name]);
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Users__Name2]
  ON [dbo].[LocalUsers]([Name2]) WHERE [Name2] IS NOT NULL;
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Users__Name3]
  ON [dbo].[LocalUsers]([Name3]) WHERE [Name3] IS NOT NULL;
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Users__AgentId]
  ON [dbo].[LocalUsers]([AgentId]) WHERE [AgentId] IS NOT NULL;
GO