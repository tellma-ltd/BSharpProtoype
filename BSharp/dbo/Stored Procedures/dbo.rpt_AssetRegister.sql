CREATE PROCEDURE [dbo].[rpt_AssetRegister]
	@fromDate Datetime = '01.01.2015', 
	@toDate Datetime = '01.01.2020'
AS
BEGIN
	WITH IFRSFixedAssetAccounts	AS (
		SELECT Id FROM dbo.[IFRSAccounts]
		WHERE [Node].IsDescendantOf(
			(SELECT [Node] FROM dbo.IFRSAccounts WHERE Id = N'PropertyPlandAndEquipment')
		) = 1
	),
	FixedAssetAccounts AS (
		SELECT Id FROM dbo.[Accounts]
		WHERE IFRSAccountId IN
			(SELECT [Id] FROM IFRSFixedAssetAccounts)
	),
	OpeningBalances AS (
		SELECT
			J.ResourceId,
			SUM(J.[Count] * J.[Direction]) AS [Count],
			SUM(J.[Value] * J.[Direction]) AS [Value],
			SUM(J.[Time] * J.[Direction]) AS [ServiceLife]
		FROM [dbo].[fi_Journal](NULL, @fromDate) J
		WHERE J.AccountId IN (SELECT Id FROM FixedAssetAccounts)
		GROUP BY J.ResourceId
	),
	Movements AS (
		SELECT
			J.ResourceId, J.[IFRSNoteId],
			SUM(J.[Count] * J.[Direction]) AS [Count],
			SUM(J.[Value] * J.[Direction]) AS [Value],
			SUM(J.[Time] * J.[Direction]) AS [ServiceLife]
		FROM [dbo].[fi_Journal](@fromDate, @toDate) J
		WHERE J.AccountId IN (SELECT Id FROM FixedAssetAccounts)
		GROUP BY J.ResourceId, J.[IFRSNoteId]
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
END