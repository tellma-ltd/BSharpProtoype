CREATE PROCEDURE [dbo].[dal_Agents__Select]
	@Ids [dbo].[IntegerList] READONLY,
	@ResultsJson NVARCHAR(MAX) OUTPUT
AS
	SELECT @ResultsJson = (
		SELECT [Id], [PersonType], [Name], [Name2], [Code], [BirthDateTime], IsActive, [CreatedAt], [CreatedById], [ModifiedAt], [ModifiedById],
				[IsRelated], [TaxIdentificationNumber], [Title], [Gender], N'Unchanged' As [EntityState]
		FROM [dbo].[Agents]
		WHERE [RelationType] = N'Agent'
		AND [Id] IN (SELECT [Id] FROM @Ids)
		FOR JSON PATH
	);