CREATE TABLE [dbo].[LineTypesSpecifications] ( -- TODO Merge with LineTypes
	[TenantId]						INT						DEFAULT CONVERT(INT, SESSION_CONTEXT(N'TenantId')),
	[LineTypeId]					NVARCHAR (255),
	[EntryNumber]					INT,

	[DirectionIsVisible]			BIT				NOT NULL DEFAULT 0,
	[DirectionExpression]			NVARCHAR (255),
	[DirectionEntryNumber]			NVARCHAR (255),
	[Direction]					SMALLINT,

	[AccountIdIsVisible]			BIT				NOT NULL DEFAULT 0,
	[AccountIdIfrsFilter]			NVARCHAR (255),
	[AccountIdExpression]			NVARCHAR (255),
	[AccountIdEntryNumber]			INT,

	[IfrsNoteIdIsVisible]			BIT				NOT NULL DEFAULT 0,
	[IfrsNoteIdExpression]			NVARCHAR (255),
	[IfrsNoteIdEntryNumber]		INT,
	[IfrsNoteId]					NVARCHAR (255),

	[ResponsibilityCenterIdIsVisible]BIT			NOT NULL DEFAULT 0,
	[ResponsibilityCenterIdExpression]NVARCHAR (255),
	[ResponsibilityCenterIdEntryNumber]INT,

	[ResourceIdIsVisible]			BIT				NOT NULL DEFAULT 0,
	[ResourceIdExpression]			NVARCHAR (255),
	[ResourceIdEntryNumber]		INT,
	[ResourceId]					INT,

	[InstanceIdIsVisible]			BIT				NOT NULL DEFAULT 0,
	[InstanceIdExpression]			NVARCHAR (255),
	[InstanceIdEntryNumber]		INT,
	
	[BatchCodeIsVisible]			BIT				NOT NULL DEFAULT 0,
	[BatchCodeExpression]			NVARCHAR (255),
	[BatchCodeEntryNumber]			INT,

	[DueDateIsVisible]				BIT				NOT NULL DEFAULT 0,
	[DueDateExpression]			NVARCHAR (255),
	[DueDateEntryNumber]			INT,

	[QuantityIsVisible]				BIT				NOT NULL DEFAULT 0,
	[QuantityExpression]			NVARCHAR (255),
	[QuantityEntryNumber]			INT,
	[Quantity]						VType,

	[MoneyAmountIsVisible]			BIT				NOT NULL DEFAULT 0,
	[MoneyAmountExpression]			NVARCHAR (255),
	[MoneyAmountEntryNumber]		INT,

	[MassIsVisible]					BIT				NOT NULL DEFAULT 0,
	[MassExpression]				NVARCHAR (255),
	[MassEntryNumber]				INT,

	[VolumeIsVisible]				BIT				NOT NULL DEFAULT 0,
	[VolumeExpression]				NVARCHAR (255),
	[VolumeEntryNumber]				INT,

	[AreaIsVisible]					BIT				NOT NULL DEFAULT 0,
	[AreaExpression]				NVARCHAR (255),
	[AreaEntryNumber]				INT,

	[LengthIsVisible]				BIT				NOT NULL DEFAULT 0,
	[LengthExpression]				NVARCHAR (255),
	[LengthEntryNumber]				INT,

	[TimeIsVisible]					BIT				NOT NULL DEFAULT 0,
	[TimeExpression]				NVARCHAR (255),
	[TimeEntryNumber]				INT,

	[CountIsVisible]				BIT				NOT NULL DEFAULT 0,
	[CountExpression]				NVARCHAR (255),
	[CountEntryNumber]				INT,
	[Count]							INT,
	
	[ValueIsVisible]				BIT				NOT NULL DEFAULT 0,
	[ValueExpression]				NVARCHAR (255),
	[ValueEntryNumber]				INT,

	[MemoIsVisible]					BIT					NOT NULL DEFAULT 0,
	[MemoExpression]				NVARCHAR (255),
	[MemoEntryNumber]				INT,

	[ExternalReferenceIsVisible]	BIT				NOT NULL DEFAULT 0,
	[ExternalReferenceExpression]	NVARCHAR (255),
	[ExternalReferenceEntryNumber]	INT,

	[AdditionalReferenceIsVisible]	BIT				NOT NULL DEFAULT 0,
	[AdditionalReferenceExpression]NVARCHAR (255),
	[AdditionalReferenceEntryNumber]INT,

	[RelatedResourceId]			INT, -- Good, Service, Labor, Machine usage

	[RelatedAgentIsVisible]		BIT				NOT NULL DEFAULT 0,
	[RelatedAgentExpression]		NVARCHAR (255),
	[RelatedAgentEntryNumber]		INT,
		
	[RelatedQuantity]				MONEY ,			-- used in Tax accounts, to store the quantiy of taxable item
	[RelatedMoneyAmount]			MONEY 				NOT NULL DEFAULT 0, -- e.g., amount subject to tax

    CONSTRAINT [PK_LineTypeSpecifications] PRIMARY KEY CLUSTERED ([TenantId] ASC, [LineTypeId] ASC, [EntryNumber] ASC),
	CONSTRAINT [FK_LineTypeSpecifications_LineTypes] FOREIGN KEY ([TenantId], [LineTypeId]) REFERENCES [dbo].[LineTypes] ([TenantId], [Id]) ON DELETE CASCADE ON UPDATE CASCADE
);