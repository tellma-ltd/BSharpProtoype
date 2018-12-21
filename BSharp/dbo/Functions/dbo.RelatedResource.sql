CREATE FUNCTION [dbo].[RelatedResource](@EntryNumber tinyint, @Entries EntryList READONLY)
RETURNS int
AS
BEGIN
	DECLARE @Result int

	SELECT @Result = RelatedResourceId
	FROM @Entries
	WHERE EntryNumber = @EntryNumber

	RETURN @Result

END