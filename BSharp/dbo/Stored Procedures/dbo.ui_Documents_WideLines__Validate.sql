
-- TODO: Refactor shared code between both ui
CREATE PROCEDURE [dbo].[ui_Documents_WideLines__Validate]
@Documents DocumentList READONLY,
@WideLines WideLineList READONLY,
@ValidationMessage nvarchar(1024) OUTPUT
AS
DECLARE @NewLine char(2) = char(13) + char(10)
SET @ValidationMessage = NULL;
