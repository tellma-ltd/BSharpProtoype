CREATE PROCEDURE [dbo].[bll_Settings_Validate__Save]
	@Settings [SettingList] READONLY,
	@ValidationErrorsJson NVARCHAR(MAX) OUTPUT
AS
SET NOCOUNT ON;
	DECLARE @ValidationErrors [dbo].[ValidationErrorList];

	-- Code must be unique
	INSERT INTO @ValidationErrors([Key], [ErrorName], [Argument1], [Argument2], [Argument3], [Argument4], [Argument5]) 
	SELECT '[' + CAST(FE.[Field] AS NVARCHAR (255)) + '].Code' As [Key], N'Error_TheKey0IsUsed' As [ErrorName],
		FE.[Field] AS Argument1, NULL AS Argument2, NULL AS Argument3, NULL AS Argument4, NULL AS Argument5
	FROM @Settings FE 
	JOIN [dbo].Settings BE ON FE.[Field] = BE.[Field]
	WHERE (FE.EntityState = N'Inserted');

	SELECT @ValidationErrorsJson = (SELECT * FROM @ValidationErrors	FOR JSON PATH);