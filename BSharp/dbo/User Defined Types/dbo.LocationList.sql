CREATE TYPE [dbo].[LocationList] AS TABLE
(
	[Index]				INT,
    [Id]				INT,
    [LocationType]		NVARCHAR (255)	NOT NULL,
    [Name]				NVARCHAR (255)	NOT NULL,
    [IsActive]			BIT,		
	[Code]				NVARCHAR (255),
    [Address]			NVARCHAR (255),
    [BirthDateTime]		DATETIMEOFFSET (7),
    [CustodianId]		INT,
    [CreatedAt]			DATETIMEOFFSET(7), 
    [CreatedBy]			NVARCHAR(450), 
    [ModifiedAt]		DATETIMEOFFSET(7), 
    [ModifiedBy]		NVARCHAR(450), 
	[EntityState]		NVARCHAR(255)	NOT NULL DEFAULT(N'Inserted'), -- Unchanged, Inserted, Updated, Deleted.
    PRIMARY KEY CLUSTERED ([Index] ASC),
	CHECK ([LocationType] IN (N'CashSafe', N'BankAccount', N'Warehouse', N'Farm', N'ProductionPoint', N'Misc')),
	CHECK ([EntityState] <> N'Inserted' OR [Id] IS NULL)
);