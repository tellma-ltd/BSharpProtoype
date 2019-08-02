CREATE TYPE [dbo].[ResourceList] AS TABLE (
	[Index]						INT				IDENTITY(0, 1),
	[Id]						UNIQUEIDENTIFIER NOT NULL DEFAULT NEWSEQUENTIALID(),
	[ResourceType]				NVARCHAR (255)		NOT NULL,
	[Name]						NVARCHAR (255)		NOT NULL,
	[Name2]						NVARCHAR (255),
	[Name3]						NVARCHAR (255),
	[IsFungible]				BIT					NOT NULL DEFAULT 1,
	[IsBatch]					BIT					NOT NULL DEFAULT 0,
	[ValueMeasure]				NVARCHAR (255) NOT NULL, -- Currency, Mass, Volumne, Length, Count, Time, 
	[UnitId]					UNIQUEIDENTIFIER					NOT NULL,
	[CurrencyId]				UNIQUEIDENTIFIER,			-- the unit If the resource has a financial meaure assigned to it.
	[UnitPrice]					DECIMAL,		-- if not null, it specifies the Cost per Unit
	[MassUnitId]				UNIQUEIDENTIFIER,			-- the unit If the resource has a mass measure assigned to it.
	[UnitMass]					DECIMAL,		-- if not null, it specifies the conversion rate Mass/Count
	[VolumeUnitId]				UNIQUEIDENTIFIER,			-- FK, Table Units
	[UnitVolume]				DECIMAL,		-- if not null, it specifies the conversion rate Volume/Count
	[AreaUnitId]				UNIQUEIDENTIFIER,			-- FK, Table Units
	[UnitArea]					DECIMAL,		-- if not null, it specifies the conversion rate Area/Count
	[LengthUnitId]				UNIQUEIDENTIFIER,			-- FK, Table Units
	[UnitLength]				DECIMAL,		-- if not null, it specifies the conversion rate Length/Count
	[TimeUnitId]				UNIQUEIDENTIFIER,			-- FK, Table Units
	[UnitTime]					DECIMAL,		-- if not null, it specifies the conversion rate Time/Count
	[CountUnitId]				UNIQUEIDENTIFIER,			-- FK, Table Units
	[Code]						NVARCHAR (255),
 -- functional currency, common stock, basic, allowance, overtime/types, 
	[SystemCode]				NVARCHAR (255),
	[Memo]						NVARCHAR (2048), -- description
	[CustomsReference]			NVARCHAR (255), -- how it is referred to by Customs
	[UniversalProductCode]		NVARCHAR (255), -- for barcode readers
	[PreferredSupplierId]		UNIQUEIDENTIFIER,			-- FK, Table Agents, specially for purchasing
	-- The following properties are user-defined, used for reporting
	[ResourceLookup1Id]			UNIQUEIDENTIFIER,			-- UDL 
	[ResourceLookup2Id]			UNIQUEIDENTIFIER,			-- UDL 
	[ResourceLookup3Id]			UNIQUEIDENTIFIER,			-- UDL 
	[ResourceLookup4Id]			UNIQUEIDENTIFIER,			-- UDL 
	[EntityState]			NVARCHAR (255)	NOT NULL DEFAULT(N'Inserted'),
	PRIMARY KEY ([Index]),
	INDEX IX_ResourceList__Code ([Code]),
	CHECK ([EntityState] IN (N'Unchanged', N'Inserted', N'Updated', N'Deleted'))
);