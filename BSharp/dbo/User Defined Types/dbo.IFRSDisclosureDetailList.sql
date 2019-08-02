CREATE TYPE [dbo].[IfrsDisclosureDetailList] AS TABLE (
	[Index]				INT				IDENTITY(1, 1),
	[Id]				UNIQUEIDENTIFIER NOT NULL,
	[IfrsDisclosureId]	NVARCHAR (255)	NOT NULL,
	[Value]				NVARCHAR (255),
	[ValidSince]		Date			NOT NULL DEFAULT('0001.01.01'),
	[EntityState]		NVARCHAR (255)	NOT NULL DEFAULT(N'Inserted'),
	[Code]				NVARCHAR (255),
	PRIMARY KEY ([Index]),
	INDEX IX_IfrsSettingList__Code ([Code]),
	CHECK ([EntityState] IN (N'Unchanged', N'Inserted', N'Updated', N'Deleted'))
);