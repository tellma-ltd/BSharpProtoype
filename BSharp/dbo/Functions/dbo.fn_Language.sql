CREATE FUNCTION [dbo].[fn_Language]()
RETURNS nchar(2)
AS
BEGIN
	DECLARE @Result nchar(2);

	SELECT @Result =  CONVERT(nchar(2), SESSION_CONTEXT(N'Language')); 
	
	RETURN @Result;
END