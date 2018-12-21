﻿CREATE PROCEDURE [dbo].[dal_Locations__Select]
	@Ids [dbo].[IntegerList] READONLY,
	@EntitiesResultJson NVARCHAR(MAX) OUTPUT
AS
SELECT @EntitiesResultJson = (
	SELECT C.[Id], L.[LocationType], C.[Name], C.[Code], C.[Address], C.[BirthDateTime], C.IsActive, C.[CreatedAt], C.[CreatedBy], C.[ModifiedAt], C.[ModifiedBy],
			L.CustodianId, N'Unchanged' As [EntityState]
	FROM [dbo].Locations L
	JOIN [dbo].[Custodies] C ON L.Id = C.Id
	WHERE C.[Id] IN (SELECT [Id] FROM @Ids)
	FOR JSON PATH
);