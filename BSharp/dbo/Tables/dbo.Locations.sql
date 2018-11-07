CREATE TABLE [dbo].[Locations] (
    [Id]           INT           NOT NULL,
    [LocationType] NVARCHAR (50) NOT NULL,
    [Address]      NVARCHAR (50) NULL,
    [Parent]       INT           NULL,
    [Custodian]    INT           NULL,
    CONSTRAINT [PK_Locations] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_Locations_Agents] FOREIGN KEY ([Custodian]) REFERENCES [dbo].[Agents] ([Id]),
    CONSTRAINT [FK_Locations_Custodies] FOREIGN KEY ([Id], [LocationType]) REFERENCES [dbo].[Custodies] ([Id], [CustodyType]) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT [FK_Locations_LocationTypes] FOREIGN KEY ([LocationType]) REFERENCES [dbo].[LocationTypes] ([Id]) ON UPDATE CASCADE
);

