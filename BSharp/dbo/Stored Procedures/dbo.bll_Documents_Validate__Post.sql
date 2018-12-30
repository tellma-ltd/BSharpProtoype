CREATE PROCEDURE [dbo].[bll_Documents_Validate__Post]
	@Documents [dbo].[IndexedIdList] READONLY,
	@ValidationErrorsJson NVARCHAR(MAX) OUTPUT
AS
SET NOCOUNT ON;
	DECLARE @ValidationErrors [dbo].[ValidationErrorList];
	DECLARE @Now DATETIMEOFFSET(7) = SYSDATETIMEOFFSET();

	-- Cannot post unless in submitted mode
	INSERT INTO @ValidationErrors([Key], [ErrorName], [Argument1], [Argument2], [Argument3], [Argument4], [Argument5]) 
	SELECT
		'[' + CAST(FE.[Index] AS NVARCHAR(255)) + '].Mode' As [Key], N'Error_TheDocument0IsIn1Mode' As [ErrorName],
		BE.[SerialNumber] AS Argument1, BE.[Mode] AS Argument2, NULL AS Argument3, NULL AS Argument4, NULL AS Argument5
	FROM @Documents FE
	JOIN [dbo].[Documents] BE ON FE.[Id] = BE.[Id]
	WHERE BE.Mode <> N'Submitted';

	-- Cannot post without having the necessary signatures

	SELECT @ValidationErrorsJson = (SELECT * FROM @ValidationErrors	FOR JSON PATH);