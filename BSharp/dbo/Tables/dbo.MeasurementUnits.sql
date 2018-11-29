﻿CREATE TABLE [dbo].[MeasurementUnits] (
	[TenantId]		INT,
	[Id]			INT					IDENTITY(1,1),
    [Code]			NVARCHAR (255)		NOT NULL,
    [UnitType]		NVARCHAR (255)		NOT NULL,
    [Name]			NVARCHAR (255)		NOT NULL,
    [UnitAmount]	FLOAT (53)			NOT NULL CONSTRAINT [DF_UnitsOfMeasure_UnitAmount] DEFAULT(1),
    [BaseAmount]	FLOAT (53)			NOT NULL CONSTRAINT [DF_UnitsOfMeasure_BaseAmount] DEFAULT(1),
    [IsActive]		BIT					NOT NULL CONSTRAINT [DF_UnitsOfMeasure_IsActive] DEFAULT (1) ,
    CONSTRAINT [PK_UnitsOfMeasure] PRIMARY KEY CLUSTERED ([TenantId] ASC, [Id] ASC),
	CONSTRAINT [CK_UnitsOfMeasure_UnitType] CHECK ([UnitType] IN (N'Pure', N'Time', N'Distance', N'Count', N'Mass', N'Volume', N'Money'))
);
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_UnitsOfMeasure__Code] ON [dbo].[MeasurementUnits]([TenantId] ASC, [Code] ASC);
GO
