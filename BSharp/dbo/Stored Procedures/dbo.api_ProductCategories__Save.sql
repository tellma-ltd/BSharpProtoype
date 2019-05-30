CREATE PROCEDURE [dbo].[api_ProductCategories__Save]
	@EntitiesIn [ProductCategoryList] READONLY,
	@ValidationErrorsJson NVARCHAR(MAX) OUTPUT,
	@ReturnEntities bit = 1,
	@ResultsJson NVARCHAR(MAX) OUTPUT
AS
BEGIN
SET NOCOUNT ON;
DECLARE @IndexedIdsJson NVARCHAR(MAX), @Ids [dbo].[IntegerList];
DECLARE @Entities [ProductCategoryList], @Children [Tree];
INSERT INTO @Entities SELECT * FROM @EntitiesIn;
-- Validate
/*
	EXEC [dbo].[bll_ProductCategories_Validate__Save]
		@Entities = @Entities,
		@ValidationErrorsJson = @ValidationErrorsJson OUTPUT;
*/

	-- For items with known Id, get the Node from the database
	UPDATE E
	SET E.[Node] = T.[Node]
	FROM @Entities E JOIN dbo.ProductCategories T ON T.Id = E.Id;
	-- For items with known ParentId, get the Parent Node from the database
	UPDATE E
	SET E.[ParentNode] = T.[Node]
	FROM @Entities E JOIN dbo.ProductCategories T ON T.Id = E.ParentId;
-- For items with unknown Parent, set them as root, or define Parent as '/'
	UPDATE @Entities
	SET [ParentNode] = HIERARCHYID::GetRoot()
	WHERE [ParentNode] IS NULL AND ParentIndex IS NULL;

	
--	We run the following recursive code, if we are filling the table for the first time
	IF NOT EXISTS(SELECT * FROM dbo.ProductCategories)
	BEGIN
		-- The recursive node does NOT rely on ParentNode.
		INSERT INTO  @Children ([Index], [ParentIndex], [Num])
		SELECT [Index], [ParentIndex], ROW_NUMBER() OVER (PARTITION BY [ParentIndex] ORDER BY [ParentIndex])   
		FROM @Entities;

		WITH Paths([Node], [Index])   
		AS (  
		-- This section provides the value for the roots of the hierarchy  
		SELECT CAST(('/'  + CAST(C.Num AS varchar(30)) + '/') AS HIERARCHYID) AS [Node], [Index]
		FROM @Children AS C   
		WHERE ParentIndex IS NULL   

		UNION ALL   
		-- This section provides values for all nodes except the root  
		SELECT CAST(P.[Node].ToString() + CAST(C.Num AS varchar(30)) + '/' AS HIERARCHYID), C.[Index]
		FROM @Children C
		JOIN Paths P ON C.[ParentIndex] = P.[Index]
		)
		UPDATE E
		SET E.[Node] = P.[Node]
		FROM @Entities E JOIN Paths P ON E.[Index] = P.[Index];
	END
	ELSE BEGIN -- We run the iterative code, if the table already has items
		-- For items with unknown Id, but known parent node, generate the child node.
		WHILE Exists(SELECT * FROM @Entities WHERE [Node] IS NULL)
		BEGIN
			DECLARE @FirstParentedItemIndex INT, @ParentNode HIERARCHYID, @LastChild HIERARCHYID;
			
			-- Dissiminate the Parent Node to children
			UPDATE E1
			SET E1.[ParentNode] = E2.[Node]
			FROM @Entities E1 JOIN @Entities E2 ON E1.[ParentIndex] = E2.[Index]
			WHERE E1.[ParentNode] IS NULL AND E2.[Node] IS NOT NULL;

			-- Get the first new item whose parent node is defined
			SELECT @FirstParentedItemIndex = MIN([Index])		
			FROM @Entities E
			WHERE [Node] IS NULL AND [ParentNode] IS NOT NULL

			-- Get the Parent node for the first parented item
			SELECT @ParentNode = ParentNode FROM @Entities WHERE [Index] = @FirstParentedItemIndex;

			-- Get the last child of that parent
			SELECT @LastChild = MAX([Node]) FROM (
				SELECT [Node] FROM @Entities WHERE ParentNode = @ParentNode AND [Node] IS NOT NULL
				UNION
				SELECT [Node] FROM dbo.ProductCategories WHERE ParentNode = @ParentNode
			) AS EUT;

			-- Make the new node after that child
			UPDATE @Entities
			SET [Node] = @ParentNode.GetDescendant(@LastChild, NULL)
			WHERE [Index] = @FirstParentedItemIndex
		END
	END

	IF @ValidationErrorsJson IS NOT NULL
		RETURN;

	EXEC [dbo].[dal_ProductCategories__Save]
		@Entities = @Entities,
		@IndexedIdsJson = @IndexedIdsJson OUTPUT;

	IF (@ReturnEntities = 1)
	BEGIN
		INSERT INTO @Ids([Id])
		SELECT [Id] 
		FROM OpenJson(@IndexedIdsJson) WITH ([Index] INT, [Id] INT);

		EXEC [dbo].[dal_ProductCategories__Select] 
			@Ids = @Ids, @ResultsJson = @ResultsJson OUTPUT;
	END
END;