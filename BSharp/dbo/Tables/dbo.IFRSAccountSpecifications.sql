CREATE TABLE [dbo].[IFRSAccountSpecifications] ( -- might be obsolete
	[TenantId]						INT,
	[IFRSAccountConcept]			NVARCHAR (255),
	-------------------------------------------------
-- Tracking measures
	[Mass]					DECIMAL				NOT NULL DEFAULT (0), -- MassUnit, like LTZ bar
	[Volume]				DECIMAL				NOT NULL DEFAULT (0), -- VolumeUnit, possibly for shipping
	[Count]					DECIMAL				NOT NULL DEFAULT (0), -- CountUnit
	[Time]					DECIMAL				NOT NULL DEFAULT (0), -- ServiceTimeUnit
	[Value]					VTYPE				NOT NULL DEFAULT (0), -- equivalent in functional currency
-- settling date. Can be used to decide current/non current
	[ExpectedClosingDate]	DATETIMEOFFSET(7), 
-- for debiting asset accounts, related resource is acquired from supplier/customer/storage
-- for crediting asset accounts, related reosurce is the resource delivered to supplier/customer/storage as resource
-- for liability account, related resource is n/a
	[RelatedMoneyAmount]	MONEY, -- what about related volumne, mass, etc...
	[RelatedMass]			DECIMAL				NOT NULL DEFAULT (0), -- MassUnit, like LTZ bar
	[RelatedVolume]			DECIMAL				NOT NULL DEFAULT (0), -- VolumeUnit, possibly for shipping
	[RelatedCount]			DECIMAL				NOT NULL DEFAULT (0), -- CountUnit
	[RelatedTime]			DECIMAL				NOT NULL DEFAULT (0), -- ServiceTimeUnit
	[RelatedValue]			VTYPE				NOT NULL DEFAULT (0), -- equivalent in functional currency
	-------------------------------------------------
	-- For all directions
	-------------------------------------------------
	[AgentAccountLabel]				NVARCHAR (255),	-- displayed when hovering over the agent account column, or when used in line specs. Null means not visible.
	[AgentAccountValidation]		NVARCHAR (1024), -- e.g., not null to make it required.
	[AgentAccountFilter]			NVARCHAR (255), -- JS code, affecting the picker.
	[ResourceLabel]					NVARCHAR (255),
	[ResourceValidation]			NVARCHAR (1024),
	[ResourceFilter]				NVARCHAR (255),

	[RelatedAgentAccountFilter]		NVARCHAR (255),
	[RelatedResourceFilter]			NVARCHAR (255),
	-- Applies to the specific direction
	[Direction]						SMALLINT,	
	[MoneyAmountLabel]				NVARCHAR (255),
	[MoneyAmountValidation]			NVARCHAR (1024),
	[ReferenceLabel]				NVARCHAR (255),
	[ReferenceValidation]			NVARCHAR (1024),
	[RelatedReferenceLabel]			NVARCHAR (255),
	[RelatedReferenceValidation]	NVARCHAR (1024),
	[RelatedAgentLabel]				NVARCHAR (255),
	[RelatedAgentValidation]		NVARCHAR (1024),
	[RelatedResourceLabel]			NVARCHAR (255),
	[RelatedResourceValidation]		NVARCHAR (1024),
	[RelatedAmountLabel]			NVARCHAR (255),
	[RelatedAmountValidation]		NVARCHAR (1024)
	CONSTRAINT [PK_AccountSpecifications] PRIMARY KEY NONCLUSTERED ([TenantId] ASC, [IFRSAccountConcept] ASC, [Direction] ASC),
--	CONSTRAINT [FK_AccountSpecifications_Accounts] FOREIGN KEY ([TenantId], [AccountId]) REFERENCES [dbo].[IFRSConcepts] ([TenantId], [Id]) ON DELETE CASCADE,
	CONSTRAINT [CK_Accountpecifications_Direction] CHECK ([Direction] IN (-1, 0,  +1)),
);