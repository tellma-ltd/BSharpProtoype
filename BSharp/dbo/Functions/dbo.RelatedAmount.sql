CREATE FUNCTION [dbo].[RelatedAmount](@EntryNumber tinyint, @Entries EntryList READONLY)
RETURNS money
AS
BEGIN
	DECLARE @Result money

	SELECT @Result = RelatedAmount
	FROM @Entries
	WHERE EntryNumber = @EntryNumber

	RETURN @Result

END