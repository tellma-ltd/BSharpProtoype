CREATE PROCEDURE [dbo].[dal_MeasurementUnits__Select]
	@Ids [dbo].[IdList] READONLY,
	@ResultsJson NVARCHAR(MAX) OUTPUT
AS
SELECT @ResultsJson = (
	SELECT
		[Id], [UnitType], [Name], [Name2], [Description], [UnitAmount], [BaseAmount], [IsActive], [Code], 
		[CreatedAt], [CreatedById], [ModifiedAt], [ModifiedById], N'Unchanged' As [EntityState]
	FROM [dbo].MeasurementUnits
	WHERE [Id] IN (SELECT [Id] FROM @Ids)
	FOR JSON PATH
);