CREATE TABLE [dbo].[Agents] (
	[TenantId]				 INT				NOT NULL,
    [Id]                      INT                NOT NULL,
    [AgentType]               NVARCHAR (50)      NOT NULL,
    [IsRelated]               BIT                CONSTRAINT [DF_Agents_IsRelated] DEFAULT ((0)) NOT NULL,
    [UserId]                  NVARCHAR (450)     NULL,
    [TaxIdentificationNumber] NVARCHAR (50)      NULL,
    [RegisteredAddress]       NVARCHAR (255)     NULL,
    [Title]                   NVARCHAR (50)      NULL,
    [Gender]                  NCHAR (1)          NULL,
    [BirthDateTime]           DATETIMEOFFSET (7) NULL,
    CONSTRAINT [PK_Agents] PRIMARY KEY CLUSTERED ([TenantId] ASC, [Id] ASC),
    CONSTRAINT [FK_Agents_AgentTypes] FOREIGN KEY ([AgentType]) REFERENCES [dbo].[AgentTypes] ([Id]),
    CONSTRAINT [FK_Agents_Custodies] FOREIGN KEY ([TenantId], [Id], [AgentType]) REFERENCES [dbo].[Custodies] ([TenantId], [Id], [CustodyType]) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT [FK_Agents_Users] FOREIGN KEY ([UserId]) REFERENCES [dbo].[Users] ([Id]) ON UPDATE CASCADE
);
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Agents__Id_AgentType]
    ON [dbo].[Agents]([Id] ASC, [AgentType] ASC);
