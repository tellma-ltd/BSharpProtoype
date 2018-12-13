CREATE PROCEDURE [dbo].[api_Settings__Save]
	@Settings [SettingForSaveList] READONLY,
	@ValidationErrorsJson NVARCHAR(MAX) OUTPUT,
	@ReturnEntities bit = 1,
	@SettingsResultJson NVARCHAR(MAX) OUTPUT
AS
BEGIN
SET NOCOUNT ON;
DECLARE @FieldList dbo.StringList;

-- Validate
	EXEC [dbo].[bll_Settings__Validate]
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
			@FieldList = @FieldList, @SettingsResultJson = @SettingsResultJson OUTPUT;
	END
END