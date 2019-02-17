CREATE FUNCTION [dbo].[fn_FunctionalCurrency]()
RETURNS int
AS
BEGIN
	DECLARE @Result int

	SELECT @Result = R.Id
	FROM [dbo].Resources R
	WHERE SystemCode = N'FunctionalCurrency'

/*	
	SELECT @Result = FunctionalCurrencyId
	FROM dbo.Settings
*/
	RETURN @Result;
END;