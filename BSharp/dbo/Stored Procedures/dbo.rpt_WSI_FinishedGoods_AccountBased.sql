﻿CREATE PROCEDURE [dbo].[rpt_WSI_FinishedGoods_AccountBased]
/*
Assumptions:
1) Any inventory account is mapped to IFRS concepts: Inventories, NonCurrentinventories, or their descendants
2) All entries use a finished goods resource. For balance migration, we need to add for every inventory account
	a resource called non-specified (for that account), and migrate balances to it.

3) It might be better to convert the unit in the front end instead of sending it back to the server to repeat all the
	instructions again.

*/
	@fromDate Datetime = '01.01.2020',
	@toDate Datetime = '01.01.2020',
	@CountUnit INT = 4 -- (SELECT [Id] FROM dbo.MeasurementUnits WHERE [Name] = N'ea');
AS
	WITH
	IFRS_FG AS (
		SELECT [IFRSAccountNode] 
		FROM dbo.[IFRSAccounts] WHERE [IFRSConcept] IN(N'FinishedGoods')
	),
	FinishedGoodsAccounts AS (
		SELECT [Id] FROM dbo.Accounts A
		JOIN dbo.[IFRSAccounts] I ON A.[IFRSAccountConcept] = I.[IFRSConcept]
		WHERE I.[IFRSAccountNode].IsDescendantOf((SELECT * FROM IFRS_FG))	= 1
	), /*
	-- To avoid IFRS, we need to define an account type:
	FixedAssetAccounts AS (
		SELECT [Id] FROM dbo.Accounts
		WHERE AccountType = N'FinishedGoods'
	), */

	OpeningBalances AS (
		SELECT
			J.AccountId,
			SUM(J.[Count] * J.[Direction] * MU.[BaseAmount] / MU.[UnitAmount]) AS [Count]
		FROM [dbo].[fi_Journal](NULL, @fromDate) J
		JOIN [dbo].[Resources] R ON J.ResourceId = R.Id
		JOIN [dbo].MeasurementUnits MU ON R.[MassUnitId] = MU.Id
		WHERE J.AccountId IN (SELECT Id FROM FinishedGoodsAccounts)
		GROUP BY J.AccountId
	),
	OB2 AS (
		SELECT AccountId, 
			[Count] * (SELECT [UnitAmount]/[BaseAmount] FROM MeasurementUnits WHERE Id = @CountUnit) AS [Count]
		FROM OpeningBalances
	),
	Movements AS (
		SELECT
			J.AccountId,
			SUM(CASE WHEN J.[Direction] > 0 THEN J.[Count] * MU.[BaseAmount] / MU.[UnitAmount] ELSE 0 END) AS CountIn,
			SUM(CASE WHEN J.[Direction] < 0 THEN J.[Count] * MU.[BaseAmount] / MU.[UnitAmount] ELSE 0 END) AS CountOut		
		FROM [dbo].[fi_Journal](@fromDate, @toDate) J
		JOIN [dbo].[Resources] R ON J.ResourceId = R.Id
		JOIN [dbo].MeasurementUnits MU ON R.[MassUnitId] = MU.Id
		WHERE J.AccountId IN (SELECT Id FROM FinishedGoodsAccounts)
		GROUP BY J.AccountId
	),
	M2 AS (
		SELECT AccountId, 
		CountIn * (SELECT [UnitAmount]/[BaseAmount] FROM MeasurementUnits WHERE Id = @CountUnit) AS [CountIn],
		CountOut * (SELECT [UnitAmount]/[BaseAmount] FROM MeasurementUnits WHERE Id = @CountUnit) AS [CountOut]
		FROM Movements
	),
	FinishedGoodsRegsiter AS (
		SELECT COALESCE(OpeningBalances.AccountId, Movements.AccountId) AS AccountId,
			ISNULL(OpeningBalances.[Count],0) AS OpeningCount, 
			ISNULL(Movements.[CountIn],0) AS CountIn, ISNULL(Movements.[CountOut],0) AS CountOut,
			ISNULL(OpeningBalances.[Count], 0) + ISNULL(Movements.[CountIn], 0) + ISNULL(Movements.[CountOut],0) AS EndingCount
		FROM OB2 OpeningBalances
		FULL OUTER JOIN M2 Movements ON OpeningBalances.AccountId = Movements.AccountId
	)
	SELECT FGR.AccountId, A.[Name], A.[Name2], FGR.OpeningCount, FGR.CountIn, FGR.CountOut, FGR.EndingCount
	FROM dbo.Accounts A
	JOIN FinishedGoodsRegsiter FGR ON A.Id = FGR.AccountId