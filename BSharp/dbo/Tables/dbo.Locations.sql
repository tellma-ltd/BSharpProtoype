CREATE TABLE [dbo].[Locations] (
	[TenantId]				 INT				NOT NULL,
    [Id]           INT           NOT NULL,
    [LocationType] NVARCHAR (50) NOT NULL,
    [Address]      NVARCHAR (50) NULL,
    [Parent]       INT           NULL,
    [CustodianId]    INT           NULL,
    CONSTRAINT [PK_Locations] PRIMARY KEY CLUSTERED ([TenantId] ASC, [Id] ASC),
    CONSTRAINT [FK_Locations_Agents] FOREIGN KEY ([TenantId], [CustodianId]) REFERENCES [dbo].[Agents] ([TenantId], [Id]),
    CONSTRAINT [FK_Locations_Custodies] FOREIGN KEY ([TenantId], [Id], [LocationType]) REFERENCES [dbo].[Custodies] ([TenantId], [Id], [CustodyType]) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT [FK_Locations_LocationTypes] FOREIGN KEY ([LocationType]) REFERENCES [dbo].[LocationTypes] ([Id]) ON UPDATE CASCADE
);

