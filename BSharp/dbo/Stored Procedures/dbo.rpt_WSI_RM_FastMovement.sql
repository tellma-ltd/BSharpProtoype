CREATE PROCEDURE [dbo].[rpt_WSI_RM_FastMovement]
/*
Assumptions:
1) Any inventory account is mapped to IFRS concepts: Inventories, NonCurrentinventories, or their descendants
2) All entries use a raw material resource. For balance migration, we need to add for every inventory account
	a resource called non-specified (for that account), and migrate balances to it.

*/
	@fromDate Datetime = '01.01.2015', 
	@toDate Datetime = '01.01.2020'
AS
	WITH
	IFRS_RM AS (
		SELECT [Node] 
		FROM dbo.[IFRSAccounts] WHERE [Id] IN(N'RawMaterials')
	),
	RawMaterialAccounts AS (
		SELECT [Id] FROM dbo.Accounts A
		JOIN dbo.[IFRSAccounts] I ON A.[IFRSAccountId] = I.[Id]
		WHERE I.[Node].IsDescendantOf((SELECT * FROM IFRS_RM))	= 1
	),/*
	-- To avoid IFRS, we need to define an account type:
	FixedAssetAccounts AS (
		SELECT [Id] FROM dbo.Accounts
		WHERE AccountType = N'RawMaterials'
	), */
	Movements AS (
		SELECT TOP 10
			J.ResourceId,	
			SUM(CASE WHEN J.[Direction] > 0 THEN J.[Mass] ELSE 0 END) AS MassIn,
			SUM(CASE WHEN J.[Direction] < 0 THEN J.[Mass] ELSE 0 END) AS MassOut
		FROM [dbo].[fi_Journal](@fromDate, @toDate) J
		WHERE J.AccountId IN (SELECT Id FROM RawMaterialAccounts)
		GROUP BY J.ResourceId
	),
	RawMaterialsFast AS (
		SELECT TOP 10 ResourceId, Movements.MassIn, Movements.MassOut			
		FROM Movements
		ORDER BY Movements.MassOut DESC
	)
	SELECT RMF.ResourceId, R.[Name], R.[Name2], MU.[Name] As Unit, MU.Name2 As Unit2,
		RMF.MassOut, RMF.MassIn
	FROM dbo.Resources R 
	JOIN RawMaterialsFast RMF ON R.Id = RMF.ResourceId
	JOIN [dbo].[MeasurementUnits] MU ON R.[MassUnitId] = MU.Id
