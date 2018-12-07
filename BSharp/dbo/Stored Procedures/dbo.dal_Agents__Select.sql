CREATE PROCEDURE [dbo].[dal_Agents__Select]
	@IndexedIdsJson  NVARCHAR(MAX),
	@AgentsResultJson  NVARCHAR(MAX) OUTPUT
AS
SELECT @AgentsResultJson =	(
		SELECT T.[Index], C.[Id], A.[AgentType], C.[Name], C.[Code], C.[Address], C.[BirthDateTime], C.IsActive, C.[CreatedAt], C.[CreatedBy], C.[ModifiedAt], C.[ModifiedBy],
				A.[IsRelated], A.[UserId], A.[TaxIdentificationNumber], A.[Title], A.[Gender], N'Unchanged' As [EntityState]
		FROM dbo.Agents A JOIN (
			SELECT [Index], [Id] 
			FROM OpenJson(@IndexedIdsJson)
			WITH ([Index] INT '$.Index', [Id] INT '$.Id')
		) T ON A.Id = T.Id
		JOIN dbo.Custodies C ON A.Id = C.Id
		FOR JSON PATH
	);