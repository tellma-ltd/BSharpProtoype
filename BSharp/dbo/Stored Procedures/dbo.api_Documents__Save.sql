CREATE PROCEDURE [dbo].[api_Documents__Save]
	@Documents [dbo].[DocumentList] READONLY,
	@DocumentLineTypes [dbo].[DocumentLineTypeList] READONLY,
	@Lines [dbo].[LineList] READONLY, 
	@Entries [dbo].[EntryList] READONLY,
	@ValidationErrorsJson NVARCHAR(MAX) OUTPUT,
	@ReturnEntities bit = 1,
	@ResultJson NVARCHAR(MAX) = NULL OUTPUT
AS
BEGIN
	DECLARE @IndexedIdsJson NVARCHAR(MAX), @Ids [dbo].[IntegerList];
	DECLARE @DocumentsLocal [dbo].[DocumentList], @LinesLocal [dbo].[LineList], @EntriesLocal [dbo].[EntryList];

	EXEC [dbo].[bll_Documents__Fill] -- UI logic to fill missing fields
		@Documents = @Documents,
		@DocumentLineTypes = @DocumentLineTypes,
		@Lines = @Lines,
		@Entries = @Entries,
		@ResultJson = @ResultJson OUTPUT;

	INSERT INTO @DocumentsLocal SELECT * FROM dbo.[fw_Documents__Json](@ResultJson);
	INSERT INTO @LinesLocal SELECT * FROM dbo.[fw_Lines__Json](@ResultJson);
	INSERT INTO @EntriesLocal SELECT * FROM dbo.[fw_Entries__Json](@ResultJson);

	--Validate Domain rules
	EXEC [dbo].[bll_Documents_Validate__Save]
		@Documents = @DocumentsLocal,
		@Lines = @LinesLocal,
		@Entries = @EntriesLocal,
		@ValidationErrorsJson = @ValidationErrorsJson OUTPUT;

	IF @ValidationErrorsJson IS NOT NULL
		RETURN;

	-- Validate business rules (read from the table)

	EXEC [dbo].[dal_Documents__Save]
		@Documents = @DocumentsLocal,
		@Lines = @LinesLocal,
		@Entries = @EntriesLocal,
		@IndexedIdsJson = @IndexedIdsJson OUTPUT;

	IF (@ReturnEntities = 1)
	BEGIN
		INSERT INTO @Ids([Id])
		SELECT [Id] 
		FROM OpenJson(@IndexedIdsJson) WITH ([Index] INT, [Id] INT);

		EXEC [dbo].[dal_Documents__Select] @Ids = @Ids, @ResultJson = @ResultJson OUTPUT;
	END;
END;