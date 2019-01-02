CREATE PROCEDURE [dbo].[api_Settings__Save]
	@Settings [SettingList] READONLY,
	@ValidationErrorsJson NVARCHAR(MAX) OUTPUT,
	@ReturnEntities bit = 1,
	@ResultsJson NVARCHAR(MAX) OUTPUT
AS
BEGIN
SET NOCOUNT ON;
DECLARE @FieldList dbo.StringList;

-- Validate
	EXEC [dbo].[bll_Settings_Validate__Save]
		@Settings = @Settings,
		@ValidationErrorsJson = @ValidationErrorsJson OUTPUT;

	IF @ValidationErrorsJson IS NOT NULL
		RETURN;

	EXEC [dbo].[dal_Settings__Save]
		@Settings = @Settings;
	
	IF (@ReturnEntities = 1)
	BEGIN
		INSERT INTO @FieldList
		SELECT [Field] FROM @Settings;
		
		EXEC [dbo].[dal_Settings__Select] 
			@FieldList = @FieldList, @ResultsJson = @ResultsJson OUTPUT;
	END
END;