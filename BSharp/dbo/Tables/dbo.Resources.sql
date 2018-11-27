CREATE TABLE [dbo].[Resources] (
	[TenantId]			INT,
    [Id]				INT		IDENTITY (1, 1),
    [ResourceType]		NVARCHAR (50)  NOT NULL,
    [Name]				NVARCHAR (50)  NOT NULL,
    [UnitOfMeasure]		NVARCHAR (5)   NOT NULL,
    [Code]				NVARCHAR (50),
    [Memo]				NVARCHAR (2048),
    [Lookup1]			NVARCHAR (50),
    [Lookup2]			NVARCHAR (50),
    [Lookup3]			NVARCHAR (50),
    [Lookup4]			NVARCHAR (50),
    [PartOf]			INT, -- for compound assets
    [FungibleParentId]	INT,
    CONSTRAINT [PK_Resources] PRIMARY KEY CLUSTERED ([TenantId] ASC, [Id] ASC),
    CONSTRAINT [FK_Resources_UnitsOfMeasure] FOREIGN KEY ([TenantId], [UnitOfMeasure]) REFERENCES [dbo].[UnitsOfMeasure] ([TenantId], [Id]) ON UPDATE CASCADE,
	CONSTRAINT [FK_Resources_Resources_FungibleParent] FOREIGN KEY ([TenantId], [FungibleParentId]) REFERENCES [dbo].[Resources] ([TenantId], [Id]) ON DELETE NO ACTION,
	CONSTRAINT [FK_Resources_Resources_PartOf] FOREIGN KEY ([TenantId], [PartOf]) REFERENCES [dbo].[Resources] ([TenantId], [Id]) ON DELETE NO ACTION
);

