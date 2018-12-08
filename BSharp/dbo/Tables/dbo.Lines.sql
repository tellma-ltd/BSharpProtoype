CREATE TABLE [dbo].[Lines] (
	[TenantId]		INT,
    [Id]			INT IDENTITY (1, 1),
    [DocumentId]	INT					NOT NULL,
	[Assertion]		SMALLINT			NOT NULL CONSTRAINT [DF_Lines_Assertion] DEFAULT(1), -- (-1) for negation.
    [StartDateTime]	DATETIMEOFFSET (7)	NOT NULL, -- in future for demands and in past for vouchers, validity period for template and plan. Meaningless for inquiries.
    [EndDateTime]	DATETIMEOFFSET (7)	NOT NULL, -- if we make start and period, then period will have meaning for templates
--	Ideally, instead of BaseLineId to store the price list or BOM used, it should be the info needed to compute the line.
--	Function Name, with list of Params. 
--	Depreciation based on units produced: V0, R, Capacity in (RelatedAmount), Units (in Amount), T0 and T1 are irrelevant.
--	Well with 500M oil capacity, dumping 500K barrels daily.
--	Capacity could increase
	[BaseLineId]	INT, -- this is like FunctionId, good for linear functions.
	[ScalingFactor]	FLOAT, -- Qty sold for Price list, Qty produced for BOM, throughput rate for oil well.
    [Memo]			NVARCHAR(255), 
    [CreatedAt]		DATETIMEOFFSET(7)	NOT NULL,
    [CreatedBy]		NVARCHAR(450)		NOT NULL,
    [ModifiedAt]	DATETIMEOFFSET(7)	NOT NULL, 
    [ModifiedBy]	NVARCHAR(450)		NOT NULL,
    CONSTRAINT [PK_Lines] PRIMARY KEY CLUSTERED ([TenantId] ASC, [Id] ASC),
    CONSTRAINT [FK_Lines_Documents] FOREIGN KEY ([TenantId], [DocumentId]) REFERENCES [dbo].[Documents] ([TenantId], [Id]) ON DELETE CASCADE,
	CONSTRAINT [FK_Lines_Lines] FOREIGN KEY ([TenantId], [BaseLineId]) REFERENCES [dbo].[Lines] ([TenantId], [Id])
);
GO