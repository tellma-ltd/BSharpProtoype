CREATE PROCEDURE [dbo].[ui_Documents_Lines_Entries__Validate]
@Documents DocumentList READONLY,
@Lines LineList READONLY,
@Entries EntryList READONLY
AS
DECLARE @NewLine char(2) = char(13) + char(10)
DECLARE @ValidationMessage nvarchar(2048) = NULL;

IF NOT EXISTS(SELECT * FROM @Documents)
BEGIN
	SET @ValidationMessage = ISNULL(@ValidationMessage, '') + N'No Document to save!' + @NewLine ;
	RETURN;
END;

IF EXISTS(SELECT * FROM @Entries WHERE CustodyId IS NULL)
BEGIN
	DECLARE @EntryId int
	SELECT @EntryId = min(Id) FROM @Entries WHERE CustodyId IS NULL;
	SET @ValidationMessage = ISNULL(@ValidationMessage,'') + FORMATMESSAGE(N'Entry Id  %d has null custody', @EntryId)  + @NewLine;
	RETURN;
END;
IF (@ValidationMessage IS NOT NULL)
	THROW 99999, @ValidationMessage, 1;