CREATE TABLE [dbo].[Resources] (
	[TenantId]			INT,
    [Id]				INT		IDENTITY (1, 1),
    [MeasurementUnitId]	INT				NOT NULL,
    [ResourceType]		NVARCHAR (255)  NOT NULL,
    [Name]				NVARCHAR (255)  NOT NULL,
	[IsActive]			BIT				NOT NULL CONSTRAINT [DF_Resources_IsActive] DEFAULT (1),
	[Source]			NVARCHAR (255), -- Lease In/Acquisition/Production
	[Purpose]			NVARCHAR (255), -- Lease out/Sale/Production/SG&A
    [Code]				NVARCHAR (255),
    [Memo]				NVARCHAR (2048),
    [Lookup1]			NVARCHAR (255),
    [Lookup2]			NVARCHAR (255),
    [Lookup3]			NVARCHAR (255),
    [Lookup4]			NVARCHAR (255),
    [PartOf]			INT, -- for compound assets
    [FungibleParentId]	INT,
    CONSTRAINT [PK_Resources] PRIMARY KEY CLUSTERED ([TenantId] ASC, [Id] ASC),
    CONSTRAINT [FK_Resources_MeasurementUnit] FOREIGN KEY ([TenantId], [MeasurementUnitId]) REFERENCES [dbo].[MeasurementUnits] ([TenantId], [Id]) ON UPDATE CASCADE,
	CONSTRAINT [FK_Resources_Resources_FungibleParent] FOREIGN KEY ([TenantId], [FungibleParentId]) REFERENCES [dbo].[Resources] ([TenantId], [Id]) ON DELETE NO ACTION,
	CONSTRAINT [FK_Resources_Resources_PartOf] FOREIGN KEY ([TenantId], [PartOf]) REFERENCES [dbo].[Resources] ([TenantId], [Id]) ON DELETE NO ACTION
);

