CREATE FUNCTION [dbo].[fn_Culture]()
RETURNS nvarchar(50)
AS
BEGIN
	DECLARE @Result nvarchar(50);

	SELECT @Result =  CONVERT(nvarchar(50), SESSION_CONTEXT(N'Language')); 
	
	RETURN @Result;
END