CREATE PROCEDURE [dbo].[api_Documents__Submit]
	@Documents [dbo].[IndexedIdList] READONLY,
	@ValidationErrorsJson NVARCHAR(MAX) OUTPUT,
	@ReturnEntities bit = 1,
	@DocumentsResultJson NVARCHAR(MAX) OUTPUT,
	@LinesResultJson NVARCHAR(MAX) OUTPUT,
	@EntriesResultJson NVARCHAR(MAX) OUTPUT
AS
BEGIN
	DECLARE @Ids [dbo].[IntegerList];
	-- if all documents are already submitted, return
	IF NOT EXISTS(SELECT * FROM [dbo].[Documents] 
		WHERE [Id] IN (SELECT [Id] FROM @Documents) AND Mode <> N'Submitted')
		RETURN;

	-- Validate
	EXEC [dbo].[bll_Documents_Validate__Submit]
		@Documents = @Documents,
		@ValidationErrorsJson = @ValidationErrorsJson OUTPUT;
			
	IF @ValidationErrorsJson IS NOT NULL
		RETURN;

	EXEC [dbo].[dal_Documents_Mode__Update]	@Documents = @Documents, @Mode = N'Submitted';

	IF (@ReturnEntities = 1)
	BEGIN
		INSERT INTO @Ids([Id])
		SELECT [Id] 
		FROM @Documents;

		EXEC [dbo].[dal_Documents__Select] 
			@Ids = @Ids, 
			@DocumentsResultJson = @DocumentsResultJson OUTPUT,
			@LinesResultJson = @LinesResultJson OUTPUT,
			@EntriesResultJson = @EntriesResultJson OUTPUT
	END
END;