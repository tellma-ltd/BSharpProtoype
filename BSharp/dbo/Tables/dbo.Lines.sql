﻿CREATE TABLE [dbo].[Lines] (
	[TenantId]		INT,
	[Id]			INT IDENTITY (1, 1),
	[DocumentId]	INT					NOT NULL,
	[Assertion]		SMALLINT			NOT NULL CONSTRAINT [DF_Lines_Assertion] DEFAULT(1), -- (-1) for negation.
	[LineType]		NVARCHAR(255)		NOT NULL,
--	Ideally, instead of BaseLineId to store the price list or BOM used, it should be the info needed to compute the line.
--	Function Name, with list of Params. 
--	Depreciation based on units produced: V0, R, Capacity in (RelatedAmount), Units (in Amount), T0 and T1 are irrelevant.
--	Well with 500M oil capacity, dumping 500K barrels daily.
--	Capacity could increase
	[BaseLineId]	INT, -- this is like FunctionId, good for linear functions.
	[ScalingFactor]	FLOAT, -- Qty sold for Price list, Qty produced for BOM, throughput rate for oil well.
	[Memo]			NVARCHAR(255),

	[OperationId1]			INT,
	[AccountId1]			NVARCHAR (255),
	[CustodyId1]			INT,
	[ResourceId1]			INT,
	[Direction1]			SMALLINT,
	[Amount1]				MONEY,
	[Value1]				VTYPE,
	[NoteId1]				NVARCHAR (255),
	[Reference1]			NVARCHAR (255),
	[RelatedReference1]		NVARCHAR (255),
	[RelatedAgentId1]		INT,
	[RelatedResourceId1]	INT,
	[RelatedAmount1]		MONEY,

	[OperationId2]			INT,
	[AccountId2]			NVARCHAR (255),
	[CustodyId2]			INT,
	[ResourceId2]			INT,
	[Direction2]			SMALLINT,
	[Amount2]				MONEY,
	[Value2]				VTYPE,
	[NoteId2]				NVARCHAR (255),
	[Reference2]			NVARCHAR (255),
	[RelatedReference2]		NVARCHAR (255),
	[RelatedAgentId2]		INT,
	[RelatedResourceId2]	INT,
	[RelatedAmount2]		MONEY,

	[OperationId3]			INT,
	[AccountId3]			NVARCHAR (255),
	[CustodyId3]			INT,
	[ResourceId3]			INT,
	[Direction3]			SMALLINT,
	[Amount3]				MONEY,
	[Value3]				VTYPE,
	[NoteId3]				NVARCHAR (255),
	[Reference3]			NVARCHAR (255),
	[RelatedReference3]		NVARCHAR (255),
	[RelatedAgentId3]		INT,
	[RelatedResourceId3]	INT,
	[RelatedAmount3]		MONEY,

	[OperationId4]			INT,
	[AccountId4]			NVARCHAR (255),
	[CustodyId4]			INT,
	[ResourceId4]			INT,
	[Direction4]			SMALLINT,
	[Amount4]				MONEY,
	[Value4]				VTYPE,
	[NoteId4]				NVARCHAR (255),
	[Reference4]			NVARCHAR (255),
	[RelatedReference4]		NVARCHAR (255),
	[RelatedAgentId4]		INT,
	[RelatedResourceId4]	INT,
	[RelatedAmount4]		MONEY,

	[CreatedAt]		DATETIMEOFFSET(7)	NOT NULL,
	[CreatedBy]		NVARCHAR(450)		NOT NULL,
	[ModifiedAt]	DATETIMEOFFSET(7)	NOT NULL, 
	[ModifiedBy]	NVARCHAR(450)		NOT NULL,
	CONSTRAINT [PK_Lines] PRIMARY KEY CLUSTERED ([TenantId] ASC, [Id] ASC),
	CONSTRAINT [FK_Lines_Documents] FOREIGN KEY ([TenantId], [DocumentId]) REFERENCES [dbo].[Documents] ([TenantId], [Id]) ON DELETE CASCADE,
	CONSTRAINT [FK_Lines_LineTypes] FOREIGN KEY ([TenantId], [LineType]) REFERENCES [dbo].[LineTypes] ([TenantId], [Id]) ON DELETE CASCADE,
	CONSTRAINT [FK_Lines_Lines] FOREIGN KEY ([TenantId], [BaseLineId]) REFERENCES [dbo].[Lines] ([TenantId], [Id]),
	CONSTRAINT [FK_Lines_CreatedBy] FOREIGN KEY ([TenantId], [CreatedBy]) REFERENCES [dbo].[Users] ([TenantId], [Id]),
	CONSTRAINT [FK_Lines_ModifiedBy] FOREIGN KEY ([TenantId], [ModifiedBy]) REFERENCES [dbo].[Users] ([TenantId], [Id])
);
GO
CREATE INDEX [IX_Lines__DocumentId] ON [dbo].[Lines]([TenantId] ASC, [DocumentId] ASC);
GO