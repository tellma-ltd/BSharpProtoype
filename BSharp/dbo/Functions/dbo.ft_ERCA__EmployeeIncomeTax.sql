CREATE FUNCTION [dbo].[ft_ERCA__EmployeeIncomeTax] (
	@fromDate Datetime = '01.01.2000', 
	@toDate Datetime = '01.01.2100'
)
RETURNS TABLE 
AS
RETURN
	SELECT
		A.TaxIdentificationNumber As [Employee TIN],
		C.[Name] As [Employee Full Name],
		S.RelatedAmount As [Taxable Income], 
		S.Amount As [Tax Withheld],
		S.Reference AS [Salary Period]
	FROM [dbo].ft_Account__Statement(N'CurrentEmployeeIncomeTaxPayable' , default, default, @fromDate, @toDate) S
	JOIN [dbo].[Custodies] C ON S.RelatedAgentId = C.Id
	JOIN [dbo].Agents A ON C.Id = A.Id
	WHERE S.Direction = -1;