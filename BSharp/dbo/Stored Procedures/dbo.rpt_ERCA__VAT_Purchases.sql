
CREATE PROCEDURE [dbo].[rpt_ERCA__VAT_Purchases] -- EXEC [dbo].[sbs_ERCA__VAT] @fromDate = '01.01.2015', @toDate = '01.01.2020'
	@fromDate Datetime = '01.01.2015', 
	@toDate Datetime = '01.01.2020'
AS
BEGIN
	SET NOCOUNT ON;
	SELECT
		A.LongName As [Supplier], 
		A.TaxIdentificationNumber As TIN, 
		S.Reference As [Invoice #], S.RelatedReference As [Cash M/C #],
		SUM(S.Amount) AS VAT,
		SUM(S.RelatedAmount) AS TaxableAmount,
		S.StartDateTime As InvoiceDate
	FROM dbo.ft_Account__Statement(N'CurrentValueAddedTaxReceivables' , @fromDate, @toDate) S
	JOIN dbo.Agents A ON S.RelatedAgentId = A.Id
	WHERE S.Direction = 1
	GROUP BY A.LongName, A.TaxIdentificationNumber, S.Reference, S.RelatedReference, S.StartDateTime
END
