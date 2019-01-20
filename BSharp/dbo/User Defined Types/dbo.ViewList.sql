CREATE TYPE [dbo].[ViewList] AS TABLE (
	[Id]					NVARCHAR (255),
	[EntityState]			NVARCHAR(255)	NOT NULL DEFAULT(N'Inserted'),
	PRIMARY KEY NONCLUSTERED ([Id] ASC),
	CHECK ([EntityState] IN (N'Unchanged', N'Inserted', N'Updated', N'Deleted'))
);