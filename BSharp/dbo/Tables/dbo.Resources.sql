CREATE TABLE [dbo].[Resources] (
/*
	Money,
	Intangible [rights,..]
	Material/Good [RM, WIP, FG, ]
	PPE (Service)
	Biological
	Employee Job
*/
	[TenantId]					INT,
	[Id]						INT					IDENTITY,
	[ResourceType]				NVARCHAR (255)		NOT NULL,
	[Name]						NVARCHAR (255)		NOT NULL,
	[Name2]						NVARCHAR (255),
	[Name3]						NVARCHAR (255),
	[IsActive]					BIT					NOT NULL DEFAULT (1),
	[ValueMeasure]				NVARCHAR (255) NOT NULL, -- Currency, Mass, Volumne, Length, Count, Time, 
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
	[CreatedAt]					DATETIMEOFFSET(7)	NOT NULL,
	[CreatedById]				INT		NOT NULL,
	[ModifiedAt]				DATETIMEOFFSET(7)	NOT NULL, 
	[ModifiedById]				INT		NOT NULL,
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
ALTER TABLE [dbo].[Resources] ADD CONSTRAINT [DF_Resources__TenantId]  DEFAULT (CONVERT(INT, SESSION_CONTEXT(N'TenantId'))) FOR [TenantId];
GO
ALTER TABLE [dbo].[Resources] ADD CONSTRAINT [DF_Resources__CreatedAt]  DEFAULT (SYSDATETIMEOFFSET()) FOR [CreatedAt];
GO
ALTER TABLE [dbo].[Resources] ADD CONSTRAINT [DF_Resources__CreatedById]  DEFAULT (CONVERT(INT,SESSION_CONTEXT(N'UserId'))) FOR [CreatedById]
GO
ALTER TABLE [dbo].[Resources] ADD CONSTRAINT [DF_Resources__ModifiedAt]  DEFAULT (SYSDATETIMEOFFSET()) FOR [ModifiedAt];
GO
ALTER TABLE [dbo].[Resources] ADD CONSTRAINT [DF_Resources__ModifiedById]  DEFAULT (CONVERT(INT,SESSION_CONTEXT(N'UserId'))) FOR [ModifiedById]
GO