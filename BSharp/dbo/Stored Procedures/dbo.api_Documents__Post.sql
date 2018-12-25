CREATE PROCEDURE [dbo].[api_Documents__Post]
	@Documents [dbo].[IndexedIdForSaveList] READONLY,
	@ValidationErrorsJson NVARCHAR(MAX) OUTPUT,
	@ReturnEntities bit = 1,
	@DocumentsResultJson NVARCHAR(MAX) OUTPUT,
	@LinesResultJson NVARCHAR(MAX) OUTPUT,
	@EntriesResultJson NVARCHAR(MAX) OUTPUT
AS
BEGIN
	DECLARE @Ids [dbo].[IntegerList];
	IF NOT EXISTS(SELECT * FROM [dbo].[Documents] 
		WHERE [Id] IN (SELECT [Id] FROM @Documents) AND Mode <> N'Posted')
		RETURN;

	-- Validate, checking available signatures for transaction type
	EXEC [dbo].[bll_Documents_Post__Validate]
		@Documents = @Documents,
		@ValidationErrorsJson = @ValidationErrorsJson OUTPUT
			
	IF @ValidationErrorsJson IS NOT NULL
		RETURN;

	EXEC [dbo].[dal_Documents_Mode__Update]	@Documents = @Documents, @Mode = N'Posted';

	IF (@ReturnEntities = 1)
	BEGIN
		INSERT INTO @Ids([Id])
		SELECT [Id] 
		FROM @Documents;

		EXEC [dbo].[dal_Documents__Select] 
			@Ids = @Ids, 
			@DocumentsResultJson = @DocumentsResultJson OUTPUT,
			@LinesResultJson = @LinesResultJson OUTPUT,
			@EntriesResultJson = @EntriesResultJson OUTPUT;
	END
END;