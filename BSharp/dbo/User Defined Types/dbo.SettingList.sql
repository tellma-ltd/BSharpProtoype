CREATE TYPE [dbo].[SettingList] AS TABLE (
	[Index]			INT				IDENTITY(0, 1),
	[Field]			NVARCHAR (255),
	[Value]			NVARCHAR (1024) NOT NULL,
	[EntityState]	NVARCHAR(255)	NOT NULL DEFAULT(N'Inserted'),
	PRIMARY KEY ([Index] ASC),
	CHECK ([EntityState] IN (N'Unchanged', N'Inserted', N'Updated', N'Deleted'))
);