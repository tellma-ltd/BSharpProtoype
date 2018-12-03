CREATE TYPE [dbo].[MeasurementUnitList] AS TABLE
(
	[Index]			INT				IDENTITY(0, 1),
	[Id]			INT,
    [Code]			NVARCHAR (255),
    [UnitType]		NVARCHAR (255)	NOT NULL,
    [Name]			NVARCHAR (255)	NOT NULL,
    [UnitAmount]	FLOAT (53)		NOT NULL,
    [BaseAmount]	FLOAT (53)		NOT NULL,
    [IsActive]		BIT				NOT NULL DEFAULT(1),
	[Status]		NVARCHAR(255)	NOT NULL DEFAULT(N'Inserted'), -- Inserted, Updated, Deleted.
    PRIMARY KEY CLUSTERED ([Index] ASC),
	CHECK ([Status] <> N'Inserted' OR [Id] IS NULL)
)
