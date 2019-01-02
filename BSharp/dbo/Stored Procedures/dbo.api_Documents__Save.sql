CREATE PROCEDURE [dbo].[api_Documents__Save]
	@Documents [dbo].[DocumentList] READONLY,
	@DocumentLineTypes [dbo].[DocumentLineTypeList] READONLY,
	@WideLines [dbo].[WideLineList] READONLY,
	@Lines [dbo].[LineList] READONLY, 
	@Entries [dbo].[EntryList] READONLY,
	@ValidationErrorsJson NVARCHAR(MAX) OUTPUT,
	@ReturnEntities bit = 1,
	@DocumentsResultJson NVARCHAR(MAX) OUTPUT,
	@LinesResultJson NVARCHAR(MAX) OUTPUT,
	@EntriesResultJson NVARCHAR(MAX) OUTPUT
	-- We need to return the WideLines and the DocumentLineTypes as well.
	-- We need to return the lines only for the Manual JV line case
AS
BEGIN
DECLARE @IndexedIdsJson NVARCHAR(MAX), @Ids [dbo].[IntegerList];
DECLARE @DocumentsLocal [dbo].[DocumentList] , @LinesLocal [dbo].[LineList], @EntriesLocal [dbo].[EntryList];
DECLARE @DocumentsLocalResultJson NVARCHAR(MAX), @LinesLocalResultJson NVARCHAR(MAX), @EntriesLocalResultJson NVARCHAR(MAX);
	-- Fill in the blanks
	EXEC [dbo].[bll_Documents__Fill] -- UI logic to fill missing fields
		@Documents = @Documents,
		@DocumentLineTypes = @DocumentLineTypes,
		@Lines = @Lines,
		@Entries = @Entries,
		@WideLines = @WideLines,
		@DocumentsResultJson = @DocumentsLocalResultJson OUTPUT,
		@LinesResultJson = @LinesLocalResultJson OUTPUT,
		@EntriesResultJson = @EntriesLocalResultJson OUTPUT;

	--SELECT * FROM dbo.[fw_Documents__Json](@DocumentsLocalResultJson) ORDER BY [Index]; 
	--SELECT * FROM dbo.[fw_Lines__Json](@LinesLocalResultJson) ORDER BY DocumentIndex, [Index];
	--SELECT * FROM dbo.[fw_Entries__Json](@EntriesLocalResultJson) ORDER BY LineIndex, [Index];

	INSERT INTO @DocumentsLocal SELECT * FROM dbo.[fw_Documents__Json](@DocumentsLocalResultJson);
	INSERT INTO @LinesLocal SELECT * FROM dbo.[fw_Lines__Json](@LinesLocalResultJson);
	INSERT INTO @EntriesLocal SELECT * FROM dbo.[fw_Entries__Json](@EntriesLocalResultJson);

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
		FROM OpenJson(@IndexedIdsJson)
		WITH ([Index] INT '$.Index', [Id] INT '$.Id');

		EXEC [dbo].[dal_Documents__Select] 
			@Ids = @Ids, 
			@DocumentsResultJson = @DocumentsResultJson OUTPUT,
			@LinesResultJson = @LinesResultJson OUTPUT,
			@EntriesResultJson = @EntriesResultJson OUTPUT;
			-- We need to return the WideLines and the DocumentLineTypes as well.
			-- We need to return the lines only for the Manual JV line case
	END;
END;