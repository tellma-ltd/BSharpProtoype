CREATE PROCEDURE [dbo].[api_Documents_WideLines__Save]
	@Documents [dbo].DocumentForSaveList READONLY, 
	@WideLines [dbo].WideLineForSaveList READONLY, 
	@ValidationErrorsJson NVARCHAR(MAX) OUTPUT,
	@ReturnEntities bit = 1,
	@DocumentsResultJson NVARCHAR(MAX) OUTPUT,
	@WideLinesResultJson NVARCHAR(MAX) OUTPUT
AS
BEGIN
DECLARE @IndexedIdsJson NVARCHAR(MAX);
DECLARE @Lines [dbo].LineForSaveList, @Entries [dbo].EntryForSaveList;
DECLARE @LinesResultJson NVARCHAR(MAX), @EntriesResultJson NVARCHAR(MAX);

-- Validate
EXEC [dbo].[bll_Documents_Save__Validate]
	@Documents = @Documents,
	--@WideLines = @WideLines,
	--@Lines = @Lines,
	--@Entries = @Entries,
	@ValidationErrorsJson = @ValidationErrorsJson OUTPUT

IF @ValidationErrorsJson IS NOT NULL
	RETURN;

EXEC [dbo].[bll_Documents_WideLines__Fill]
	@Documents = @Documents,
	@WideLines = @WideLines,
	@LinesResultJson = @LinesResultJson OUTPUT,
	@EntriesResultJson = @EntriesResultJson OUTPUT

INSERT INTO @Lines([Id])
	SELECT [Id] 
	FROM OpenJson(@LinesResultJson)
	WITH ([Id] INT '$.Id')

INSERT INTO @Entries([Id])
	SELECT [Id] 
	FROM OpenJson(@EntriesResultJson)
	WITH ([Id] INT '$.Id')

EXEC [dbo].[dal_Documents__Save]
	@Documents = @Documents,
	@Lines = @Lines,
	@Entries = @Entries,
	@IndexedIdsJson = @IndexedIdsJson OUTPUT

IF (@ReturnEntities = 1)
	EXEC [dbo].[dal_Documents_WideLines__Select] 
		@IndexedIdsJson = @IndexedIdsJson, 
		@DocumentsResultJson = @DocumentsResultJson OUTPUT,
		@WideLinesResultJson = @WideLinesResultJson OUTPUT
END;