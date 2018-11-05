
CREATE FUNCTION [dbo].[AmountConverted](@EntryNumber tinyint, @Entries EntryList READONLY)
RETURNS money
AS
BEGIN
	DECLARE @Result money

	SELECT @Result = Amount 
	FROM @Entries
	WHERE EntryNumber = @EntryNumber

/*
	SELECT @Result = dbo.fn_CurrencyExchange(Amount, ResourceId, dbo.fn_FunctionalCurrency())
	FROM @Entries 
	WHERE EntryNumber = @EntryNumber
*/
	RETURN @Result

END
