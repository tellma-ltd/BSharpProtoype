﻿CREATE FUNCTION [dbo].[fi_ERCA__VAT_Purchases] (
	@fromDate Datetime = '01.01.2015', 
	@toDate Datetime = '01.01.2020'
)
RETURNS TABLE
AS 
RETURN
	SELECT
		A.[Name] As [Supplier], 
		A.TaxIdentificationNumber As TIN, 
		J.Reference As [Invoice #], J.RelatedReference As [Cash M/C #],
		SUM(J.[MoneyAmount]) AS VAT,
		SUM(J.[RelatedAmount]) AS [Taxable Amount],
		J.DocumentDateTime As [Invoice Date]
	FROM [dbo].[fi_Journal](@fromDate, @toDate) J
	LEFT JOIN [dbo].[Agents] A ON J.[RelatedAgentId] = A.Id
	WHERE J.IFRSConceptID = N'CurrentValueAddedTaxReceivables'
	-- No IFRS?: J.AccountType = N'CurrentValueAddedTaxReceivables'
	AND J.Direction = 1
	GROUP BY A.[Name], A.TaxIdentificationNumber, J.Reference, J.RelatedReference, J.DocumentDateTime;