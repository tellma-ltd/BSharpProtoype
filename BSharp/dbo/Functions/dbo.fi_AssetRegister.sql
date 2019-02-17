CREATE FUNCTION [dbo].[fi_AssetRegister] (
	@fromDate Datetime = '01.01.2015', 
	@toDate Datetime = '01.01.2020'
)
RETURNS TABLE 
AS 
RETURN
	WITH
	IFRS_PPE AS (
		SELECT IFRSConceptNode 
		FROM dbo.IFRSConcepts WHERE IFRSConceptId = N'PropertyPlandAndEquipment'
	),
	FixedAssetAccounts AS (
		SELECT [Id] FROM dbo.Accounts A
		JOIN dbo.IFRSConcepts I ON A.IFRSConceptId = I.IFRSConceptId
		WHERE I.IFRSConceptNode.IsDescendantOf((SELECT * FROM IFRS_PPE))	= 1
	), /*
	-- To avoid IFRS, we need to define an account type, which is already there:
	FixedAssetAccounts AS (
		SELECT [Id] FROM dbo.Accounts
		WHERE AccountType = N'PropertyPlandAndEquipment'
	), */
	OpeningBalances AS (
		SELECT
			J.ResourceId,
			SUM(J.[Count] * J.[Direction]) AS [Count],
			SUM(J.[Value] * J.[Direction]) AS [Value],
			SUM(J.[ServiceTime] * J.[Direction]) AS [ServiceLife]
		FROM [dbo].[fi_Journal](NULL, @fromDate) J
		WHERE J.AccountId IN (SELECT Id FROM FixedAssetAccounts)
		GROUP BY J.ResourceId
	),
	Movements AS (
		SELECT
			J.ResourceId, J.[NoteId],
			SUM(J.[Count] * J.[Direction]) AS [Count],
			SUM(J.[Value] * J.[Direction]) AS [Value],
			SUM(J.[ServiceTime] * J.[Direction]) AS [ServiceLife]
		FROM [dbo].[fi_Journal](@fromDate, @toDate) J
		WHERE J.AccountId IN (SELECT Id FROM FixedAssetAccounts)
		GROUP BY J.ResourceId, J.[NoteId]
	),
	FixedAssetRegsiter AS (
		SELECT COALESCE(OpeningBalances.ResourceId, Movements.ResourceId) AS ResourceId,
				ISNULL(OpeningBalances.[Count],0) AS OpeningCount, ISNULL(Movements.[Count],0) AS CountChange,
				ISNULL(OpeningBalances.[Count], 0) + ISNULL(Movements.[Count], 0) AS EndingCount,

				ISNULL(OpeningBalances.[ServiceLife],0) AS OpeningServiceLife, ISNULL(Movements.[ServiceLife],0) AS ServiceLifeChange,
				ISNULL(OpeningBalances.[ServiceLife], 0) + ISNULL(Movements.[ServiceLife], 0) AS EndingServiceLife,

				ISNULL(OpeningBalances.[Value],0) AS OpeningValue, ISNULL(Movements.[Value],0) AS ValueChange,
				ISNULL(OpeningBalances.[Value], 0) + ISNULL(Movements.[Value], 0) AS EndingValue
		FROM OpeningBalances
		FULL OUTER JOIN Movements ON OpeningBalances.ResourceId = Movements.ResourceId
	)
SELECT FAR.ResourceId, R.[Name], R.[Name2], MU.[Name] As Unit, MU.Name2 As Unit2,
		FAR.OpeningCount, FAR.OpeningServiceLife, FAR.OpeningValue,
		FAR.CountChange, FAR.ServiceLifeChange, FAR.ValueChange,
		FAR.EndingCount, FAR.EndingServiceLife, FAR.EndingValue
FROM dbo.Resources R JOIN FixedAssetRegsiter FAR ON R.Id = FAR.ResourceId
JOIN [dbo].[MeasurementUnits] MU ON R.[MassUnitId] = MU.Id;