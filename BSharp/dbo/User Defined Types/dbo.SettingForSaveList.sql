CREATE TYPE [dbo].[SettingForSaveList] AS TABLE
(
  [Field]			NVARCHAR (255),
  [Value]			NVARCHAR (1024) NOT NULL,
	[EntityState]	NVARCHAR(255)		NOT NULL DEFAULT(N'Inserted'),
  PRIMARY KEY CLUSTERED ([Field] ASC),
	CHECK ([EntityState] IN (N'Unchanged', N'Inserted', N'Updated', N'Deleted'))
)
