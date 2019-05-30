CREATE PROCEDURE [dbo].[rpt_ERCA__VAT_PurchasesSummary]
	@fromDate Datetime = '01.01.2015', 
	@toDate Datetime = '01.01.2020'
AS 
BEGIN
	SELECT
		A.[Name] As [Supplier], 
		A.TaxIdentificationNumber As TIN, 
		J.Reference As [Invoice #], J.RelatedReference As [Cash M/C #],
		SUM(J.[MoneyAmount]) AS VAT,
		SUM(J.[RelatedMoneyAmount]) AS [Taxable Amount],
		J.DocumentDate As [Invoice Date]
	FROM [dbo].[fi_Journal](@fromDate, @toDate) J
	LEFT JOIN [dbo].[AgentAccounts] AA ON J.[RelatedAgentAccountId] = AA.Id
	LEFT JOIN [dbo].[Agents] A ON AA.AgentId = A.Id
	WHERE J.[IfrsAccountId] = N'CurrentValueAddedTaxReceivables'
	-- No Ifrs?: J.AccountType = N'CurrentValueAddedTaxReceivables'
	AND J.Direction = 1
	GROUP BY A.[Name], A.TaxIdentificationNumber, J.Reference, J.RelatedReference, J.DocumentDate;
END;