CREATE TYPE [dbo].[LineList] AS TABLE (
	[Id]				INT,
	[DocumentId]		INT					NOT NULL,
	[BaseLineId]		INT, -- this is like FunctionId, good for linear functions.
	[ScalingFactor]		FLOAT, -- Qty sold for Price list, Qty produced for BOM, throughput rate for oil well.	.	
	[Memo]				NVARCHAR(255),
	[CreatedAt]			DATETIMEOFFSET(7)	NOT NULL,
	[CreatedBy]			NVARCHAR(450)		NOT NULL,
	[ModifiedAt]		DATETIMEOFFSET(7)	NOT NULL, 
	[ModifiedBy]		NVARCHAR(450)		NOT NULL,
	[EntityState]		NVARCHAR(255)		NOT NULL DEFAULT(N'Inserted'),
	PRIMARY KEY CLUSTERED ([Id] ASC),
	CHECK ([EntityState] IN (N'Unchanged', N'Inserted', N'Updated', N'Deleted')),
	CHECK ([EntityState] <> N'Inserted' OR [Id] IS NULL)
);