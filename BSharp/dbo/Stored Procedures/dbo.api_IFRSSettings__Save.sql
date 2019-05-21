CREATE PROCEDURE [dbo].[api_IFRSSettings__Save]
	@IFRSSettings [IFRSSettingList] READONLY,
	@ValidationErrorsJson NVARCHAR(MAX) OUTPUT,
	@ReturnEntities bit = 1,
	@ResultsJson NVARCHAR(MAX) OUTPUT
AS
BEGIN
SET NOCOUNT ON;
DECLARE @FieldList dbo.StringList;

-- Validate
/* TODO: Debug and uncomment
	EXEC [dbo].[bll_IFRSSettings_Validate__Save]
		@IFRSSettings = @IFRSSettings,
		@ValidationErrorsJson = @ValidationErrorsJson OUTPUT;

	IF @ValidationErrorsJson IS NOT NULL
		RETURN;

	EXEC [dbo].[dal_IFRSSettings__Save]
		@IFRSSettings = @IFRSSettings;
*/	
	IF (@ReturnEntities = 1)
	BEGIN
		INSERT INTO @FieldList
		SELECT [Field] FROM @IFRSSettings;
		
		EXEC [dbo].[dal_IFRSSettings__Select] 
			@FieldList = @FieldList, @ResultsJson = @ResultsJson OUTPUT;
	END
END;