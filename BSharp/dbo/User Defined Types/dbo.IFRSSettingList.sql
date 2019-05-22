CREATE TYPE [dbo].[IFRSSettingList] AS TABLE (
	[Index]			INT				IDENTITY(0, 1),
	[Id]			INT,
	[Field]			NVARCHAR (255)	NOT NULL,
	[Value]			NVARCHAR (255),
	[ValidSince]	Date			NOT NULL DEFAULT('01.01.0001'),
	[EntityState]	NVARCHAR (255)	NOT NULL DEFAULT(N'Inserted'),
	[Code]			NVARCHAR (255),
	PRIMARY KEY ([Index] ASC),
	INDEX IX_IFRSSettingList__Code ([Code]),
	CHECK ([EntityState] IN (N'Unchanged', N'Inserted', N'Updated', N'Deleted')),
	CHECK ([EntityState] <> N'Inserted' OR [Id] IS NULL)
);