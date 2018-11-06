
CREATE PROCEDURE [dbo].[rpt_WithholdingTaxOnPayment]
	@fromDate Datetime = '01.01.2000', 
	@toDate Datetime = '01.01.2100'
AS
SET NOCOUNT ON
SELECT
	A.TaxIdentificationNumber As [Withholdee TIN],
	A.LongName As [Organization/Person Name],
	A.RegisteredAddress As [Withholdee Address], 
	S.Memo As [Withholding Type],
	S.RelatedAmount As [Taxable Amount], 
	S.Amount As [Tax Withheld], 
	S.Reference As [Receipt Number], 
	S.StartDateTime As [Receipt Date]
FROM dbo.ft_Account__Statement(N'CurrentWithholdingTaxPayable', @fromDate, @toDate) S
LEFT JOIN dbo.Agents A ON S.RelatedAgentId = A.Id
WHERE S.Direction = -1
