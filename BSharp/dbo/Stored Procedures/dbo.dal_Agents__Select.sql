CREATE PROCEDURE [dbo].[dal_Agents__Select]
	@Ids [dbo].[IntegerList] READONLY,
	@EntitiesResultJson NVARCHAR(MAX) OUTPUT
AS
	SELECT @EntitiesResultJson = (
		SELECT C.[Id], A.[AgentType], C.[Name], C.[Code], C.[Address], C.[BirthDateTime], C.IsActive, C.[CreatedAt], C.[CreatedBy], C.[ModifiedAt], C.[ModifiedBy],
				A.[IsRelated], A.[UserId], A.[TaxIdentificationNumber], A.[Title], A.[Gender], N'Unchanged' As [EntityState]
		FROM [dbo].Agents A
		JOIN [dbo].[Custodies] C ON A.Id = C.Id
		WHERE C.[Id] IN (SELECT [Id] FROM @Ids)
		FOR JSON PATH
	);