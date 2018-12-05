CREATE FUNCTION [dbo].[fn_Translate]
(
	@Key nvarchar(255)
)
RETURNS nvarchar(2048)
AS
BEGIN
	DECLARE @Result nvarchar(2048), @Culture NVARCHAR(255);
	SELECT @Culture = [dbo].fn_Culture();
	SELECT @Result = [Value] 
	FROM [dbo].Translations 
	WHERE [Name] = @Key
	AND [Culture] = @Culture;
	IF @Result IS NULL
		IF @Culture <> N'EN'
			SELECT @Result = [Value] FROM [dbo].Translations 
			WHERE [Name] = @Key
			AND [Culture] = N'EN';
	-- if not translated, return the key itself.
	RETURN ISNULL(@Result, @Key);
END;
	
