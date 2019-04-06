CREATE PROCEDURE [dbo].[rpt_WSI_MerchandiseInTransit]
/*
Assumptions:
1) Any inventory account is mapped to IFRS concepts: Inventories, NonCurrentinventories, or their descendants
2) All entries use a raw material resource. For balance migration, we need to add for every inventory account
	a resource called non-specified (for that account), and migrate balances to it.

*/
	@AsOfDate Datetime = '01.01.2020'
AS
	WITH
	IFRS_MIT AS (
		SELECT [Node] 
		FROM dbo.[IFRSAccounts] WHERE [Id] IN(N'CurrentInventoriesInTransit')
	),
	InventoriesInTransitAccounts AS (
		SELECT [Id] FROM dbo.Accounts A
		JOIN dbo.[IFRSAccounts] I ON A.[IFRSAccountId] = I.[Id]
		WHERE I.[Node].IsDescendantOf((SELECT * FROM IFRS_MIT))	= 1
	), /*
	-- To avoid IFRS, we need to define an account type:
	FixedAssetAccounts AS (
		SELECT [Id] FROM dbo.Accounts
		WHERE AccountType = N'CurrentInventoriesInTransit'
	), */
	Balances AS (
		SELECT
			J.ResourceId,
			SUM(J.[Direction] * J.[MoneyAmount]) AS [MoneyAmount],
			SUM(J.[Direction] * J.[Mass]) AS [Mass],
			SUM(J.[Direction] * J.[Count]) AS [Count]

		FROM [dbo].[fi_Journal](NULL, @AsOfDate) J
		WHERE J.AccountId IN (SELECT Id FROM InventoriesInTransitAccounts)
		GROUP BY J.ResourceId
	)
	SELECT B.ResourceId, R.[Name], R.[Name2], MU.[Name] As Unit, MU.Name2 As Unit2,
		B.[Count], B.[Mass], B.[MoneyAmount]
	FROM dbo.Resources R 
	JOIN Balances B ON R.Id = B.ResourceId
	JOIN [dbo].[MeasurementUnits] MU ON R.[MassUnitId] = MU.Id;