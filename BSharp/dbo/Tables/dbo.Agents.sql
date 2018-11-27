CREATE TABLE [dbo].[Agents] (
	[TenantId]					INT,
    [Id]						INT,
    [AgentType]					NVARCHAR (50)      NOT NULL,
    [IsRelated]					BIT                NOT NULL CONSTRAINT [DF_Agents_IsRelated] DEFAULT (0),
    [UserId]					NVARCHAR (450),
    [TaxIdentificationNumber]	NVARCHAR (50),
    [RegisteredAddress]			NVARCHAR (255),
    [Title]						NVARCHAR (50),
    [Gender]					NCHAR (1),
    [BirthDateTime]				DATETIMEOFFSET (7),
    CONSTRAINT [PK_Agents] PRIMARY KEY CLUSTERED ([TenantId] ASC, [Id] ASC),
    CONSTRAINT [FK_Agents_Custodies] FOREIGN KEY ([TenantId], [Id], [AgentType]) REFERENCES [dbo].[Custodies] ([TenantId], [Id], [CustodyType]) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT [FK_Agents_Users] FOREIGN KEY ([UserId]) REFERENCES [dbo].[Users] ([Id]) ON UPDATE CASCADE,
	CONSTRAINT [CK_Agents_AgentType] CHECK ([AgentType] IN (N'Individual', N'Organization', N'OrganizationUnit'))
);
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Agents__Id_AgentType]
    ON [dbo].[Agents]([Id] ASC, [AgentType] ASC);
