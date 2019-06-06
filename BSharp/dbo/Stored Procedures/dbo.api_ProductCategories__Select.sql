CREATE PROCEDURE [dbo].[api_ProductCategories__Select]
AS
BEGIN
	SELECT [Id], [ParentId], [Level], [Name], [Code], [Node].ToString() As NodePath, [ParentNode].ToString() As ParentNodePath
	FROM dbo.ProductCategories
	ORDER BY [Node];
END;