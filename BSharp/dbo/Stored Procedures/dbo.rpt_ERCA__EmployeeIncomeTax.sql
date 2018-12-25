CREATE PROCEDURE [dbo].[rpt_ERCA__EmployeeIncomeTax]
	@fromDate Datetime = '01.01.2000', 
	@toDate Datetime = '01.01.2100'
AS
SET NOCOUNT ON;
SELECT
	A.TaxIdentificationNumber As [Employee TIN],
	C.[Name] As [Employee Full Name],
	S.RelatedAmount As [Taxable Income], 
	S.Amount As [Tax Withheld],
	S.Reference AS [Salary Period]
FROM [dbo].ft_Account__Statement(N'CurrentEmployeeIncomeTaxPayable' , 0, 0, @fromDate, @toDate) S
JOIN [dbo].[Custodies] C ON S.RelatedAgentId = C.Id
JOIN [dbo].Agents A ON C.Id = A.Id
WHERE S.Direction = -1