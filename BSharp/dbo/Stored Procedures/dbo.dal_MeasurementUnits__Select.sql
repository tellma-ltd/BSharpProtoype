CREATE PROCEDURE [dbo].[dal_MeasurementUnits__Select]
	@IndexedIdsJson  NVARCHAR(MAX),
	@MeasurementUnitsResultJson  NVARCHAR(MAX) OUTPUT
AS
SELECT @MeasurementUnitsResultJson = (
		SELECT
			T.[Index], MU.[Id], MU.[UnitType], MU.[Name], MU.[Description], MU.[UnitAmount], MU.[BaseAmount], MU.[IsActive], MU.[Code], 
			MU.[CreatedAt], MU.[CreatedBy], MU.[ModifiedAt], MU.[ModifiedBy], N'Unchanged' As [EntityState]
		FROM dbo.MeasurementUnits MU JOIN (
			SELECT [Index], [Id] 
			FROM OpenJson(@IndexedIdsJson)
			WITH ([Index] INT '$.Index', [Id] INT '$.Id')
		) T ON MU.Id = T.Id
		FOR JSON PATH
	);
