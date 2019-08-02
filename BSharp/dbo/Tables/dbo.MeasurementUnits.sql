CREATE TABLE [dbo].[MeasurementUnits] (
	[Id]			UNIQUEIDENTIFIER PRIMARY KEY,
	[UnitType]		NVARCHAR (255)		NOT NULL,
	[Name]			NVARCHAR (255)		NOT NULL,
	[Name2]			NVARCHAR (255),
	[Name3]			NVARCHAR (255),
	[Description]	NVARCHAR (255)		NOT NULL,
	[Description2]	NVARCHAR (255),
	[Description3]	NVARCHAR (255),
	[UnitAmount]	FLOAT (53)			NOT NULL DEFAULT 1,
	[BaseAmount]	FLOAT (53)			NOT NULL DEFAULT 1,
	[IsActive]		BIT					NOT NULL DEFAULT 1,
	[Code]			NVARCHAR (255),
	[CreatedAt]		DATETIMEOFFSET(7)	NOT NULL DEFAULT SYSDATETIMEOFFSET(),
	[CreatedById]	UNIQUEIDENTIFIER	NOT NULL DEFAULT CONVERT(UNIQUEIDENTIFIER, SESSION_CONTEXT(N'UserId')),
	[ModifiedAt]	DATETIMEOFFSET(7)	NOT NULL DEFAULT SYSDATETIMEOFFSET(), 
	[ModifiedById]	UNIQUEIDENTIFIER	NOT NULL DEFAULT CONVERT(UNIQUEIDENTIFIER, SESSION_CONTEXT(N'UserId')),
	CONSTRAINT [CK_MeasurementUnits__UnitType] CHECK ([UnitType] IN (N'Pure', N'Time', N'Distance', N'Count', N'Mass', N'Volume', N'Money'))
);
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_MeasurementUnits__Name]
  ON [dbo].[MeasurementUnits]([Name]);
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_MeasurementUnits__Name2]
  ON [dbo].[MeasurementUnits]([Name2]) WHERE [Name2] IS NOT NULL;
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_MeasurementUnits__Name3]
  ON [dbo].[MeasurementUnits]([Name3]) WHERE [Name3] IS NOT NULL;
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_MeasurementUnits__Code]
  ON [dbo].[MeasurementUnits]([Code]) WHERE [Code] IS NOT NULL;
GO