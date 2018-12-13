CREATE FUNCTION [dbo].[fn_Resource__UnitOfMeasure]
(
	@Resource int
)
RETURNS NVARCHAR(255)
AS
BEGIN
	DECLARE @Result NVARCHAR(255)

	SELECT @Result = U.Code
	FROM [dbo].[Resources] R JOIN [dbo].[MeasurementUnits] U ON R.[MeasurementUnitId] = U.Id
	AND R.TenantId = U.TenantId
	WHERE R.Id = @Resource

	RETURN @Result

END