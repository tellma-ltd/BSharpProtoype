CREATE FUNCTION [dbo].[fi_Paysheet] (
	@fromDate Datetime = '01.01.2000', 
	@toDate Datetime = '01.01.2100',
	@Reference nvarchar(255) = NULL,
	@BasicSalaryResourceId int, -- (SELECT MIN([Id]) FROM dbo.Resources WHERE [Name] = N'Basic')
	@TransportationAllowanceResourceId int -- (SELECT MIN([Id]) FROM dbo.Resources WHERE [Name] = N'Transportation')
)
RETURNS TABLE
AS 
RETURN
	SELECT
		C.TaxIdentificationNumber As [Employee TIN],
		C.[Name] As [Employee Full Name],
		SUM(CASE 
			WHEN (S.AccountId = N'ShorttermEmployeeBenefitsAccruals' 
			AND S.ResourceId = @BasicSalaryResourceId)
			THEN S.Direction * S.[Value] Else 0 
			END) AS [Basic Salary],
		SUM(CASE
			WHEN (S.AccountId = N'ShorttermEmployeeBenefitsAccruals' 
			AND S.ResourceId = @TransportationAllowanceResourceId)
			THEN S.Direction * S.[Value] Else 0 
			END) AS [Overtime],
		SUM(CASE 
			WHEN (S.AccountId = N'CurrentEmployeeIncomeTaxPayable')
			THEN S.Direction * S.[Value] Else 0 
			END) AS [Income Tax],
		SUM(CASE 
			WHEN (S.AccountId IN (N'ShorttermPensionContributionAccruals', 'CurrentSocialSecurityTaxPayable'))
			THEN S.Direction * S.[Value] Else 0 
			END) AS [Pension Contribution 7%],
		SUM(CASE 
			WHEN (S.AccountId = N'OtherCurrentReceivables')
			THEN S.Direction * S.[Value] Else 0 
			END) AS [Loans],
		SUM(CASE 
			WHEN (S.AccountId = N'CurrentPayablesToEmployees')
			THEN -S.Direction * S.[Value] Else 0 
			END) AS [Net Pay],
		SUM(CASE 
			WHEN (S.AccountId = N'ShorttermPensionContributionAccruals')
			THEN S.Direction * S.[Value] Else 0 
			END) AS [Pension Contribution 11%]
	FROM [dbo].[fi_Journal](@fromDate, @toDate) S
	JOIN [dbo].[Custodies] C ON S.RelatedAgentId = C.Id
	WHERE (@Reference IS NULL OR S.Reference = @Reference)
	AND C.CustodyType = N'Agent'
	GROUP BY C.TaxIdentificationNumber, C.[Name];