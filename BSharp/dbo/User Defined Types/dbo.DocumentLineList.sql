CREATE TYPE [dbo].[DocumentLineList] AS TABLE (
	[Index]					INT,
	[DocumentIndex]			INT				NOT NULL,
	[Id]					UNIQUEIDENTIFIER NOT NULL,
	[DocumentId]			UNIQUEIDENTIFIER NOT NULL,
	[LineTypeId]			NVARCHAR (255)	NOT NULL,
	[TemplateLineId]		UNIQUEIDENTIFIER,
	[ScalingFactor]			FLOAT,
	
	[EntityState]		NVARCHAR (255)	NOT NULL DEFAULT(N'Inserted'),
	PRIMARY KEY ([Index]),
	CHECK ([EntityState] IN (N'Unchanged', N'Inserted', N'Updated', N'Deleted'))
);