CREATE FUNCTION [dbo].[fi_WithholdingTaxOnPayment] (
	@fromDate Datetime = '01.01.2000', 
	@toDate Datetime = '01.01.2100'
)
RETURNS TABLE 
AS 
RETURN
	SELECT
		A.TaxIdentificationNumber As [Withholdee TIN],
		A.[Name] As [Organization/Person Name],
		A.[RegisteredAddress] As [Withholdee Address], 
		J.[Memo] As [Withholding Type],
		J.[RelatedMoneyAmount] As [Taxable Amount], 
		J.[MoneyAmount] As [Tax Withheld], 
		J.[Reference] As [Receipt Number], 
		J.DocumentDateTime As [Receipt Date]
	FROM [dbo].[fi_Journal](@fromDate, @toDate) J
	LEFT JOIN [dbo].[AgentAccounts] AA ON J.[RelatedAgentAccountId] = AA.Id
	LEFT JOIN [dbo].[Agents] A ON AA.AgentId = A.Id
	WHERE J.[IFRSAccountConcept] = N'CurrentWithholdingTaxPayable'
	-- No IFRS?: J.AccountType = N'CurrentWithholdingTaxPayable'
	AND J.Direction = -1;