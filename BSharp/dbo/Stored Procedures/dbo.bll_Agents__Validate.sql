CREATE PROCEDURE [dbo].[bll_Agents__Validate]
	@Agents [AgentForSaveList] READONLY,
	@ValidationErrorsJson NVARCHAR(MAX) OUTPUT
AS
SET NOCOUNT ON;
	DECLARE @ValidationErrors ValidationErrorList;

	-- Code must be unique
	INSERT INTO @ValidationErrors([Key], [ErrorName], [Argument1], [Argument2], [Argument3], [Argument4], [Argument5]) 
	SELECT '[' + CAST(FE.[Index] AS NVARCHAR(255)) + '].Code' As [Key], N'TheCode{{0}}IsUsed' As [ErrorName],
		FE.Code AS Argument1, NULL AS Argument2, NULL AS Argument3, NULL AS Argument4, NULL AS Argument5
	FROM @Agents FE 
	JOIN [dbo].Custodies BE ON FE.Code = BE.Code
	WHERE (FE.Id IS NULL) OR (FE.Id <> BE.Id)

	-- User [Id]must be unique
	INSERT INTO @ValidationErrors([Key], [ErrorName], [Argument1], [Argument2], [Argument3], [Argument4], [Argument5]) 
	SELECT '[' + CAST(FE.[Index] AS NVARCHAR(255)) + '].UserId' As [Key], N'TheUserId{{0}}IsUsed' As [ErrorName],
		FE.Code AS Argument1, NULL AS Argument2, NULL AS Argument3, NULL AS Argument4, NULL AS Argument5
	FROM @Agents FE 
	JOIN [dbo].Agents BE ON FE.UserId = BE.UserId
	WHERE (FE.Id IS NULL) OR (FE.Id <> BE.Id)

	SELECT @ValidationErrorsJson = 
	(
		SELECT [Key], [ErrorName], [Argument1], [Argument2], [Argument3], [Argument4], [Argument5]
		FROM @ValidationErrors
		FOR JSON PATH
	);