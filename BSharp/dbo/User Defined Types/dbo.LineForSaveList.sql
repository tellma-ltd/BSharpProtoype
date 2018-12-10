CREATE TYPE [dbo].[LineForSaveList] AS TABLE (
	[Index]				INT					IDENTITY(0, 1),
    [Id]				INT,
    [DocumentIndex]		INT					NOT NULL,
    [DocumentId]		INT	,
    [StartDateTime]		DATETIMEOFFSET (7) ,
    [EndDateTime]		DATETIMEOFFSET (7) ,
	[BaseLineId]		INT, -- this is like FunctionId, good for linear functions.
	[ScalingFactor]		FLOAT, -- Qty sold for Price list, Qty produced for BOM, throughput rate for oil well.	.	
    [Memo]				NVARCHAR(255),
	[EntityState]		NVARCHAR(255)		NOT NULL DEFAULT(N'Inserted'),
    PRIMARY KEY CLUSTERED ([Index] ASC),
	CHECK ([EntityState] IN (N'Unchanged', N'Inserted', N'Updated', N'Deleted')),
	CHECK ([EntityState] <> N'Inserted' OR [Id] IS NULL)
);