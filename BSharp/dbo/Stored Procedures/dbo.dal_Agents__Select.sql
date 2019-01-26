CREATE PROCEDURE [dbo].[dal_Agents__Select]
	@Ids [dbo].[IntegerList] READONLY,
	@ResultsJson NVARCHAR(MAX) OUTPUT
AS
	SELECT @ResultsJson = (
		SELECT [Id], [AgentType], [Name], [Name2], [Code], [Address], [BirthDateTime], IsActive, [CreatedAt], [CreatedById], [ModifiedAt], [ModifiedById],
				[IsRelated], [TaxIdentificationNumber], [Title], [Gender], N'Unchanged' As [EntityState]
		FROM [dbo].[Custodies]
		WHERE CustodyType = N'Agent'
		AND [Id] IN (SELECT [Id] FROM @Ids)
		FOR JSON PATH
	);