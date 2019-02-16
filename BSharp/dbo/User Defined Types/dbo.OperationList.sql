CREATE TYPE [dbo].[OperationList] AS TABLE (
	[Index]					INT				IDENTITY(0, 1),
	[Id]					INT	,
	[Name]					NVARCHAR (255)	NOT NULL,
	[Name2]					NVARCHAR (255),
	[Code]					NVARCHAR (255),
	[ProductCategoryId]		INT,		-- e.g., sales, services
	[GeographicRegionId]	INT,		-- e.g., Riyadh, Jeddah
	[CustomerSegmentId]		INT,		-- e.g., Corporate, Individual or M, F or Adult youth, etc...
	[FunctionId]			INT,		-- e.g., HQ, Branch, Accommodation
	[ParentIndex]			INT,
	[ParentId]				INT,  
	[EntityState]			NVARCHAR(255)	NOT NULL DEFAULT(N'Inserted'),
	PRIMARY KEY ([Index] ASC),
	INDEX IX_OperationList__Code ([Code]),
	CHECK ([EntityState] IN (N'Unchanged', N'Inserted', N'Updated', N'Deleted')),
	CHECK ([EntityState] <> N'Inserted' OR [Id] IS NULL)
);