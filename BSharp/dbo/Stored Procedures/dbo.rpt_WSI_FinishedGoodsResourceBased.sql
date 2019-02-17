CREATE PROCEDURE [dbo].[rpt_WSI_FinishedGoodsResourceBased]
/*
Assumptions:
1) Any inventory account is mapped to IFRS concepts: Inventories, NonCurrentinventories, or their descendants
2) All entries use a raw material resource. For balance migration, we need to add for every inventory account
	a resource called non-specified (for that account), and migrate balances to it.

*/
	@fromDate Datetime = '01.01.2020',
	@toDate Datetime = '01.01.2020'
AS
	WITH
	IFRS_FG AS (
		SELECT IFRSConceptNode 
		FROM dbo.IFRSConcepts WHERE IFRSConceptId IN(N'FinishedGoods')
	),
	FinishedGoodsAccounts AS (
		SELECT [Id] FROM dbo.Accounts A
		JOIN dbo.IFRSConcepts I ON A.IFRSConceptId = I.IFRSConceptId
		WHERE I.IFRSConceptNode.IsDescendantOf((SELECT * FROM IFRS_FG))	= 1
	), /*
	-- To avoid IFRS, we need to define an account type:
	FixedAssetAccounts AS (
		SELECT [Id] FROM dbo.Accounts
		WHERE AccountType = N'FinishedGoods'
	), */
	OpeningBalances AS (
		SELECT
			J.ResourceId,
			SUM(J.[Count] * J.[Direction]) AS [Count]
		FROM [dbo].[fi_Journal](NULL, @fromDate) J
		WHERE J.AccountId IN (SELECT Id FROM FinishedGoodsAccounts)
		GROUP BY J.ResourceId
	),
	Movements AS (
		SELECT
			J.ResourceId,
			SUM(CASE WHEN J.[Direction] > 0 THEN J.[Count] * MU.[BaseAmount] / MU.[UnitAmount] ELSE 0 END) AS CountIn,
			SUM(CASE WHEN J.[Direction] < 0 THEN J.[Count] * MU.[BaseAmount] / MU.[UnitAmount] ELSE 0 END) AS CountOut		
		FROM [dbo].[fi_Journal](@fromDate, @toDate) J
		JOIN [dbo].[Resources] R ON J.ResourceId = R.Id
		JOIN [dbo].MeasurementUnits MU ON R.[MassUnitId] = MU.Id
		WHERE J.AccountId IN (SELECT Id FROM FinishedGoodsAccounts)
		GROUP BY J.ResourceId
	),
	FinishedGoodsRegsiter AS (
		SELECT COALESCE(OpeningBalances.ResourceId, Movements.ResourceId) AS ResourceId,
			ISNULL(OpeningBalances.[Count],0) AS OpeningCount, 
			ISNULL(Movements.[CountIn],0) AS CountIn, ISNULL(Movements.[CountOut],0) AS CountOut,
			ISNULL(OpeningBalances.[Count], 0) + ISNULL(Movements.[CountIn], 0) + ISNULL(Movements.[CountOut],0) AS EndingCount
		FROM OpeningBalances
		FULL OUTER JOIN Movements ON OpeningBalances.ResourceId = Movements.ResourceId
	)

	SELECT FGR.ResourceId, R.[Name], R.[Name2], MU.[Name] As Unit, MU.Name2 As Unit2,
		FGR.OpeningCount,
		FGR.CountIn, FGR.CountOut, FGR.EndingCount
	FROM dbo.Resources R 
	JOIN FinishedGoodsRegsiter FGR ON R.Id = FGR.ResourceId
	JOIN [dbo].[MeasurementUnits] MU ON R.[MassUnitId] = MU.Id;