CREATE TYPE [dbo].[ResourceLookupList] AS TABLE (
	[Index]			INT				IDENTITY(0, 1),
	[Id]			INT,
	[Name]			NVARCHAR (255)	NOT NULL,
	[Name2]			NVARCHAR (255),
	[Name3]			NVARCHAR (255),
	[EntityState]	NVARCHAR (255)	NOT NULL DEFAULT(N'Inserted'),
	[Code]			NVARCHAR (255),
	PRIMARY KEY ([Index] ASC),
	INDEX IX_ResourceLookupList__Code ([Code]),
	INDEX IX_ResourceLookupList__Name ([Name]),
	CHECK ([EntityState] IN (N'Unchanged', N'Inserted', N'Updated', N'Deleted')),
	CHECK ([EntityState] <> N'Inserted' OR [Id] IS NULL)
);