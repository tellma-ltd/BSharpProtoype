CREATE PROCEDURE [dbo].[bll_Roles_Validate__Save]
	@Roles [dbo].[RoleList] READONLY,
	@Permissions [dbo].[PermissionList] READONLY,
	@ValidationErrorsJson NVARCHAR(MAX) OUTPUT
AS
SET NOCOUNT ON;
	DECLARE @ValidationErrors [dbo].[ValidationErrorList];
	DECLARE @Now DATETIMEOFFSET(7) = SYSDATETIMEOFFSET();

    INSERT INTO @ValidationErrors([Key], [ErrorName], [Argument1])
    SELECT '[' + CAST([Id] AS NVARCHAR(255)) + '].Id' As [Key], N'Error_TheId0WasNotFound' As [ErrorName], CAST([Id] As NVARCHAR(255)) As [Argument1]
    FROM @Roles
    WHERE Id Is NOT NULL
	AND Id NOT IN (SELECT Id from [dbo].[Roles])
	OPTION(HASH JOIN);
		
	-- Code must not be already in the back end
	INSERT INTO @ValidationErrors([Key], [ErrorName], [Argument1], [Argument2], [Argument3], [Argument4], [Argument5]) 
	SELECT '[' + CAST(FE.[Index] AS NVARCHAR(255)) + '].Code' As [Key], N'Error_TheCode0IsUsed' As [ErrorName],
		FE.Code AS Argument1, NULL AS Argument2, NULL AS Argument3, NULL AS Argument4, NULL AS Argument5
	FROM @Roles FE 
	JOIN [dbo].Roles BE ON FE.Code = BE.Code
	WHERE FE.[Code] IS NOT NULL
	AND ((FE.[EntityState] = N'Inserted') OR (FE.Id <> BE.Id))
	OPTION(HASH JOIN);

	-- Code must not be duplicated in the uploaded list
	INSERT INTO @ValidationErrors([Key], [ErrorName], [Argument1], [Argument2], [Argument3], [Argument4], [Argument5]) 
	SELECT '[' + CAST([Index] AS NVARCHAR(255)) + '].Code' As [Key], N'Error_TheCode0IsUsedInTheList' As [ErrorName],
		[Code] AS Argument1, NULL AS Argument2, NULL AS Argument3, NULL AS Argument4, NULL AS Argument5
	FROM @Roles
	WHERE [Code] IN (
		SELECT [Code]
		FROM @Roles
		WHERE [Code] IS NOT NULL
		GROUP BY [Code]
		HAVING COUNT(*) > 1
	) OPTION(HASH JOIN);

	-- Name must not exist in the db
	INSERT INTO @ValidationErrors([Key], [ErrorName], [Argument1], [Argument2], [Argument3], [Argument4], [Argument5]) 
	SELECT '[' + CAST(FE.[Index] AS NVARCHAR(255)) + '].Name' As [Key], N'Error_TheName0IsUsed' As [ErrorName],
		FE.[Name] AS Argument1, NULL AS Argument2, NULL AS Argument3, NULL AS Argument4, NULL AS Argument5
	FROM @Roles FE 
	JOIN [dbo].Roles BE ON FE.[Name] = BE.[Name]
	WHERE (FE.[EntityState] = N'Inserted') OR (FE.Id <> BE.Id)
	OPTION(HASH JOIN);

	-- Name2 must not exist in the db
	INSERT INTO @ValidationErrors([Key], [ErrorName], [Argument1], [Argument2], [Argument3], [Argument4], [Argument5]) 
	SELECT '[' + CAST(FE.[Index] AS NVARCHAR(255)) + '].Name2' As [Key], N'Error_TheName0IsUsed' As [ErrorName],
		FE.[Name2] AS Argument1, NULL AS Argument2, NULL AS Argument3, NULL AS Argument4, NULL AS Argument5
	FROM @Roles FE 
	JOIN [dbo].Roles BE ON FE.[Name2] = BE.[Name2]
	WHERE (FE.[EntityState] = N'Inserted') OR (FE.Id <> BE.Id)
	OPTION(HASH JOIN);

	-- Name must be unique in the uploaded list
	INSERT INTO @ValidationErrors([Key], [ErrorName], [Argument1], [Argument2], [Argument3], [Argument4], [Argument5]) 
	SELECT '[' + CAST([Index] AS NVARCHAR(255)) + '].Name' As [Key], N'Error_TheName0IsUsedInTheList' As [ErrorName],
		[Name] AS Argument1, NULL AS Argument2, NULL AS Argument3, NULL AS Argument4, NULL AS Argument5
	FROM @Roles
	WHERE [Name] IN (
		SELECT [Name]
		FROM @Roles
		GROUP BY [Name]
		HAVING COUNT(*) > 1
	) OPTION(HASH JOIN);

	-- Name2 must be unique in the uploaded list
	INSERT INTO @ValidationErrors([Key], [ErrorName], [Argument1], [Argument2], [Argument3], [Argument4], [Argument5]) 
	SELECT '[' + CAST([Index] AS NVARCHAR(255)) + '].Name2' As [Key], N'Error_TheName0IsUsedInTheList' As [ErrorName],
		[Name2] AS Argument1, NULL AS Argument2, NULL AS Argument3, NULL AS Argument4, NULL AS Argument5
	FROM @Roles
	WHERE [Name2] IN (
		SELECT [Name2]
		FROM @Roles
		WHERE [Name2] IS NOT NULL
		GROUP BY [Name2]
		HAVING COUNT(*) > 1
	) OPTION(HASH JOIN);

	-- No inactive view
	INSERT INTO @ValidationErrors([Key], [ErrorName], [Argument1], [Argument2], [Argument3], [Argument4], [Argument5]) 
	SELECT '[' + CAST(P.[RoleIndex] AS NVARCHAR(255)) + '].[' + 
				CAST(P.[Index] AS NVARCHAR(255)) + '].ViewId' As [Key], N'Error_TheView0IsInactive' As [ErrorName],
				P.[ViewId] AS Argument1, NULL AS Argument2, NULL AS Argument3, NULL AS Argument4, NULL AS Argument5
	FROM @Permissions P
	JOIN [dbo].[Views] V ON P.[ViewId] = V.[Id]
	WHERE (V.IsActive = 0)
	AND (P.[EntityState] IN (N'Inserted', N'Updated'));

	SELECT @ValidationErrorsJson = (SELECT * FROM @ValidationErrors	FOR JSON PATH);