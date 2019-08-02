CREATE TABLE [dbo].[Plans] (
	[Id]						UNIQUEIDENTIFIER PRIMARY KEY,
	[Activity]					NVARCHAR(255), -- Sale, Production, Consumption, 
	[FromDate]					DATE				NOT NULL,
	[ToDate]					DATE				NOT NULL,
	[ResponsibilityCenterId]	UNIQUEIDENTIFIER	NOT NULL,
	[ResourceLookup1Id]			UNIQUEIDENTIFIER,			-- UDL 
	[ResourceLookup2Id]			UNIQUEIDENTIFIER,			-- UDL 
	[ResourceLookup3Id]			UNIQUEIDENTIFIER,			-- UDL 
	[ResourceLookup4Id]			UNIQUEIDENTIFIER,			-- UDL 

	[DailyProduction]			DECIMAL,
	[Quantity]					VTYPE				NOT NULL DEFAULT 0, -- measure on which the value is based. If it is MassMeasure then [Mass] must equal [ValueMeasure] and so on.
	[MoneyAmount]				MONEY				NOT NULL DEFAULT 0, -- Amount in foreign Currency 
	[Mass]						DECIMAL				NOT NULL DEFAULT 0, -- MassUnit, like LTZ bar, cement bag, etc
	[Volume]					DECIMAL				NOT NULL DEFAULT 0, -- VolumeUnit, possibly for shipping
	[Area]						DECIMAL				NOT NULL DEFAULT 0, -- Area Unit, possibly for lands
	[Length]					DECIMAL				NOT NULL DEFAULT 0, -- Length Unit, possibly for cables or pipes
	[Time]						DECIMAL				NOT NULL DEFAULT 0, -- ServiceTimeUnit
	[Count]						DECIMAL				NOT NULL DEFAULT 0, -- CountUnit
	[Value]						VTYPE				NOT NULL DEFAULT 0, -- equivalent in functional currency

	[CreatedAt]					DATETIMEOFFSET(7)	NOT NULL DEFAULT SYSDATETIMEOFFSET(),
	[CreatedById]				UNIQUEIDENTIFIER	NOT NULL DEFAULT CONVERT(UNIQUEIDENTIFIER, SESSION_CONTEXT(N'UserId')),
	[ModifiedAt]				DATETIMEOFFSET(7)	NOT NULL DEFAULT SYSDATETIMEOFFSET(), 
	[ModifiedById]				UNIQUEIDENTIFIER	NOT NULL DEFAULT CONVERT(UNIQUEIDENTIFIER, SESSION_CONTEXT(N'UserId')),
	CONSTRAINT [CK_Plans__FromDate_ToDate] CHECK ([FromDate] >= [ToDate]),
	CONSTRAINT [FK_Plans__ResponsibilityCenterId]	FOREIGN KEY ([ResponsibilityCenterId])	REFERENCES [dbo].[ResponsibilityCenters] ([Id])
)