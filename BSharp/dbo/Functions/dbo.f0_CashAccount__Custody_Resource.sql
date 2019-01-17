CREATE FUNCTION [dbo].[f0_CashAccount__Custody_Resource] ( -- 0 means to be optimized into inline function
	@CustodyId int,
	@ResourceId int
)
RETURNS NVARCHAR(255)
AS
BEGIN
	DECLARE @Result NVARCHAR(255), @CustodyType NVARCHAR(255), @ResourceType NVARCHAR(255), @Source NVARCHAR(255), @Purpose NVARCHAR(255);
	SELECT @CustodyType = CustodyType FROM dbo.Custodies WHERE Id = @CustodyId;
	SELECT @ResourceType = ResourceType FROM Resources WHERE Id = @ResourceId;

	SELECT @Result = CASE 
		WHEN @CustodyType = N'BankAccount' AND @ResourceType = N'Money' THEN  N'BalancesWithBanks'
		WHEN @CustodyType IN (N'CashSafe', N'Individual', N'Organization', N'Position') AND @ResourceType = N'Money' THEN  N'CashOnHand'
		ELSE  N'OtherCashAndCashEquivalents'
		--WHEN @CustodyType IN (N'Warehouse') AND @Source = N'Production' AND @Purpose = N'Sale' THEN N'FinishedGoods'
		--WHEN @CustodyType IN (N'Warehouse') AND @Source = N'Production' AND @Purpose = N'Production' THEN N'WorkInProgress'
	END

	RETURN @Result;
END
-- Source (N'LeaseIn', N'Acquisition', N'Production')
--Purpose (N'LeaseOut', N'Sale', N'Production', N'Selling', N'GeneralAndAdministrative')