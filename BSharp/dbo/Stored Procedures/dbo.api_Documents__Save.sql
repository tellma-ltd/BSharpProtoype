CREATE PROCEDURE [dbo].[api_Documents__Save]
	@Documents [dbo].DocumentForSaveList READONLY, 
	@Lines [dbo].LineForSaveList READONLY, 
	@Entries [dbo].EntryForSaveList READONLY,
	@WideLines [dbo].WideLineForSaveList READONLY,
	@ValidationErrorsJson NVARCHAR(MAX) OUTPUT,
	@ReturnEntities bit = 1,
	@DocumentsResultJson NVARCHAR(MAX) OUTPUT,
	@LinesResultJson NVARCHAR(MAX) OUTPUT,
	@EntriesResultJson NVARCHAR(MAX) OUTPUT
AS
BEGIN
DECLARE @IndexedIdsJson NVARCHAR(MAX), @Ids [dbo].[IntegerList];
DECLARE @DocumentsLocal [dbo].DocumentForSaveList2 , @LinesLocal [dbo].LineForSaveList2, @EntriesLocal [dbo].EntryForSaveList2, @WideLinesLocal [dbo].WideLineForSaveList2;
DECLARE @DocumentsLocalResultJson NVARCHAR(MAX), @LinesLocalResultJson NVARCHAR(MAX), @EntriesLocalResultJson NVARCHAR(MAX);
INSERT INTO @DocumentsLocal SELECT * FROM @Documents;
INSERT INTO @LinesLocal SELECT * FROM @Lines
INSERT INTO @EntriesLocal SELECT * FROM @Entries;
INSERT INTO @WideLinesLocal SELECT * FROM @WideLines;
	-- Fill Lines
--SELECT * FROM @DocumentsLocal; SELECT * FROM @LinesLocal; SELECT * FROM @EntriesLocal;
	EXEC [dbo].[bll_Documents__Fill] -- UI logic to fill missing fields
		@Documents = @DocumentsLocal, 
		@Lines = @LinesLocal,
		@Entries = @EntriesLocal,
		@WideLines = @WideLinesLocal,
		@DocumentsResultJson = @DocumentsLocalResultJson OUTPUT,
		@LinesResultJson = @LinesLocalResultJson OUTPUT,
		@EntriesResultJson = @EntriesLocalResultJson OUTPUT;

	--SELECT * FROM dbo.ft2_Documents__Json(@DocumentsLocalResultJson);
	DELETE FROM @DocumentsLocal; INSERT INTO @DocumentsLocal SELECT * FROM dbo.ft2_Documents__Json(@DocumentsLocalResultJson);
	DELETE FROM @LinesLocal; INSERT INTO @LinesLocal SELECT * FROM dbo.ft2_Lines__Json(@LinesLocalResultJson);
	DELETE FROM @EntriesLocal; INSERT INTO @EntriesLocal SELECT * FROM dbo.ft2_Entries__Json(@EntriesLocalResultJson);

SELECT * FROM @DocumentsLocal order by [Index]; 
SELECT * FROM @LinesLocal order by DocumentIndex, [Index]; SELECT * FROM @EntriesLocal order by LineIndex, [Index];

	-- Validate
	EXEC [dbo].[bll_Documents_Save__Validate]
		@Documents = @DocumentsLocal,
		@Lines = @LinesLocal,
		@Entries = @EntriesLocal,
		@ValidationErrorsJson = @ValidationErrorsJson OUTPUT

	IF @ValidationErrorsJson IS NOT NULL
		RETURN;

	EXEC [dbo].[dal_Documents__Save]
		@Documents = @DocumentsLocal,
		@Lines = @LinesLocal,
		@Entries = @EntriesLocal,
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