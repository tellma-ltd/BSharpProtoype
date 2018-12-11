CREATE PROCEDURE [dbo].[dal_MeasurementUnits__Select]
	@IndexedIds dbo.IndexedIdList READONLY,
	@MeasurementUnitsResultJson NVARCHAR(MAX) OUTPUT
AS
SELECT @MeasurementUnitsResultJson = (
		SELECT
			T.[Index], MU.[Id], MU.[UnitType], MU.[Name], MU.[Description], MU.[UnitAmount], MU.[BaseAmount], MU.[IsActive], MU.[Code], 
			MU.[CreatedAt], MU.[CreatedBy], MU.[ModifiedAt], MU.[ModifiedBy], N'Unchanged' As [EntityState]
		FROM [dbo].MeasurementUnits MU JOIN (
			SELECT [Index], [Id] 
			FROM  @IndexedIds
		) T ON MU.Id = T.Id
		FOR JSON PATH
	);
