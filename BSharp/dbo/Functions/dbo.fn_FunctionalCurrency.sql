CREATE FUNCTION [dbo].[fn_FunctionalCurrency]()
RETURNS int
AS
BEGIN
	DECLARE @Result int

	SELECT @Result = R.Id
	FROM [dbo].Resources R
	JOIN [dbo].[MeasurementUnits] MU ON R.MeasurementUnitId = MU.Id
	WHERE R.ResourceType = N'Money'
	AND MU.[Code] = [dbo].fn_Settings(N'FunctionalCurrencyCode');

	RETURN @Result;
END;