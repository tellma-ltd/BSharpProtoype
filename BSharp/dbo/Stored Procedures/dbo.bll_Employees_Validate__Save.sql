CREATE PROCEDURE [dbo].[bll_Employees_Validate__Save]
	@Entities [EmployeeList] READONLY,
	@ValidationErrorsJson NVARCHAR(MAX) OUTPUT
AS
SET NOCOUNT ON;
	DECLARE @ValidationErrors [dbo].[ValidationErrorList];
	DECLARE @Language INT = dbo.fn_User__Language();

    -- Non Null Ids must exist
    INSERT INTO @ValidationErrors([Key], [ErrorName], [Argument1])
    SELECT '[' + CAST([Index] AS NVARCHAR(255)) + '].Id' As [Key], N'Error_TheId0WasNotFound' As [ErrorName], CAST([Id] As NVARCHAR(255)) As [Argument1]
    FROM @Entities
    WHERE Id Is NOT NULL AND Id NOT IN (SELECT Id from [dbo].[Agents] WHERE [RelationType] = N'Agent');

	-- Code must be unique
	INSERT INTO @ValidationErrors([Key], [ErrorName], [Argument1], [Argument2], [Argument3], [Argument4], [Argument5]) 
	SELECT '[' + CAST(FE.[Index] AS NVARCHAR(255)) + '].Code' As [Key], N'Error_TheCode0IsUsed' As [ErrorName],
		FE.Code AS Argument1, NULL AS Argument2, NULL AS Argument3, NULL AS Argument4, NULL AS Argument5
	FROM @Entities FE 
	JOIN [dbo].[Agents] BE ON FE.Code = BE.Code
	WHERE ((FE.Id IS NULL) OR (FE.Id <> BE.Id));

	SELECT @ValidationErrorsJson = (SELECT * FROM @ValidationErrors	FOR JSON PATH);