CREATE FUNCTION [dbo].[fn_Translate]
(
	@Key nvarchar(255)
)
RETURNS nvarchar(2048)
AS
BEGIN
	DECLARE @Result nvarchar(2048), @Language nchar(2);
	SELECT @Language = dbo.fn_Language();
	SELECT @Result = Singular 
	FROM dbo.Translations 
	WHERE [Key] = @Key
	AND [Language] = @Language;
	IF @Result IS NULL
		IF @Language <> N'EN'
			SELECT @Result = Singular FROM dbo.Translations 
			WHERE [Key] = @Key
			AND [Language] = N'EN';
	-- if not translated, return the key itself.
	RETURN ISNULL(@Result, @Key);
END;
	
