CREATE FUNCTION [dbo].[Resource](@EntryNumber tinyint, @Entries EntryList READONLY)
RETURNS int
AS
BEGIN
	DECLARE @Result int

	SELECT @Result = ResourceId
	FROM @Entries
	WHERE EntryNumber = @EntryNumber

	RETURN @Result

END