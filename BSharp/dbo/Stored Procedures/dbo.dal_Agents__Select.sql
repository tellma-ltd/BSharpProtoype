CREATE PROCEDURE [dbo].[dal_Agents__Select]
	@Ids [dbo].[IntegerList] READONLY,
	@ResultsJson NVARCHAR(MAX) OUTPUT
AS
	SELECT @ResultsJson = (
		SELECT [Id], [AgentType], [Name], [Code], [Address], [BirthDateTime], IsActive, [CreatedAt], [CreatedBy], [ModifiedAt], [ModifiedBy],
				[IsRelated], [UserId], [TaxIdentificationNumber], [Title], [Gender], N'Unchanged' As [EntityState]
		FROM [dbo].[Custodies]
		WHERE CustodyType = N'Agent'
		AND [Id] IN (SELECT [Id] FROM @Ids)
		FOR JSON PATH
	);