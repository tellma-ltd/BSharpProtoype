CREATE TABLE [dbo].[MeasurementUnits] (
	[TenantId]		INT					DEFAULT CONVERT(INT, SESSION_CONTEXT(N'TenantId')),
	[Id]			INT					IDENTITY,
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
	[CreatedById]	INT					NOT NULL DEFAULT CONVERT(INT, SESSION_CONTEXT(N'UserId')),
	[ModifiedAt]	DATETIMEOFFSET(7)	NOT NULL DEFAULT SYSDATETIMEOFFSET(), 
	[ModifiedById]	INT					NOT NULL DEFAULT CONVERT(INT, SESSION_CONTEXT(N'UserId')),
	CONSTRAINT [PK_MeasurementUnits] PRIMARY KEY ([TenantId], [Id]),
	CONSTRAINT [CK_MeasurementUnits__UnitType] CHECK ([UnitType] IN (N'Pure', N'Time', N'Distance', N'Count', N'Mass', N'Volume', N'Money'))
);
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_MeasurementUnits__Name]
  ON [dbo].[MeasurementUnits]([TenantId] ASC, [Name] ASC);
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_MeasurementUnits__Name2]
  ON [dbo].[MeasurementUnits]([TenantId] ASC, [Name2] ASC) WHERE [Name2] IS NOT NULL;
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_MeasurementUnits__Name3]
  ON [dbo].[MeasurementUnits]([TenantId] ASC, [Name3] ASC) WHERE [Name3] IS NOT NULL;
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_MeasurementUnits__Code]
  ON [dbo].[MeasurementUnits]([TenantId] ASC, [Code] ASC) WHERE [Code] IS NOT NULL;
GO