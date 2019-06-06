CREATE PROCEDURE [dbo].[bll_ProductCategories_Validate__Save]
	@Entities [dbo].[ProductCategoryList] READONLY,
	@ValidationErrorsJson NVARCHAR(MAX) OUTPUT
AS
SET NOCOUNT ON;
	DECLARE @ValidationErrors [dbo].[ValidationErrorList];

	INSERT INTO @ValidationErrors([Key], [ErrorName], [Argument1])
    SELECT '[' + CAST([Index] AS NVARCHAR (255)) + '].Id' As [Key], N'Error_CannotModifyInactiveItem' As [ErrorName], NULL As [Argument1]
    FROM @Entities
    WHERE Id IN (SELECT Id from [dbo].[ProductCategories] WHERE IsActive = 0)
	OPTION(HASH JOIN);

    -- Non Null Ids must exist
    INSERT INTO @ValidationErrors([Key], [ErrorName], [Argument1])
    SELECT '[' + CAST([Index] AS NVARCHAR (255)) + '].Id' As [Key], N'Error_TheId0WasNotFound' As [ErrorName], CAST([Id] As NVARCHAR (255)) As [Argument1]
    FROM @Entities
    WHERE Id Is NOT NULL
	AND Id NOT IN (SELECT Id from [dbo].[ProductCategories])
	OPTION(HASH JOIN);

	-- Code must not be already in the back end
	INSERT INTO @ValidationErrors([Key], [ErrorName], [Argument1], [Argument2], [Argument3], [Argument4], [Argument5]) 
	SELECT '[' + CAST(FE.[Index] AS NVARCHAR (255)) + '].Code' As [Key], N'Error_TheCode0IsUsed' As [ErrorName],
		FE.Code AS Argument1, NULL AS Argument2, NULL AS Argument3, NULL AS Argument4, NULL AS Argument5
	FROM @Entities FE 
	JOIN [dbo].[ProductCategories] BE ON FE.Code = BE.Code
	WHERE FE.[Code] IS NOT NULL
	AND ((FE.[EntityState] = N'Inserted') OR (FE.Id <> BE.Id))
	OPTION(HASH JOIN);

	-- Code must not be duplicated in the uploaded list
	INSERT INTO @ValidationErrors([Key], [ErrorName], [Argument1], [Argument2], [Argument3], [Argument4], [Argument5]) 
	SELECT '[' + CAST([Index] AS NVARCHAR (255)) + '].Code' As [Key], N'Error_TheCode0IsDuplicated' As [ErrorName],
		[Code] AS Argument1, NULL AS Argument2, NULL AS Argument3, NULL AS Argument4, NULL AS Argument5
	FROM @Entities
	WHERE [Code] IN (
		SELECT [Code]
		FROM @Entities
		WHERE [Code] IS NOT NULL
		GROUP BY [Code]
		HAVING COUNT(*) > 1
	) OPTION(HASH JOIN);

	-- Name must not exist in the db
	INSERT INTO @ValidationErrors([Key], [ErrorName], [Argument1], [Argument2], [Argument3], [Argument4], [Argument5]) 
	SELECT '[' + CAST(FE.[Index] AS NVARCHAR (255)) + '].Name' As [Key], N'Error_TheName0IsUsed' As [ErrorName],
		FE.[Name] AS Argument1, NULL AS Argument2, NULL AS Argument3, NULL AS Argument4, NULL AS Argument5
	FROM @Entities FE 
	JOIN [dbo].[ProductCategories] BE ON FE.[Name] = BE.[Name]
	WHERE (FE.[EntityState] = N'Inserted') OR (FE.Id <> BE.Id)
	OPTION(HASH JOIN);

	-- Name2 must not exist in the db
	INSERT INTO @ValidationErrors([Key], [ErrorName], [Argument1], [Argument2], [Argument3], [Argument4], [Argument5]) 
	SELECT '[' + CAST(FE.[Index] AS NVARCHAR (255)) + '].Name2' As [Key], N'Error_TheName0IsUsed' As [ErrorName],
		FE.[Name2] AS Argument1, NULL AS Argument2, NULL AS Argument3, NULL AS Argument4, NULL AS Argument5
	FROM @Entities FE 
	JOIN [dbo].[ProductCategories] BE ON FE.[Name2] = BE.[Name2]
	WHERE (FE.[EntityState] = N'Inserted') OR (FE.Id <> BE.Id)
	OPTION(HASH JOIN);

	-- Name3 must not exist in the db
	INSERT INTO @ValidationErrors([Key], [ErrorName], [Argument1], [Argument2], [Argument3], [Argument4], [Argument5]) 
	SELECT '[' + CAST(FE.[Index] AS NVARCHAR (255)) + '].Name3' As [Key], N'Error_TheName0IsUsed' As [ErrorName],
		FE.[Name3] AS Argument1, NULL AS Argument2, NULL AS Argument3, NULL AS Argument4, NULL AS Argument5
	FROM @Entities FE 
	JOIN [dbo].[ProductCategories] BE ON FE.[Name3] = BE.[Name3]
	WHERE (FE.[EntityState] = N'Inserted') OR (FE.Id <> BE.Id)
	OPTION(HASH JOIN);

	-- Name must be unique in the uploaded list
	INSERT INTO @ValidationErrors([Key], [ErrorName], [Argument1], [Argument2], [Argument3], [Argument4], [Argument5]) 
	SELECT '[' + CAST([Index] AS NVARCHAR (255)) + '].Name' As [Key], N'Error_TheName0IsDuplicated' As [ErrorName],
		[Name] AS Argument1, NULL AS Argument2, NULL AS Argument3, NULL AS Argument4, NULL AS Argument5
	FROM @Entities
	WHERE [Name] IN (
		SELECT [Name]
		FROM @Entities
		GROUP BY [Name]
		HAVING COUNT(*) > 1
	) OPTION(HASH JOIN);

	-- Name2 must be unique in the uploaded list
	INSERT INTO @ValidationErrors([Key], [ErrorName], [Argument1], [Argument2], [Argument3], [Argument4], [Argument5]) 
	SELECT '[' + CAST([Index] AS NVARCHAR (255)) + '].Name2' As [Key], N'Error_TheName0IsDuplicated' As [ErrorName],
		[Name2] AS Argument1, NULL AS Argument2, NULL AS Argument3, NULL AS Argument4, NULL AS Argument5
	FROM @Entities
	WHERE [Name2] IN (
		SELECT [Name2]
		FROM @Entities
		WHERE [Name2] IS NOT NULL
		GROUP BY [Name2]
		HAVING COUNT(*) > 1
	) OPTION(HASH JOIN);

	-- Name3 must be unique in the uploaded list
	INSERT INTO @ValidationErrors([Key], [ErrorName], [Argument1], [Argument2], [Argument3], [Argument4], [Argument5]) 
	SELECT '[' + CAST([Index] AS NVARCHAR (255)) + '].Name3' As [Key], N'Error_TheName0IsDuplicated' As [ErrorName],
		[Name3] AS Argument1, NULL AS Argument2, NULL AS Argument3, NULL AS Argument4, NULL AS Argument5
	FROM @Entities
	WHERE [Name3] IN (
		SELECT [Name3]
		FROM @Entities
		WHERE [Name3] IS NOT NULL
		GROUP BY [Name3]
		HAVING COUNT(*) > 1
	) OPTION(HASH JOIN);

	SELECT @ValidationErrorsJson = 
	(
		SELECT *
		FROM @ValidationErrors
		FOR JSON PATH
	);