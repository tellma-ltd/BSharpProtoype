CREATE PROCEDURE [dbo].[dal_Locations__Select]
	@IndexedIdsJson  NVARCHAR(MAX),
	@LocationsResultJson  NVARCHAR(MAX) OUTPUT
AS
SELECT @LocationsResultJson =	(
		SELECT T.[Index], C.[Id], L.[LocationType], C.[Name], C.[Code], C.[Address], C.[BirthDateTime], C.IsActive, C.[CreatedAt], C.[CreatedBy], C.[ModifiedAt], C.[ModifiedBy],
				L.CustodianId, N'Unchanged' As [EntityState]
		FROM dbo.Locations L JOIN (
			SELECT [Index], [Id] 
			FROM OpenJson(@IndexedIdsJson)
			WITH ([Index] INT '$.Index', [Id] INT '$.Id')
		) T ON L.Id = T.Id
		JOIN dbo.Custodies C ON L.Id = C.Id
		FOR JSON PATH
	);