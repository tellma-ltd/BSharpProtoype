CREATE PROCEDURE [dbo].[bll_Locations__Validate]
	@Locations [LocationForSaveList] READONLY,
	@ValidationErrorsJson NVARCHAR(MAX) OUTPUT
AS
SET NOCOUNT ON;
	DECLARE @ValidationErrors ValidationErrorList;

	-- Code must be unique
	INSERT INTO @ValidationErrors([Key], [ErrorName], [Argument1], [Argument2], [Argument3], [Argument4], [Argument5]) 
	SELECT '[' + CAST(FE.[Index] AS NVARCHAR(255)) + '].Code' As [Key], N'TheCode{{0}}IsUsed' As [ErrorName],
		FE.Code AS Argument1, NULL AS Argument2,NULL AS Argument3,NULL AS Argument4, NULL AS Argument5
	FROM @Locations FE 
	JOIN [dbo].Custodies BE ON FE.Code = BE.Code
	WHERE (FE.Id IS NULL) OR (FE.Id <> BE.Id)

	-- Custodian must be active
	INSERT INTO @ValidationErrors([Key], [ErrorName], [Argument1], [Argument2], [Argument3], [Argument4], [Argument5]) 
	SELECT '[' + CAST(FE.[Index] AS NVARCHAR(255)) + '].CustodianId' As [Key], N'TheCustodian{{0}}IsInactive' As [ErrorName],
		FE.CustodianId AS Argument1, NULL AS Argument2,NULL AS Argument3,NULL AS Argument4, NULL AS Argument5
	FROM @Locations FE 
	JOIN [dbo].Custodies BE ON FE.CustodianId = BE.Id
	WHERE (BE.IsActive = 0)
	
	SELECT @ValidationErrorsJson = 
	(
		SELECT [Key], [ErrorName], [Argument1], [Argument2], [Argument3], [Argument4], [Argument5]
		FROM @ValidationErrors
		FOR JSON PATH
	);