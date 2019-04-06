CREATE FUNCTION [dbo].[fi_ERCA__EmployeeIncomeTax] (
	@fromDate Datetime = '01.01.2000', 
	@toDate Datetime = '01.01.2100'
)
RETURNS TABLE 
AS
RETURN
	SELECT
		--J.OperationId, -- for example, if different operations declare in different laces
		A.TaxIdentificationNumber As [Employee TIN],
		A.[Name] As [Employee Full Name],
		J.[RelatedMoneyAmount] As [Taxable Income], 
		J.[Value] As [Tax Withheld]
	FROM [dbo].[fi_Journal](@fromDate, @toDate) J
	LEFT JOIN [dbo].[AgentAccounts] AA  ON J.[RelatedAgentAccountId] = AA.Id
	LEFT JOIN [dbo].[Agents] A ON AA.AgentId = A.Id
	WHERE J.[IFRSAccountId] = N'CurrentEmployeeIncomeTaxPayable'
	-- No IFRS?: J.AccountType = N'CurrentEmployeeIncomeTaxPayable'
	AND J.Direction = -1;