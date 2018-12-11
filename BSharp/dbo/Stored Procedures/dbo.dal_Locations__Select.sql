CREATE PROCEDURE [dbo].[dal_Locations__Select]
	@IndexedIds dbo.IndexedIdList READONLY,
	@LocationsResultJson  NVARCHAR(MAX) OUTPUT
AS
SELECT @LocationsResultJson =	(
		SELECT T.[Index], C.[Id], L.[LocationType], C.[Name], C.[Code], C.[Address], C.[BirthDateTime], C.IsActive, C.[CreatedAt], C.[CreatedBy], C.[ModifiedAt], C.[ModifiedBy],
				L.CustodianId, N'Unchanged' As [EntityState]
		FROM [dbo].Locations L JOIN (
			SELECT [Index], [Id] 
			FROM  @IndexedIds
		) T ON L.Id = T.Id
		JOIN [dbo].Custodies C ON L.Id = C.Id
		FOR JSON PATH
	);