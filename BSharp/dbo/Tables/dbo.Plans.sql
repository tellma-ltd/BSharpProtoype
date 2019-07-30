CREATE TABLE [dbo].[Plans] (
	[TenantId]					INT					DEFAULT CONVERT(INT, SESSION_CONTEXT(N'TenantId')),
	[Id]						INT					IDENTITY,
	[Activity]					NVARCHAR(255), -- Sale, Production, Consumption, 
	[FromDate]					DATE				NOT NULL,
	[ToDate]					DATE				NOT NULL,
	[ResponsibilityCenterId]	INT					NOT NULL,
	[ResourceLookup1Id]			INT,			-- UDL 
	[ResourceLookup2Id]			INT,			-- UDL 
	[ResourceLookup3Id]			INT,			-- UDL 
	[ResourceLookup4Id]			INT,			-- UDL 

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
	[CreatedById]				INT					NOT NULL DEFAULT CONVERT(INT, SESSION_CONTEXT(N'UserId')),
	[ModifiedAt]				DATETIMEOFFSET(7)	NOT NULL DEFAULT SYSDATETIMEOFFSET(), 
	[ModifiedById]				INT					NOT NULL DEFAULT CONVERT(INT, SESSION_CONTEXT(N'UserId')),
	CONSTRAINT [PK_Plans] PRIMARY KEY CLUSTERED ([TenantId], [Id]), -- Voucher/Request/Definition-Model-Template/Commitment, Free(text)/Hierarchichal(xml)/Structured(grid)/Transactional
	CONSTRAINT [CK_Plans__FromDate_ToDate] CHECK ([FromDate] >= [ToDate]),
	CONSTRAINT [FK_Plans__ResponsibilityCenterId]	FOREIGN KEY ([TenantId], [ResponsibilityCenterId])	REFERENCES [dbo].[ResponsibilityCenters] ([TenantId], [Id])
)