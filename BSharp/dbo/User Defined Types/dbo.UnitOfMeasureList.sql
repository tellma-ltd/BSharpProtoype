CREATE TYPE [dbo].[UnitOfMeasureList] AS TABLE
(
    [Id]			NVARCHAR (5),
    [UnitType]		NVARCHAR (10)		NOT NULL,
    [Name]			NVARCHAR (50)		NOT NULL,
    [UnitAmount]	FLOAT (53)			NOT NULL,
    [BaseAmount]	FLOAT (53)			NOT NULL,
    [IsActive]		BIT					NOT NULL DEFAULT ((1)) ,
    [AsOfDateTime]	DATETIMEOFFSET (7)	DEFAULT (getutcdate()),
    PRIMARY KEY CLUSTERED ([Id] ASC)
)
