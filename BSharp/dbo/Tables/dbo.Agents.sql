CREATE TABLE [dbo].[Agents] (
    [Id]                      INT                NOT NULL,
    [AgentType]               NVARCHAR (50)      NOT NULL,
    [ShortName]               NVARCHAR (50)      NOT NULL,
    [LongName]                NVARCHAR (255)     NOT NULL,
    [IsRelated]               BIT                CONSTRAINT [DF_Agents_IsRelated] DEFAULT ((0)) NOT NULL,
    [UserId]                  NVARCHAR (450)     NULL,
    [TaxIdentificationNumber] NVARCHAR (50)      NULL,
    [RegisteredAddress]       NVARCHAR (255)     NULL,
    [Title]                   NVARCHAR (50)      NULL,
    [Gender]                  NCHAR (1)          NULL,
    [BirthDateTime]           DATETIMEOFFSET (7) NULL,
    [DeathDateTime]           DATETIMEOFFSET (7) NULL,
    CONSTRAINT [PK_Agents] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_Agents_AgentTypes] FOREIGN KEY ([AgentType]) REFERENCES [dbo].[AgentTypes] ([Id]),
    CONSTRAINT [FK_Agents_Custodies] FOREIGN KEY ([Id], [AgentType]) REFERENCES [dbo].[Custodies] ([Id], [CustodyType]) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT [FK_Agents_Users] FOREIGN KEY ([UserId]) REFERENCES [dbo].[Users] ([Id]) ON UPDATE CASCADE
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Agents__Id_AgentType]
    ON [dbo].[Agents]([Id] ASC, [AgentType] ASC);

