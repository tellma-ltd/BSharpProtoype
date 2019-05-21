CREATE TYPE [dbo].[ResourceList] AS TABLE (
	[Index]					INT				IDENTITY(0, 1),
	[Id]					INT,
	[ResourceType]				NVARCHAR (255)		NOT NULL,
	[Name]						NVARCHAR (255)		NOT NULL,
	[Name2]						NVARCHAR (255),
	[Name3]						NVARCHAR (255),
	[IsActive]					BIT					NOT NULL DEFAULT (1),
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
	[PartOfIndex]					INT, -- for compound assets
	[InstanceOfIndex]				INT, -- to allow contracts to be for higher level.
	[EntityState]			NVARCHAR (255)	NOT NULL DEFAULT(N'Inserted'),
	PRIMARY KEY ([Index] ASC),
	INDEX IX_ResourceList__Code ([Code]),
	CHECK ([EntityState] IN (N'Unchanged', N'Inserted', N'Updated', N'Deleted')),
	CHECK ([EntityState] <> N'Inserted' OR [Id] IS NULL)
);