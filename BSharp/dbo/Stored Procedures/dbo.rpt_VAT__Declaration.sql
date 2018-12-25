CREATE PROCEDURE [dbo].[rpt_VAT__Declaration]
	@fromDate Datetime = '01.01.2000', 
	@toDate Datetime = '01.01.2100'
AS
SET NOCOUNT ON;
	SELECT
		--(CASE WHEN S.Direction = 1 THEN N'Purchase' Else N'Sale' END) AS Activity,
		C.[Name] As [Agent], 
		A.TaxIdentificationNumber As TIN, 
		S.Reference As InvoiceNumber, S.RelatedReference As [CashMC],
		SUM(S.Amount) AS VAT,
		SUM(S.RelatedAmount) AS TaxableAmount,
		S.StartDateTime As InvoiceDate
	FROM [dbo].ft_Account__Statement(N'CurrentValueAddedTaxReceivables' , 0, 0, @fromDate, @toDate) S
	JOIN [dbo].[Custodies] C ON S.RelatedAgentId = C.Id
	JOIN [dbo].Agents A ON C.Id = A.Id
	WHERE S.Direction = 1
	GROUP BY C.[Name], A.TaxIdentificationNumber, S.Reference, S.RelatedReference, S.StartDateTime
	ORDER BY S.StartDateTime;

	SELECT
		C.[Name] As [Customer],
		A.TaxIdentificationNumber As [TIN],
		S.Reference As [Invoice #], S.RelatedReference As [Cash M/C #],
		SUM(S.Amount) AS VAT,
		SUM(S.RelatedAmount) AS TaxableAmount,
		S.StartDateTime As [Invoice Date]
	FROM [dbo].ft_Account__Statement(N'CurrentValueAddedTaxPayables', 0, 0, @fromDate, @toDate) S
	JOIN [dbo].[Custodies] C ON S.RelatedAgentId = C.Id
	JOIN [dbo].Agents A ON C.Id = A.Id
	WHERE S.Direction = -1
	GROUP BY C.[Name], A.TaxIdentificationNumber, S.Reference, S.RelatedReference, S.StartDateTime
	ORDER BY S.StartDateTime;