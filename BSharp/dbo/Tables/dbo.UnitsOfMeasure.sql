CREATE TABLE [dbo].[UnitsOfMeasure] (
	[TenantId]		INT,
    [Id]			NVARCHAR (5),
    [UnitType]		NVARCHAR (10)		NOT NULL,
    [Name]			NVARCHAR (50)		NOT NULL,
    [UnitAmount]	FLOAT (53)			NOT NULL,
    [BaseAmount]	FLOAT (53)			NOT NULL,
    [IsActive]		BIT                CONSTRAINT [DF_UnitsOfMeasure_IsActive] DEFAULT (1) NOT NULL,
    [AsOfDateTime]	DATETIMEOFFSET (7) CONSTRAINT [DF_UnitsOfMeasure_AsOf] DEFAULT (getutcdate()),
    CONSTRAINT [PK_UnitsOfMeasure] PRIMARY KEY CLUSTERED ([TenantId] ASC, [Id] ASC),
);

