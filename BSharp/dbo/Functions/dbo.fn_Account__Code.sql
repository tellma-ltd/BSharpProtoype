CREATE FUNCTION [dbo].[fn_Account__Code] (
	@AccountId NVARCHAR(255)
)
RETURNS NVARCHAR(255)
AS
BEGIN
	RETURN (SELECT [IFRSConcept] FROM dbo.[IFRSAccounts] WHERE [IFRSAccountNode] = @AccountId);
END;