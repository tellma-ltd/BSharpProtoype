CREATE FUNCTION [dbo].[fn_CurrencyExchange]
(
	@Amount money,
	@FromCurrency char(3),
	@ToCurrency char(3)
)
RETURNS money
AS
BEGIN
	DECLARE @Result money

	SELECT @Result = @Amount * -- ordered as such to reduce rounding
		 (SELECT UnitAmount FROM UnitsOfMeasure WHERE Id = @ToCurrency) * (SELECT BaseAmount FROM UnitsOfMeasure WHERE Id = @FromCurrency) /
		 ((SELECT UnitAmount FROM UnitsOfMeasure WHERE Id = @FromCurrency) * (SELECT BaseAmount FROM UnitsOfMeasure WHERE Id = @ToCurrency))
	RETURN @Result

END

