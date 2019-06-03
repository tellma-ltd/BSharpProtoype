CREATE PROCEDURE [dbo].[dal_ProductCategories__Save]
	@Entities [ProductCategoryList] READONLY,
	@IndexedIdsJson NVARCHAR(MAX) OUTPUT
AS
SET NOCOUNT ON;
	DECLARE @IndexedIds [dbo].[IndexedIdList], @Children [Tree];
	DECLARE @Now DATETIMEOFFSET(7) = SYSDATETIMEOFFSET();
	DECLARE @UserId INT = CONVERT(INT, SESSION_CONTEXT(N'UserId'));

	DECLARE @EntitiesLocal [ProductCategoryList];
	INSERT INTO @EntitiesLocal SELECT * FROM @Entities;
	-- For items with known Id, get the Node from the database
	UPDATE E
	SET E.[Node] = T.[Node]
	FROM @EntitiesLocal E JOIN dbo.ProductCategories T ON T.Id = E.Id;
	-- For items with known ParentId, get the Parent Node from the database
	UPDATE E
	SET E.[ParentNode] = T.[Node]
	FROM @EntitiesLocal E JOIN dbo.ProductCategories T ON T.Id = E.ParentId;
-- For items with unknown Parent, set them as root, or define Parent as '/'
	UPDATE @EntitiesLocal
	SET [ParentNode] = HIERARCHYID::GetRoot()
	WHERE [ParentNode] IS NULL AND ParentIndex IS NULL;

--	We run the following recursive code, if we are filling the table for the first time
	IF NOT EXISTS(SELECT * FROM dbo.ProductCategories)
	BEGIN
		-- The recursive node does NOT rely on ParentNode.
		INSERT INTO  @Children ([Index], [ParentIndex], [Num])
		SELECT [Index], [ParentIndex], ROW_NUMBER() OVER (PARTITION BY [ParentIndex] ORDER BY [ParentIndex])   
		FROM @EntitiesLocal;

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
		FROM @EntitiesLocal E JOIN Paths P ON E.[Index] = P.[Index];
	END
	ELSE BEGIN -- We run the iterative code, if the table already has items
		-- For items with unknown Id, but known parent node, generate the child node.
		WHILE Exists(SELECT * FROM @EntitiesLocal WHERE [Node] IS NULL)
		BEGIN
			DECLARE @FirstParentedItemIndex INT, @ParentNode HIERARCHYID, @LastChild HIERARCHYID;
			
			-- Dissiminate the Parent Node to children
			UPDATE E1
			SET E1.[ParentNode] = E2.[Node]
			FROM @EntitiesLocal E1 JOIN @EntitiesLocal E2 ON E1.[ParentIndex] = E2.[Index]
			WHERE E1.[ParentNode] IS NULL AND E2.[Node] IS NOT NULL;

			-- Get the first new item whose parent node is defined
			SELECT @FirstParentedItemIndex = MIN([Index])		
			FROM @EntitiesLocal E
			WHERE [Node] IS NULL AND [ParentNode] IS NOT NULL

			-- Get the Parent node for the first parented item
			SELECT @ParentNode = ParentNode FROM @EntitiesLocal WHERE [Index] = @FirstParentedItemIndex;

			-- Get the last child of that parent
			SELECT @LastChild = MAX([Node]) FROM (
				SELECT [Node] FROM @EntitiesLocal WHERE ParentNode = @ParentNode AND [Node] IS NOT NULL
				UNION
				SELECT [Node] FROM dbo.ProductCategories WHERE ParentNode = @ParentNode
			) AS EUT;

			-- Make the new node after that child
			UPDATE @EntitiesLocal
			SET [Node] = @ParentNode.GetDescendant(@LastChild, NULL)
			WHERE [Index] = @FirstParentedItemIndex
		END
	END
	-- Deletions, if already used, we should deactivate instead
	DELETE FROM [dbo].[ProductCategories]
	WHERE [Id] IN (SELECT [Id] FROM @EntitiesLocal WHERE [EntityState] = N'Deleted');

	INSERT INTO @IndexedIds([Index], [Id])
	SELECT x.[Index], x.[Id]
	FROM
	(
		MERGE INTO [dbo].[ProductCategories] AS t
		USING (
			SELECT [Index], [Id], [Node], [Name], [Name2], [Name3], [Code], [EntityState]
			FROM @EntitiesLocal 
			WHERE [EntityState] IN (N'Inserted', N'Updated')
		) AS s ON (t.Id = s.Id)
		WHEN MATCHED 
		THEN
			UPDATE SET
				t.[Node]			= s.[Node],
				t.[Name]			= s.[Name],
				t.[Name2]			= s.[Name2],
				t.[Name3]			= s.[Name3],
				t.[Code]			= s.[Code],
				t.[ModifiedAt]		= @Now,
				t.[ModifiedById]	= @UserId
		WHEN NOT MATCHED THEN
			INSERT ([Node],		[Name],	[Name2],	[Name3], [Code])
			VALUES (s.[Node], s.[Name], s.[Name2], s.[Name3], s.[Code])
		OUTPUT s.[Index], inserted.[Id]
	) As x
	OPTION (RECOMPILE);

	SELECT @IndexedIdsJson = (SELECT * FROM @IndexedIds FOR JSON PATH);