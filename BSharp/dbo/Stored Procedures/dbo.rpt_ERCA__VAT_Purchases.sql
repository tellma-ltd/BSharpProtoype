
CREATE PROCEDURE [dbo].[rpt_ERCA__VAT_Purchases] -- EXEC [dbo].[sbs_ERCA__VAT] @fromDate = '01.01.2015', @toDate = '01.01.2020'
	@fromDate Datetime = '01.01.2015', 
	@toDate Datetime = '01.01.2020'
AS
BEGIN
	SET NOCOUNT ON;
	SELECT
		C.[Name] As [Supplier], 
		A.TaxIdentificationNumber As TIN, 
		S.Reference As [Invoice #], S.RelatedReference As [Cash M/C #],
		SUM(S.Amount) AS VAT,
		SUM(S.RelatedAmount) AS TaxableAmount,
		S.StartDateTime As InvoiceDate
	FROM dbo.ft_Account__Statement(N'CurrentValueAddedTaxReceivables' , @fromDate, @toDate) S
	JOIN dbo.Custodies C ON S.RelatedAgentId = C.Id
	JOIN dbo.Agents A ON C.Id = A.Id
	WHERE S.Direction = 1
	GROUP BY C.[Name], A.TaxIdentificationNumber, S.Reference, S.RelatedReference, S.StartDateTime
END
