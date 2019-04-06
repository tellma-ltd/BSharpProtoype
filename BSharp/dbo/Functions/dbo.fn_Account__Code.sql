CREATE FUNCTION [dbo].[fn_Account__Code] (
	@AccountId NVARCHAR(255)
)
RETURNS NVARCHAR(255)
AS
BEGIN
	RETURN (SELECT [Id] FROM dbo.[IFRSAccounts] WHERE [Node] = @AccountId);
END;