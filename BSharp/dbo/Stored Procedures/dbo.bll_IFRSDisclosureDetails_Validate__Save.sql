CREATE PROCEDURE [dbo].[bll_IfrsDisclosureDetails_Validate__Save]
	@Entities [IfrsDisclosureDetailList] READONLY,
	@ValidationErrorsJson NVARCHAR(MAX) OUTPUT
AS
SET NOCOUNT ON;
	DECLARE @ValidationErrors [dbo].[ValidationErrorList];

	-- Field must be unique
	INSERT INTO @ValidationErrors([Key], [ErrorName], [Argument1], [Argument2], [Argument3], [Argument4], [Argument5]) 
	SELECT '[' + CAST(FE.[Index] AS NVARCHAR (255)) + '].Index' As [Key], N'Error_TheConcept0AndValidDate1AreUsed' As [ErrorName],
		FE.[IfrsDisclosureId] AS Argument1, FE.[ValidSince] AS Argument2, NULL AS Argument3, NULL AS Argument4, NULL AS Argument5
	FROM @Entities FE 
	JOIN [dbo].[IfrsDisclosureDetails] BE 
	ON FE.[IfrsDisclosureId] = BE.[IfrsDisclosureId]
	AND FE.[ValidSince] = BE.[ValidSince]
	WHERE (FE.EntityState = N'Inserted');

	SELECT @ValidationErrorsJson = (SELECT * FROM @ValidationErrors	FOR JSON PATH);