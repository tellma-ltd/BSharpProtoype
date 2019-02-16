CREATE FUNCTION [dbo].[fi_ERCA__VAT_Sales] (
	@fromDate Datetime = '01.01.2000', 
	@toDate Datetime = '01.01.2100'
)
RETURNS TABLE
AS
RETURN
	SELECT
		C.[Name] As [Customer],
		C.TaxIdentificationNumber As [TIN],
		S.Reference As [Invoice #], S.RelatedReference As [Cash M/C #],
		SUM(S.[Value]) AS VAT,
		SUM(S.RelatedAmount) AS TaxableAmount,
		S.StartDateTime As [Invoice Date]
	FROM [dbo].[fi_Account__Statement](N'CurrentValueAddedTaxPayables', 0, 0, @fromDate, @toDate) S
	JOIN [dbo].[Agents] C ON S.[RelatedAgentId] = C.Id
	WHERE C.[RelationType] = N'customer'
	AND S.Direction = -1
	GROUP BY C.[Name], C.TaxIdentificationNumber, S.Reference, S.RelatedReference, S.StartDateTime;