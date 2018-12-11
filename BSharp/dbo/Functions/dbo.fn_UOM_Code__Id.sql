CREATE FUNCTION [dbo].[fn_UOM_Code__Id]
(
	@Code NVARCHAR(255)
)
RETURNS INT
AS
BEGIN
	DECLARE @Result int;
	
	SELECT @Result = [Id] FROM [dbo].[MeasurementUnits]
	WHERE TenantId = [dbo].fn_TenantId()
	AND Code = @Code;

	RETURN @Result;
END
