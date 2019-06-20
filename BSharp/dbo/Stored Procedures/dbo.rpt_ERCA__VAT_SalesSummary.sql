CREATE PROCEDURE [dbo].[rpt_ERCA__VAT_SalesSummary] -- used for manual declaration
	@fromDate Datetime = '01.01.2000', 
	@toDate Datetime = '01.01.2100'
AS
BEGIN
	SELECT 
		A.[Name] As [Customer], 
		A.TaxIdentificationNumber As TIN, 
		J.ExternalReference As [Invoice #], J.[AdditionalReference] As [Cash M/C #],
		SUM(J.MoneyAmount) AS VAT, SUM(J.RelatedMoneyAmount) AS [Taxable Amount],
		J.DocumentDate As [Invoice Date], J.[TransactionLineId]
	FROM dbo.[fi_JournalDetails](@fromDate, @toDate) J
	LEFT JOIN dbo.Agents A ON J.RelatedAgentId = A.Id
	WHERE IfrsAccountId = N'CurrentValueAddedTaxPayables'
	GROUP BY
		A.[Name],
		A.TaxIdentificationNumber,
		J.ExternalReference, J.[AdditionalReference],
		J.DocumentDate,	J.[TransactionLineId]
END;
GO;