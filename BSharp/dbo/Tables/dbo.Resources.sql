CREATE TABLE [dbo].[Resources] (
/*
	Money,
	Intangible [rights,..]
	Material/Good [RM, WIP, FG, ]
	PPE (Service)
	Biological
	Employee Job
*/
	[TenantId]					INT					DEFAULT CONVERT(INT, SESSION_CONTEXT(N'TenantId')),
	[Id]						INT					IDENTITY,
	[ResourceType]				NVARCHAR (255)		NOT NULL,
	[Name]						NVARCHAR (255)		NOT NULL,
	[Name2]						NVARCHAR (255),
	[Name3]						NVARCHAR (255),
	[IsActive]					BIT					NOT NULL DEFAULT 1,
-- IsFungible = 1 <=> ResourceNumber is REQUIRED in table TransactionEntries
-- IsFungible = 1 <=> ResourceNumber is OPTIONAL in table TemplateEntries, RequestEntries and PlanEntries
	[IsFungible]				BIT					NOT NULL DEFAULT 0,
-- IsBatch = 1 <=> BatchNumber is REQUIRED in table TransactionEntries
-- IsBatch = 1 <=> BatchNumber is OPTIONAL in table TemplateEntries, RequestEntries and PlanEntries
	[IsBatch]					BIT					NOT NULL DEFAULT 0,
	[ValueMeasure]				NVARCHAR (255) NOT NULL, -- Currency, Mass, Volumne, Length, Count, Time, 
	[UnitId]					INT					NOT NULL,
	[CurrencyId]				INT, -- the unit If the resource has a financial meaure assigned to it.
	[MassUnitId]				INT, -- the unit If the resource has a mass measure assigned to it.
	[MassRate]					DECIMAL,
	[VolumeUnitId]				INT,			-- FK, Table Units
	[VolumeRate]				DECIMAL,
	[LengthUnitId]				INT,			-- FK, Table Units
	[CountUnitId]				INT,			-- FK, Table Units
	[TimeUnitId]				INT,			-- FK, Table Units
	--[Source]					NVARCHAR (255), -- Lease In/Acquisition/Production
	--[Purpose]					NVARCHAR (255), -- Lease out/Sale/Production/SG&A
	[Code]						NVARCHAR (255),
 -- functional currency, common stock, basic, allowance, overtime/types, 
	[SystemCode]				NVARCHAR (255),
	[Memo]						NVARCHAR (2048),
	[Reference]					NVARCHAR (255), -- UPC
	[RelatedReference]			NVARCHAR (255),
	[RelatedAgentId]			INT,			-- FK, Table Agents
	[RelatedResourceId]			INT,			-- FK, Table Resources
	[RelatedMeasurementUnitId]	INT,			-- FK, Table Measurements Units
	[RelatedAmount]				INT,
	[RelatedDateTime]			DATETIMEOFFSET (7),
	-- The following properties are user-defined, used for reporting
	[Lookup1Id]					INT,			-- UDL 
	[Lookup2Id]					INT,			-- UDL 
	[Lookup3Id]					INT,			-- UDL 
	[Lookup4Id]					INT,			-- UDL 
	[PartOfId]					INT, -- for compound assets
	[InstanceOfId]				INT, -- to allow contracts to be for higher level.
	--[ServiceOfId]				INT, -- to relate services to their assets.
	[CreatedAt]					DATETIMEOFFSET(7)	NOT NULL DEFAULT SYSDATETIMEOFFSET(),
	[CreatedById]				INT					NOT NULL DEFAULT CONVERT(INT, SESSION_CONTEXT(N'UserId')),
	[ModifiedAt]				DATETIMEOFFSET(7)	NOT NULL DEFAULT SYSDATETIMEOFFSET(),
	[ModifiedById]				INT					NOT NULL DEFAULT CONVERT(INT, SESSION_CONTEXT(N'UserId')),
	CONSTRAINT [PK_Resources] PRIMARY KEY CLUSTERED ([TenantId], [Id]),
	--CONSTRAINT [CK_Resources_Source] CHECK ([Source] IN (N'LeaseIn', N'Acquisition', N'Production')),
	--CONSTRAINT [CK_Resources_Purpose] CHECK ([Purpose] IN (N'LeaseOut', N'Sale', N'Production', N'Selling', N'GeneralAndAdministrative')),
	CONSTRAINT [FK_Resources__MeasurementUnit] FOREIGN KEY ([TenantId], [MassUnitId]) REFERENCES [dbo].[MeasurementUnits] ([TenantId], [Id]) ON UPDATE CASCADE,
	CONSTRAINT [FK_Resources__Resources_PartOfId] FOREIGN KEY ([TenantId], [PartOfId]) REFERENCES [dbo].[Resources] ([TenantId], [Id]) ON DELETE NO ACTION,
	CONSTRAINT [FK_Resources__Resources_InstanceOfId] FOREIGN KEY ([TenantId], [InstanceOfId]) REFERENCES [dbo].[Resources] ([TenantId], [Id]) ON DELETE NO ACTION,
	--CONSTRAINT [FK_Resources_Resources_ServiceOfId] FOREIGN KEY ([TenantId], [ServiceOfId]) REFERENCES [dbo].[Resources] ([TenantId], [Id]) ON DELETE NO ACTION,
);
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Resources__Name]
  ON [dbo].[Resources]([TenantId], [Name]);
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Resources__Name2]
  ON [dbo].[Resources]([TenantId], [Name2]) WHERE [Name2] IS NOT NULL;
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Resources__Name3]
  ON [dbo].[Resources]([TenantId], [Name3]) WHERE [Name3] IS NOT NULL;
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Resources__Code]
  ON [dbo].[Resources]([TenantId], [Code]) WHERE [Code] IS NOT NULL;
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Resources__SystemCode]
  ON [dbo].[Resources]([TenantId], [SystemCode]) WHERE [SystemCode] IS NOT NULL;
GO
ALTER TABLE [dbo].[Resources] ADD CONSTRAINT [CK_Resources__UnitId] CHECK (
	[UnitId] = (
		CASE
			WHEN [ValueMeasure] = N'Currency' THEN [CurrencyId]
			WHEN [ValueMeasure] = N'Mass' THEN [MassUnitId]
			WHEN [ValueMeasure] = N'Volume' THEN [VolumeUnitId]
			WHEN [ValueMeasure] = N'Length' THEN [LengthUnitId]
			WHEN [ValueMeasure] = N'Count' THEN [CountUnitId]
		END
	)
)
GO