CREATE FUNCTION [dbo].[fn_Account__Code] (
	@AccountId NVARCHAR(255)
)
RETURNS NVARCHAR(255)
AS
BEGIN
	RETURN (SELECT Code FROM dbo.Accounts WHERE Id = @AccountId);
END;