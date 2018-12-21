﻿CREATE PROCEDURE [dbo].[dal_MeasurementUnits__Select]
	@Ids [dbo].[IntegerList] READONLY,
	@EntitiesResultJson NVARCHAR(MAX) OUTPUT
AS
SELECT @EntitiesResultJson = (
	SELECT
		[Id], [UnitType], [Name], [Description], [UnitAmount], [BaseAmount], [IsActive], [Code], 
		[CreatedAt], [CreatedBy], [ModifiedAt], [ModifiedBy], N'Unchanged' As [EntityState]
	FROM [dbo].MeasurementUnits
	WHERE [Id] IN (SELECT [Id] FROM @Ids)
	FOR JSON PATH
);