
CREATE FUNCTION [dbo].[fn_FunctionalCurrency]()
RETURNS int
AS
BEGIN
	DECLARE @Result int

	SELECT @Result = Id
	FROM [dbo].Resources
	WHERE ResourceType = N'Money'
	AND [MeasurementUnitId] = [dbo].fn_Settings(N'FunctionalCurrencyUnit');

	RETURN @Result

END
