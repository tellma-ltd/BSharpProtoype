CREATE PROCEDURE [dbo].[api_Settings__Save]
	@Settings [SettingForSaveList] READONLY,
	@ValidationErrorsJson NVARCHAR(MAX) OUTPUT,
	@ReturnEntities bit = 1,
	@SettingsResultJson  NVARCHAR(MAX) OUTPUT
AS
BEGIN
SET NOCOUNT ON;
DECLARE @FieldListJson NVARCHAR(MAX);

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
		SELECT @FieldListJson = (
			SELECT [Field] FROM @Settings
			FOR JSON PATH
		)
		EXEC [dbo].[dal_Settings__Select] 
			@FieldListJson = @FieldListJson, @SettingsResultJson = @SettingsResultJson OUTPUT
	END
END