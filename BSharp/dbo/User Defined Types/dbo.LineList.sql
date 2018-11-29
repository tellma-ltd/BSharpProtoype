CREATE TYPE [dbo].[LineList] AS TABLE (
    [Id]				INT,
    [DocumentId]		INT				NOT NULL,
    [StartDateTime]		DATETIMEOFFSET (7) ,
    [EndDateTime]		DATETIMEOFFSET (7) ,
	[BaseLineId]		INT, -- this is like FunctionId, good for linear functions.
	[ScalingFactor]		FLOAT, -- Qty sold for Price list, Qty produced for BOM, throughput rate for oil well.	.	
    [Memo]				NVARCHAR(255), 
	[Status]			NVARCHAR(255)	NOT NULL DEFAULT(N'Inserted'), -- Unchanged, Inserted, Updated, Deleted.
	[TemporaryId]		INT				NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC),
	CHECK ([Status] IN (N'Unchanged', N'Inserted', N'Updated', N'Deleted'))
);