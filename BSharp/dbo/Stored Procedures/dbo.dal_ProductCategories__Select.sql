CREATE PROCEDURE [dbo].[dal_ProductCategories__Select]
	@Ids [dbo].[IntegerList] READONLY,
	@ResultsJson NVARCHAR(MAX) OUTPUT
AS
SELECT @ResultsJson =	(
	SELECT
		[Id], [Name], [IsActive], [Code],
		(Select [Id] FROM [dbo].[ProductCategories]
		WHERE [Node] = PC.[ParentNode]) AS [ParentId],
		[CreatedAt], [CreatedById], [ModifiedAt], [ModifiedById], N'Unchanged' As [EntityState]
	FROM [dbo].[ProductCategories] PC
	WHERE [Id] IN (SELECT [Id] FROM @Ids)
	FOR JSON PATH
);