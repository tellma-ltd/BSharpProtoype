CREATE FUNCTION [dbo].[fn_TenantId]()
RETURNS int
AS
BEGIN
	DECLARE @Result int;

	SELECT @Result =  CONVERT(int, SESSION_CONTEXT(N'Tenantid')); 
	
	RETURN @Result;
END