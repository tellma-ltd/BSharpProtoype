CREATE FUNCTION [dbo].[fi_ERCA__EmployeeIncomeTax] (
	@fromDate Datetime = '01.01.2000', 
	@toDate Datetime = '01.01.2100'
)
RETURNS TABLE 
AS
RETURN
	SELECT
		C.TaxIdentificationNumber As [Employee TIN],
		C.[Name] As [Employee Full Name],
		S.RelatedAmount As [Taxable Income], 
		S.[Value] As [Tax Withheld]
	FROM [dbo].[fi_Account__Statement](N'CurrentEmployeeIncomeTaxPayable' , default, default, @fromDate, @toDate) S
	JOIN [dbo].[Agents] C ON S.[RelatedAgentId] = C.Id
	WHERE C.[RelationType] = N'Agent'
	AND S.Direction = -1;