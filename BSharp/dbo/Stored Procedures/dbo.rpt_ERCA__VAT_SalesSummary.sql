CREATE PROCEDURE [dbo].[rpt_ERCA__VAT_SalesSummary] -- used for manual declaration
	@fromDate Datetime = '01.01.2000', 
	@toDate Datetime = '01.01.2100'
AS
SELECT 	A.[Name] As [Customer], 
		A.TaxIdentificationNumber As TIN, 
		J.Reference As [Invoice #], J.RelatedReference As [Cash M/C #],
		SUM(J.MoneyAmount) AS VAT,
		SUM(J.RelatedMoneyAmount) AS [Taxable Amount],
		J.DocumentDate As [Invoice Date],
		J.TransactionType, J.SerialNumber
FROM dbo.fi_Journal(@fromDate, @toDate) J
LEFT JOIN dbo.Resources R ON J.RelatedResourceId = R.Id 
LEFT JOIN dbo.AgentAccounts AA ON J.RelatedAgentAccountId = AA.Id
LEFT JOIN dbo.Agents A ON AA.AgentId = A.Id
WHERE IFRSAccountId = N'CurrentValueAddedTaxPayables'
GROUP BY A.[Name], A.TaxIdentificationNumber, J.Reference, J.RelatedReference,
		J.DocumentDate,	J.TransactionType, J.SerialNumber
