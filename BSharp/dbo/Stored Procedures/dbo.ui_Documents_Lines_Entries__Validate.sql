
CREATE PROCEDURE [dbo].[ui_Documents_Lines_Entries__Validate]
@Documents DocumentList READONLY,
@Lines LineList READONLY,
@Entries EntryList READONLY, 
@ValidationMessage nvarchar(1024) OUTPUT
AS
DECLARE @NewLine char(2) = char(13) + char(10)
SET @ValidationMessage = NULL;
