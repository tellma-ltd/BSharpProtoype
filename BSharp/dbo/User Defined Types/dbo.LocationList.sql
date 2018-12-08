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
    [CreatedAt]			DATETIMEOFFSET(7)	NOT NULL,
    [CreatedBy]			NVARCHAR(450)		NOT NULL,
    [ModifiedAt]		DATETIMEOFFSET(7)	NOT NULL, 
    [ModifiedBy]		NVARCHAR(450)		NOT NULL,
	[EntityState]		NVARCHAR(255)	NOT NULL DEFAULT(N'Inserted'),
    PRIMARY KEY CLUSTERED ([Index] ASC),
	CHECK ([LocationType] IN (N'CashSafe', N'BankAccount', N'Warehouse', N'Farm', N'ProductionPoint', N'Misc')),
	CHECK ([EntityState] <> N'Inserted' OR [Id] IS NULL)
);