
CREATE PROCEDURE [dbo].[rpt_ERCA__EmployeeIncomeTax]
	@fromDate Datetime = '01.01.2000', 
	@toDate Datetime = '01.01.2100'
AS
SET NOCOUNT ON

SELECT
	A.TaxIdentificationNumber As [Employee TIN],
	A.LongName As [Employee Full Name],
	S.RelatedAmount As [Taxable Income], 
	S.Amount As [Income Tax],
	S.StartDateTime AS [Month Start],
	S.EndDateTime AS [Month End]
FROM dbo.ft_Account__Statement(N'CurrentEmployeeIncomeTaxPayable' , @fromDate, @toDate) S
JOIN dbo.Agents A ON S.CustodyId = A.Id
WHERE S.Direction = -1
