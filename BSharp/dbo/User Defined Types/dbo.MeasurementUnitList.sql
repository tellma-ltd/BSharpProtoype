CREATE TYPE [dbo].[MeasurementUnitList] AS TABLE
(
	[Id]			INT,
    [Code]			NVARCHAR (255),
    [UnitType]		NVARCHAR (255)		NOT NULL,
    [Name]			NVARCHAR (255)		NOT NULL,
    [UnitAmount]	FLOAT (53)			NOT NULL,
    [BaseAmount]	FLOAT (53)			NOT NULL,
    [IsActive]		BIT					NOT NULL DEFAULT ((1)) ,
    PRIMARY KEY CLUSTERED ([Id] ASC)
)
