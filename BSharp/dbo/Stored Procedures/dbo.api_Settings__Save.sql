CREATE PROCEDURE [dbo].[api_Settings__Save]
	@Settings [SettingList] READONLY,
	@ValidationErrorsJson NVARCHAR(MAX) OUTPUT,
	@ReturnEntities bit = 1,
	@ResultsJson NVARCHAR(MAX) OUTPUT
AS
BEGIN
SET NOCOUNT ON;
DECLARE  @IndexedIdsJson NVARCHAR(MAX), @Ids [dbo].[IntegerList];

-- Validate
/*	EXEC [dbo].[bll_Settings_Validate__Save]
		@Settings = @Settings,
		@ValidationErrorsJson = @ValidationErrorsJson OUTPUT;
*/
-- TODO: use Setting data type not Table type
	IF @ValidationErrorsJson IS NOT NULL
		RETURN;
		/*
	EXEC [dbo].[dal_Settings__Save]
		@Settings = @Settings,
		@IndexedIdsJson = @IndexedIdsJson OUTPUT;
	
	IF (@ReturnEntities = 1)
	BEGIN
		INSERT INTO @Ids([Id])
		SELECT [Id] 
		FROM OpenJson(@IndexedIdsJson) WITH ([Index] INT, [Id] INT);

		EXEC [dbo].[dal_Settings__Select] 
			@Ids = @Ids, @ResultsJson = @ResultsJson OUTPUT;
	END
	*/
END;