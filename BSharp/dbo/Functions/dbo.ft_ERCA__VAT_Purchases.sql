CREATE FUNCTION [dbo].[ft_ERCA__VAT_Purchases] (
	@fromDate Datetime = '01.01.2015', 
	@toDate Datetime = '01.01.2020'
)
RETURNS TABLE
AS 
RETURN
	SELECT
		C.[Name] As [Supplier], 
		A.TaxIdentificationNumber As TIN, 
		S.Reference As [Invoice #], S.RelatedReference As [Cash M/C #],
		SUM(S.Amount) AS VAT,
		SUM(S.RelatedAmount) AS [Taxable Amount],
		S.StartDateTime As [Invoice Date]
	FROM [dbo].ft_Account__Statement(N'CurrentValueAddedTaxReceivables' , 0, 0, @fromDate, @toDate) S
	JOIN [dbo].[Custodies] C ON S.RelatedAgentId = C.Id
	JOIN [dbo].Agents A ON C.Id = A.Id
	WHERE S.Direction = 1
	GROUP BY C.[Name], A.TaxIdentificationNumber, S.Reference, S.RelatedReference, S.StartDateTime;