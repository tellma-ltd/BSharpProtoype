CREATE FUNCTION [dbo].[fn_FunctionalCurrency]()
RETURNS UNIQUEIDENTIFIER
AS
BEGIN
	DECLARE @Result UNIQUEIDENTIFIER;

	SELECT @Result = FunctionalCurrencyId
	FROM dbo.Settings
	
	RETURN @Result;
END;