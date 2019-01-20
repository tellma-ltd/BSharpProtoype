CREATE FUNCTION [dbo].[fn_Settings] (
	@Field NVARCHAR(255)
)
RETURNS NVARCHAR(255)
AS
BEGIN
	DECLARE @Result NVARCHAR(255)

	SELECT @Result = Value
	FROM [dbo].Settings
	WHERE [Field] = @Field

	RETURN @Result;
END;