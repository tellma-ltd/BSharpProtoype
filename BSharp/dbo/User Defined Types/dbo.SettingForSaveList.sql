CREATE TYPE [dbo].[SettingForSaveList] AS TABLE
(
    [Field]			NVARCHAR (255),
    [Value]			NVARCHAR (1024) NOT NULL,
	[EntityState]	NVARCHAR(255)		NOT NULL DEFAULT(N'Inserted'), -- Unchanged, Inserted, Updated, Deleted.
    PRIMARY KEY CLUSTERED ([Field] ASC)
	--CHECK ([EntityState] <> N'Inserted' OR [Id] IS NULL)
)
