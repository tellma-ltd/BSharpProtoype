CREATE FUNCTION [dbo].[fi_BankBalances] (
	@AsOfDate Datetime = '01.01.2020'
)
RETURNS TABLE
AS
RETURN
(
	SELECT
		Ac.Code As AccountCode,
		Ac.[Name] As AccountName, Ac.[Name2] As AccountName2,
		Ag.[Name] As BankName, Ag.[Name2] As BankName2,
		AA.[Reference] As AccountNumber,
		SUM(J.[MoneyAmount] * J.[Direction]) AS [Balance],
		R.[Name] As Currency, R.Name2 As Currency2
	FROM [dbo].[fi_Journal](NULL, @AsOfDate) J
	JOIN dbo.Accounts Ac ON J.AccountId = Ac.Id
	LEFT JOIN dbo.Resources R ON J.ResourceId = R.Id
	LEFT JOIN dbo.AgentAccounts AA ON J.AgentAccountId = AA.Id
	LEFT JOIN dbo.Agents Ag ON AA.AgentId = Ag.Id
	WHERE Ac.[IFRSAccountId] = N'BalancesWithBanks'
	GROUP BY Ac.Code, Ac.[Name], Ac.[Name2], Ag.[Name], Ag.[Name2], AA.[Reference], R.[Name], R.Name2
);