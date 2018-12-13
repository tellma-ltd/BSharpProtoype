CREATE PROCEDURE [dbo].[api_Documents__Post]
	@Documents [dbo].IndexedIdList READONLY,
	@ValidationErrorsJson NVARCHAR(MAX) OUTPUT,
	@ReturnEntities bit = 1,
	@DocumentsResultJson NVARCHAR(MAX) OUTPUT,
	@LinesResultJson NVARCHAR(MAX) OUTPUT,
	@EntriesResultJson NVARCHAR(MAX) OUTPUT
AS
BEGIN
	IF NOT EXISTS(SELECT * FROM [dbo].[Documents] 
		WHERE [Id] IN (SELECT [Id] FROM @Documents) AND Mode <> N'Posted')
		RETURN;
/*
	-- Validate, checking available signatures for transaction type
	EXEC [dbo].[bll_Documents_Post__Validate]
		@Documents = @Documents,
		@ValidationErrorsJson = @ValidationErrorsJson OUTPUT
			
	IF @ValidationErrorsJson IS NOT NULL
		RETURN;
*/
EXEC [dbo].[dal_Documents_Mode__Update]	@Documents = @Documents, @Mode = N'Posted';

IF (@ReturnEntities = 1)
	EXEC [dbo].[dal_Documents_Lines__Select] 
		@IndexedIds = @Documents, 
		@DocumentsResultJson = @DocumentsResultJson OUTPUT,
		@LinesResultJson = @LinesResultJson OUTPUT,
		@EntriesResultJson = @EntriesResultJson OUTPUT;
END;