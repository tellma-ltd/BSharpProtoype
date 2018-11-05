
CREATE FUNCTION [dbo].[Amount](@EntryNumber tinyint, @Entries EntryList READONLY)
RETURNS money
AS
BEGIN
	DECLARE @Result money

	SELECT @Result = Amount
	FROM @Entries
	WHERE EntryNumber = @EntryNumber

	RETURN @Result

END
