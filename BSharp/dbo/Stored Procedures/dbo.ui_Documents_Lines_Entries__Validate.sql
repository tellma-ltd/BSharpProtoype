CREATE PROCEDURE [dbo].[ui_Documents_Lines_Entries__Validate]
	@Documents DocumentList READONLY,
	@Lines LineList READONLY,
	@Entries EntryList READONLY
AS
DECLARE @ValidationErrors ValidationErrorList;

IF NOT EXISTS(SELECT * FROM @Documents)
INSERT INTO @ValidationErrors([Path], ErrorName)
SELECT N'', 'DocumentCollectionIsEmpty';

SELECT [Path], ErrorName
FROM @ValidationErrors;
	
