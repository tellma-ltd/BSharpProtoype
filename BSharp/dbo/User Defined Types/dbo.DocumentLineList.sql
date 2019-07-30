CREATE TYPE [dbo].[DocumentLineList] AS TABLE (
	[Index]					INT,
	[DocumentIndex]			INT				NOT NULL,
	[Id]					INT,
	[DocumentId]			INT,
	[LineTypeId]			NVARCHAR (255)	NOT NULL,
	[TemplateLineId]		INT,
	[ScalingFactor]			FLOAT,
	
	[EntityState]		NVARCHAR (255)	NOT NULL DEFAULT(N'Inserted'),
	PRIMARY KEY ([Index] ASC),
	CHECK ([EntityState] IN (N'Unchanged', N'Inserted', N'Updated', N'Deleted')),
	CHECK ([EntityState] <> N'Inserted' OR [Id] IS NULL)
);