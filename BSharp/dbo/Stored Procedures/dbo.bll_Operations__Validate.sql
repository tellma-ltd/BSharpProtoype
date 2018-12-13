CREATE PROCEDURE [dbo].[bll_Operations__Validate]
	@Operations [OperationForSaveList] READONLY,
	@ValidationErrorsJson NVARCHAR(MAX) OUTPUT
AS
SET NOCOUNT ON;
	DECLARE @ValidationErrors [dbo].[ValidationErrorList];

	-- Code must be unique
	INSERT INTO @ValidationErrors([Key], [ErrorName], [Argument1], [Argument2], [Argument3], [Argument4], [Argument5]) 
	SELECT '[' + CAST(FE.[Index] AS NVARCHAR(255)) + '].Code' As [Key], N'TheCode{{0}}IsUsed' As [ErrorName],
		FE.Code AS Argument1, NULL AS Argument2, NULL AS Argument3, NULL AS Argument4, NULL AS Argument5
	FROM @Operations FE 
	JOIN [dbo].Operations BE ON FE.Code = BE.Code
	WHERE (FE.Id IS NULL) OR (FE.Id <> BE.Id);

	-- Parent Operation must be active
	INSERT INTO @ValidationErrors([Key], [ErrorName], [Argument1], [Argument2], [Argument3], [Argument4], [Argument5]) 
	SELECT '[' + CAST(FE.[Index] AS NVARCHAR(255)) + '].ParentId' As [Key], N'TheParentOperation{{0}}IsInactive' As [ErrorName],
		FE.ParentId AS Argument1, NULL AS Argument2, NULL AS Argument3, NULL AS Argument4, NULL AS Argument5
	FROM @Operations FE 
	JOIN [dbo].Operations BE ON FE.ParentId = BE.Id
	WHERE (BE.IsActive = 0);

	SELECT @ValidationErrorsJson = (SELECT * FROM @ValidationErrors	FOR JSON PATH);