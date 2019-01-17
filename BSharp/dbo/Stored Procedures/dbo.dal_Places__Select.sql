CREATE PROCEDURE [dbo].[dal_Places__Select]
	@Ids [dbo].[IntegerList] READONLY,
	@ResultsJson NVARCHAR(MAX) OUTPUT
AS
SELECT @ResultsJson = (
	SELECT C.[Id], L.[PlaceType], C.[Name], C.[Code], C.[Address], C.[BirthDateTime], C.IsActive, C.[CreatedAt], C.[CreatedBy], C.[ModifiedAt], C.[ModifiedBy],
			L.CustodianId, N'Unchanged' As [EntityState]
	FROM [dbo].Places L
	JOIN [dbo].[Custodies] C ON L.Id = C.Id
	WHERE C.[Id] IN (SELECT [Id] FROM @Ids)
	FOR JSON PATH
);