CREATE TYPE [dbo].[MeasurementUnitList] AS TABLE
(
	[Index]			INT,
	[Id]			INT,
    [UnitType]		NVARCHAR (255)		NOT NULL,
    [Name]			NVARCHAR (255)		NOT NULL,
    [UnitAmount]	FLOAT (53)			NOT NULL,
    [BaseAmount]	FLOAT (53)			NOT NULL,
    [IsActive]		BIT					NOT NULL,
    [Code]			NVARCHAR (255),
    [CreatedAt]		DATETIMEOFFSET(7)	NOT NULL,
    [CreatedBy]		NVARCHAR(450)		NOT NULL,
    [ModifiedAt]	DATETIMEOFFSET(7)	NOT NULL, 
    [ModifiedBy]	NVARCHAR(450)		NOT NULL,
	[EntityState]	NVARCHAR(255)		NOT NULL DEFAULT(N'Inserted')
    PRIMARY KEY CLUSTERED ([Index] ASC),
	CHECK ([UnitType] IN (N'Pure', N'Time', N'Distance', N'Count', N'Mass', N'Volume', N'Money')),
	CHECK ([EntityState] <> N'Inserted' OR [Id] IS NULL)
)
