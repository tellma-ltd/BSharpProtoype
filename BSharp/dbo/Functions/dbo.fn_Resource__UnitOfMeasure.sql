CREATE FUNCTION [dbo].[fn_Resource__UnitOfMeasure]
(
	@Resource int
)
RETURNS nvarchar(5)
AS
BEGIN
	DECLARE @Result nvarchar(5)

	SELECT @Result = UnitOfMeasure
	FROM dbo.Resources
	WHERE Id = @Resource

	RETURN @Result

END