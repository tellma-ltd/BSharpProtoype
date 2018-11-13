CREATE FUNCTION [dbo].[fn_Settings]
(
	@Field nvarchar(50)
)
RETURNS nvarchar(50)
AS
BEGIN
	DECLARE @Result nvarchar(50)

	SELECT @Result = Value
	FROM dbo.Settings
	WHERE [Field] = @Field
	AND [TenantId] = dbo.fn_TenantId();

	RETURN @Result;

END