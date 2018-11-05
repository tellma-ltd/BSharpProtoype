
CREATE FUNCTION [dbo].[Value](@EntryNumber tinyint, @Entries EntryList READONLY)
RETURNS money
AS
BEGIN
	DECLARE @Result money

	SELECT @Result = [Value]
	FROM @Entries
	WHERE EntryNumber = @EntryNumber

	RETURN @Result
END
