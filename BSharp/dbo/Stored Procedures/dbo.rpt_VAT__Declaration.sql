
CREATE PROCEDURE [dbo].[rpt_VAT__Declaration]
	@fromDate Datetime = '01.01.2000', 
	@toDate Datetime = '01.01.2100'
AS
SET NOCOUNT ON
SELECT
	A.LongName As [Supplier],
	A.TaxIdentificationNumber As [TIN],
	S.RelatedReference As [m/c No], 
	S.RelatedAmount As [VAT excl.], 
	S.Amount As VAT, 
	S.Reference As [FS No.], 
	S.StartDateTime As [Invoice Date]
FROM dbo.ft_Account__Statement(N'CurrentValueAddedTaxReceivables', @fromDate, @toDate) S
LEFT JOIN dbo.Agents A ON S.RelatedAgentId = A.Id
WHERE S.Direction = 1

SELECT
	A.LongName As [Customer],
	A.TaxIdentificationNumber As [TIN],
	S.RelatedReference As [m/c No], 
	S.RelatedAmount As [VAT excl.], 
	S.Amount As VAT, 
	S.Reference As [FS No.], 
	S.StartDateTime As [Invoice Date]
FROM dbo.ft_Account__Statement(N'CurrentValueAddedTaxPayables', @fromDate, @toDate) S
LEFT JOIN dbo.Agents A ON S.RelatedAgentId = A.Id
WHERE S.Direction = -1
