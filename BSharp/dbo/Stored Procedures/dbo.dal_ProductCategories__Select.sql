CREATE PROCEDURE [dbo].[dal_ProductCategories__Select]
	@Ids [dbo].[IntegerList] READONLY
AS
	SELECT
		[Id], [ParentId], [Name], [Name2], [Name3], [IsActive], [Code],
		(SELECT COUNT(*) FROM [dbo].[ProductCategories]
		WHERE [Node].IsDescendantOf(PC.[Node]) = 1) As ChildCount,
		[CreatedAt], [CreatedById], [ModifiedAt], [ModifiedById]
	FROM [dbo].[ProductCategories] PC
	WHERE [Id] IN (SELECT [Id] FROM @Ids);