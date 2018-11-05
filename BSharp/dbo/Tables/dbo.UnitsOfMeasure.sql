CREATE TABLE [dbo].[UnitsOfMeasure] (
    [Id]           NVARCHAR (5)       NOT NULL,
    [UnitType]     NVARCHAR (10)      NOT NULL,
    [Name]         NVARCHAR (50)      NOT NULL,
    [UnitAmount]   FLOAT (53)         NOT NULL,
    [BaseAmount]   FLOAT (53)         NOT NULL,
    [IsActive]     BIT                CONSTRAINT [DF_UnitsOfMeasure_IsActive] DEFAULT ((1)) NOT NULL,
    [AsOfDateTime] DATETIMEOFFSET (7) CONSTRAINT [DF_UnitsOfMeasure_AsOf] DEFAULT (getutcdate()) NULL,
    CONSTRAINT [PK_UnitsOfMeasure] PRIMARY KEY CLUSTERED ([Id] ASC)
);

