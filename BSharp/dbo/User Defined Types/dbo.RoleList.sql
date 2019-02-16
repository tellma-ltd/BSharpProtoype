CREATE TYPE [dbo].[RoleList] AS TABLE (
	[Index]				INT,
	[Id]				INT					IDENTITY,
	[Name]				NVARCHAR (255)		NOT NULL,
	[Name2]				NVARCHAR (255),
	[IsPublic]			BIT					NOT NULL DEFAULT (0),		
	[Code]				NVARCHAR (255),
	[EntityState]		NVARCHAR(255)		NOT NULL DEFAULT(N'Inserted'),
	PRIMARY KEY ([Index] ASC),
	CHECK ([EntityState] IN (N'Unchanged', N'Inserted', N'Updated', N'Deleted')),
	CHECK ([EntityState] <> N'Inserted' OR [Id] IS NULL)
);