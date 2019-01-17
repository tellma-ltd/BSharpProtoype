CREATE TYPE [dbo].[PlaceList] AS TABLE (
	[Index]				INT				IDENTITY(0, 1),
	[Id]				INT	,
	[PlaceType]			NVARCHAR (255)	NOT NULL,
	[Name]				NVARCHAR (255)	NOT NULL,
	[Name2]				NVARCHAR (255),
	[Code]				NVARCHAR (255),
	[Address]			NVARCHAR (1024),
	[BirthDateTime]		DATETIMEOFFSET (7),
	[CustodianId]		INT,
	[EntityState]		NVARCHAR(255)	NOT NULL DEFAULT(N'Inserted'),
	PRIMARY KEY ([Index] ASC),
	INDEX IX_PlaceList__Code ([Code]),
	CHECK ([PlaceType] IN (N'CashSafe', N'BankAccount', N'Warehouse', N'Farm', N'ProductionPoint', N'Misc')),
	CHECK ([EntityState] IN (N'Unchanged', N'Inserted', N'Updated', N'Deleted')),
	CHECK ([EntityState] <> N'Inserted' OR [Id] IS NULL)
);