CREATE TYPE [dbo].[ProductCategoryList] AS TABLE (
	[Index]				INT,				--IDENTITY(0, 1),
	[Id]				INT,
	[Node]				HIERARCHYID, -- filled on the server
	[ParentNode]		HIERARCHYID, -- filled on the server
	[Name]				NVARCHAR (255)	NOT NULL,
	[Name2]				NVARCHAR (255),
	[Name3]				NVARCHAR (255),
	[ParentIndex]		INT,
	[ParentId]			INT,
	[Code]				NVARCHAR (255),
	[EntityState]		NVARCHAR (255)	NOT NULL DEFAULT(N'Inserted'),
	PRIMARY KEY ([Index] ASC),
	CHECK ([EntityState] IN (N'Unchanged', N'Inserted', N'Updated', N'Deleted'))
);