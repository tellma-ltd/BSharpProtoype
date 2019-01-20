CREATE TYPE [dbo].[PermissionList] AS TABLE (
	[Index]			INT,
	[HeaderIndex]	INT				NOT NULL,
	[Id]			INT,
	[RoleId]		INT,
	[ViewId]		NVARCHAR(255)	NOT NULL,
	[Level]			NVARCHAR(255)	NOT NULL,
	[Criteria]		NVARCHAR(1024), -- compiles into LINQ expression to filter the applicability
	[Memo]			NVARCHAR(255),
	[EntityState]	NVARCHAR(255)	NOT NULL DEFAULT(N'Inserted'),
	PRIMARY KEY ([Index] ASC),
	CHECK ([Level] IN (N'Read', N'Create', N'ReadAndCreate', N'Update', N'Sign')),
	CHECK ([EntityState] IN (N'Unchanged', N'Inserted', N'Updated', N'Deleted')),
	CHECK ([EntityState] <> N'Inserted' OR [Id] IS NULL)
);