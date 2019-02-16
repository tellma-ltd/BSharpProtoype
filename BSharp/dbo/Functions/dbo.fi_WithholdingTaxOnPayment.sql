CREATE FUNCTION [dbo].[fi_WithholdingTaxOnPayment] (
	@fromDate Datetime = '01.01.2000', 
	@toDate Datetime = '01.01.2100'
)
RETURNS TABLE 
AS 
RETURN
	SELECT
		C.TaxIdentificationNumber As [Withholdee TIN],
		C.Name As [Organization/Person Name],
		C.[RegisteredAddress] As [Withholdee Address], 
		S.Memo As [Withholding Type],
		S.RelatedAmount As [Taxable Amount], 
		S.Amount As [Tax Withheld], 
		S.Reference As [Receipt Number], 
		S.StartDateTime As [Receipt Date]
	FROM [dbo].[fi_Account__Statement](N'CurrentWithholdingTaxPayable', 0, 0, @fromDate, @toDate) S
	JOIN [dbo].[Agents] C ON S.[RelatedAgentId] = C.Id
	WHERE C.[RelationType] = N'Agent'
	AND S.Direction = -1;