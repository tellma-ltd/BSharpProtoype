CREATE PROCEDURE [dbo].[rpt_Paysheet]
	@fromDate Datetime = '01.01.2000', 
	@toDate Datetime = '01.01.2100',
	@BasicSalaryResourceId int, -- (SELECT MIN([Id]) FROM dbo.Resources WHERE [SystemCode] = N'Basic')
	-- We should get all resources that are potentially salary components
	@TransportationAllowanceResourceId int, -- (SELECT MIN([Id]) FROM dbo.Resources WHERE [Name] = N'Transportation')
	@OvertimeResourceId int -- 
AS 
BEGIN
	SELECT
		A.TaxIdentificationNumber As [Employee TIN],
		A.[Name] As [Employee Full Name],
		SUM(CASE 
			WHEN (J.[IFRSAccountId] = N'ShorttermEmployeeBenefitsAccruals' 
			AND J.ResourceId = @BasicSalaryResourceId)
			THEN J.Direction * J.[Value] Else 0 
			END) AS [Basic Salary],
		SUM(CASE
			WHEN (J.[IFRSAccountId] = N'ShorttermEmployeeBenefitsAccruals' 
			AND J.ResourceId = @TransportationAllowanceResourceId)
			THEN J.Direction * J.[Value] Else 0 
			END) AS [Transportation],
		SUM(CASE
			WHEN (J.[IFRSAccountId] = N'ShorttermEmployeeBenefitsAccruals' 
			AND J.ResourceId = @OvertimeResourceId)
			THEN J.Direction * J.[Value] Else 0 
			END) AS [Overtime],
		SUM(CASE 
			WHEN (J.[IFRSAccountId] = N'CurrentEmployeeIncomeTaxPayable')
			THEN J.Direction * J.[Value] Else 0 
			END) AS [Income Tax],
		SUM(CASE 
			WHEN (J.[IFRSAccountId] IN (N'ShorttermPensionContributionAccruals', 'CurrentSocialSecurityTaxPayable'))
			THEN J.Direction * J.[Value] Else 0 
			END) AS [Pension Contribution 7%],
		SUM(CASE 
			WHEN (J.[IFRSAccountId] = N'CurrentReceivablesFromEmployees')
			THEN J.Direction * J.[Value] Else 0 
			END) AS [Loans],
		SUM(CASE 
			WHEN (J.[IFRSAccountId] = N'CurrentPayablesToEmployees')
			THEN -J.Direction * J.[Value] Else 0 
			END) AS [Net Pay],
		SUM(CASE 
			WHEN (J.[IFRSAccountId] = N'ShorttermPensionContributionAccruals')
			THEN J.Direction * J.[Value] Else 0 
			END) AS [Pension Contribution 11%]
	FROM [dbo].[fi_Journal](@fromDate, @toDate) J
	LEFT JOIN [dbo].[AgentAccounts] AA ON J.[RelatedAgentAccountId] = AA.Id
	LEFT JOIN [dbo].[Agents] A ON AA.AgentId = A.Id
	WHERE AA.AgentRelationType = N'employee'
	GROUP BY A.TaxIdentificationNumber, A.[Name];
END