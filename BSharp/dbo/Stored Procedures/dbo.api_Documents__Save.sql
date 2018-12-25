CREATE PROCEDURE [dbo].[api_Documents__Save]
	@Documents [dbo].DocumentForSaveList READONLY, 
	@Lines [dbo].LineForSaveList READONLY, 
	@Entries [dbo].EntryForSaveList READONLY,
	@ValidationErrorsJson NVARCHAR(MAX) OUTPUT,
	@ReturnEntities bit = 1,
	@DocumentsResultJson NVARCHAR(MAX) OUTPUT,
	@LinesResultJson NVARCHAR(MAX) OUTPUT,
	@EntriesResultJson NVARCHAR(MAX) OUTPUT
AS
BEGIN
DECLARE @IndexedIdsJson NVARCHAR(MAX), @Ids [dbo].[IntegerList];
	-- Validate
	EXEC [dbo].[bll_Documents_Save__Validate]
		@Documents = @Documents,
		@Lines = @Lines,
		@Entries = @Entries,
		@ValidationErrorsJson = @ValidationErrorsJson OUTPUT

	IF @ValidationErrorsJson IS NOT NULL
		RETURN;

	EXEC [dbo].[dal_Documents__Save]
		@Documents = @Documents,
		@Lines = @Lines,
		@Entries = @Entries,
		@IndexedIdsJson = @IndexedIdsJson OUTPUT

	IF (@ReturnEntities = 1)
	BEGIN
		INSERT INTO @Ids([Id])
		SELECT [Id] 
		FROM OpenJson(@IndexedIdsJson)
		WITH ([Index] INT '$.Index', [Id] INT '$.Id');

		EXEC [dbo].[dal_Documents__Select] 
			@Ids = @Ids, 
			@DocumentsResultJson = @DocumentsResultJson OUTPUT,
			@LinesResultJson = @LinesResultJson OUTPUT,
			@EntriesResultJson = @EntriesResultJson OUTPUT;
	END;
END;