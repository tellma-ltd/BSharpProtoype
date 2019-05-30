CREATE PROCEDURE [dbo].[rpt_BankAccountBalances]
	@AsOfDate Datetime = '01.01.2020'
AS
BEGIN
	SELECT
		Ac.Code As AccountCode,
		Ac.[Name] As AccountName, Ac.[Name2] As AccountName2, Ac.[Name3] As AccountName3,
		Ag.[Name] As BankName, Ag.[Name2] As BankName2, Ag.[Name3] As BankName3,
		AA.[Reference] As AccountNumber,
		SUM(J.[MoneyAmount] * J.[Direction]) AS [Balance],
		R.[Name] As Currency, R.Name2 As Currency2, R.Name3 As Currency3
	FROM [dbo].[fi_Journal](NULL, @AsOfDate) J
	JOIN dbo.Accounts Ac ON J.AccountId = Ac.Id
	JOIN dbo.Resources R ON J.ResourceId = R.Id
	JOIN dbo.AgentAccounts AA ON J.AgentAccountId = AA.Id
	JOIN dbo.Agents Ag ON AA.AgentId = Ag.Id
	WHERE Ac.[IfrsAccountId] = N'BalancesWithBanks'
	GROUP BY Ac.Code, 
		Ac.[Name], Ac.[Name2], Ac.[Name3],
		Ag.[Name], Ag.[Name2], Ag.[Name3],
		AA.[Reference], R.[Name], R.[Name2], R.[Name3]
END;