CREATE PROCEDURE [dbo].[bll_ProductCategories_Validate__Delete]
	@Entities [IndexedIdList] READONLY,
	@ValidationErrorsJson NVARCHAR(MAX) OUTPUT
AS
SET NOCOUNT ON;
	DECLARE @ValidationErrors [dbo].[ValidationErrorList];
	WITH DeletedSet AS
	(
		SELECT E.[Index], T.[Node], T.[ParentNode]
		FROM dbo.ProductCategories T 
		JOIN @Entities E ON T.[Id] = E.[Id]
	)
	INSERT INTO @ValidationErrors([Key], [ErrorName], [Argument1])
    SELECT DISTINCT '[' + CAST(S.[Index] AS NVARCHAR (255)) + ']' As [Key], N'Error_CannotDeleteNodeWithCHildren' As [ErrorName], NULL As [Argument1]
	FROM [dbo].[ProductCategories] T -- get me every node in the table
	JOIN DeletedSet S ON T.[ParentNode] = S.[Node] -- whose parent is to be deleted
	WHERE T.[Node] NOT IN (SELECT [Node] FROM DeletedSet) -- but it is not going to be deleted
	OPTION(HASH JOIN);

	SELECT @ValidationErrorsJson = 
	(
		SELECT *
		FROM @ValidationErrors
		FOR JSON PATH
	);