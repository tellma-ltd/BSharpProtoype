
CREATE PROCEDURE [dbo].[rpt_ERCA__EmployeeIncomeTax]
	@fromDate Datetime = '01.01.2000', 
	@toDate Datetime = '01.01.2100'
AS
SET NOCOUNT ON

SELECT
	A.TaxIdentificationNumber As [Employee TIN],
	C.[Name] As [Employee Full Name],
	S.RelatedAmount As [Taxable Income], 
	S.Amount As [Income Tax],
	S.StartDateTime AS [Month Start],
	S.EndDateTime AS [Month End]
FROM dbo.ft_Account__Statement(N'CurrentEmployeeIncomeTaxPayable' , @fromDate, @toDate) S
JOIN dbo.Custodies C ON S.CustodyId = C.Id
JOIN dbo.Agents A ON C.Id = A.Id
WHERE S.Direction = -1
