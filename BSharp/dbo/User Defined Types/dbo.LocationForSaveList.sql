CREATE TYPE [dbo].[LocationForSaveList] AS TABLE
(
	[Index]				INT				IDENTITY(0, 1),
    [Id]				INT	,
    [LocationType]		NVARCHAR (255)	NOT NULL,
    [Name]				NVARCHAR (255)		NOT NULL,
	[Code]				NVARCHAR (255),
    [Address]			NVARCHAR (255),
    [BirthDateTime]		DATETIMEOFFSET (7),
    [CustodianId]		INT,
	[EntityState]		NVARCHAR(255)	NOT NULL DEFAULT(N'Inserted'),
    PRIMARY KEY CLUSTERED ([Index] ASC),
	CHECK ([LocationType] IN (N'CashSafe', N'BankAccount', N'Warehouse', N'Farm', N'ProductionPoint', N'Misc')),
	CHECK ([EntityState] IN (N'Unchanged', N'Inserted', N'Updated', N'Deleted')),
	CHECK ([EntityState] <> N'Inserted' OR [Id] IS NULL)
);