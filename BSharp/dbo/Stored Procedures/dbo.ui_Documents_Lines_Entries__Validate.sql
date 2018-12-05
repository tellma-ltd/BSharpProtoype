CREATE PROCEDURE [dbo].[ui_Documents_Lines_Entries__Validate]
	@Documents DocumentList READONLY,
	@Lines LineList READONLY,
	@Entries EntryList READONLY
AS
DECLARE @ValidationErrors ValidationErrorList;

IF NOT EXISTS(SELECT * FROM @Documents)
INSERT INTO @ValidationErrors([Key], ErrorName)
SELECT N'', 'DocumentCollectionIsEmpty';

SELECT [Key], ErrorName
FROM @ValidationErrors;
	
