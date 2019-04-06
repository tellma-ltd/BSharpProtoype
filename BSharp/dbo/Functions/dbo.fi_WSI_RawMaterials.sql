CREATE FUNCTION [dbo].[fi_WSI_RawMaterials] (
-- Available also as a stored procedure.
-- I kept both formats until we decide which one is more suitable for B#
	@fromDate Datetime = '01.01.2015', 
	@toDate Datetime = '01.01.2020'
)
RETURNS TABLE 
AS 
RETURN
	WITH
	OpeningBalances AS (
		SELECT
			J.ResourceId,
			SUM(J.[Count] * J.[Direction]) AS [Count],
			SUM(J.[Mass] * J.[Direction]) AS [Mass]
		FROM [dbo].[fi_Journal](NULL, @fromDate) J
		WHERE J.[IFRSAccountId] = N'RawMaterials'
		-- No IFRS? J.AccountType = N'RawMaterials'
		GROUP BY J.ResourceId
	),
	Movements AS (
		SELECT
			J.ResourceId,
			SUM(CASE WHEN J.[Direction] > 0 THEN J.[Count] ELSE 0 END) AS CountIn,
			SUM(CASE WHEN J.[Direction] > 0 THEN J.[Mass] ELSE 0 END) AS MassIn,
			SUM(CASE WHEN J.[Direction] < 0 THEN J.[Count] ELSE 0 END) AS CountOut,			
			SUM(CASE WHEN J.[Direction] < 0 THEN J.[Mass] ELSE 0 END) AS MassOut
		FROM [dbo].[fi_Journal](@fromDate, @toDate) J
		WHERE J.[IFRSAccountId] = N'RawMaterials'
		-- No IFRS? J.AccountType = N'RawMaterials'
		GROUP BY J.ResourceId
	),
	RawMaterialsRegsiter AS (
		SELECT COALESCE(OpeningBalances.ResourceId, Movements.ResourceId) AS ResourceId,
				ISNULL(OpeningBalances.[Count],0) AS OpeningCount, 
				ISNULL(Movements.[CountIn],0) AS CountIn, ISNULL(Movements.[CountOut],0) AS CountOut,
				ISNULL(OpeningBalances.[Count], 0) + ISNULL(Movements.[CountIn], 0) + ISNULL(Movements.[CountOut],0) AS EndingCount,

				ISNULL(OpeningBalances.[Mass],0) AS OpeningMass, 
				ISNULL(Movements.[MassIn],0) AS MassIn, ISNULL(Movements.[MassOut],0) AS MassOut,
				ISNULL(OpeningBalances.[Mass], 0) + ISNULL(Movements.[MassIn], 0) + ISNULL(Movements.[MassOut],0) AS EndingMass
		FROM OpeningBalances
		FULL OUTER JOIN Movements ON OpeningBalances.ResourceId = Movements.ResourceId
	)

	SELECT RMR.ResourceId, R.[Name], R.[Name2], MU.[Name] As Unit, MU.Name2 As Unit2,
		RMR.OpeningCount, RMR.OpeningMass,
		RMR.CountIn, RMR.MassIn, RMR.CountOut, RMR.MassOut,
		RMR.EndingCount, RMR.EndingMass
FROM dbo.Resources R JOIN RawMaterialsRegsiter RMR ON R.Id = RMR.ResourceId
JOIN [dbo].[MeasurementUnits] MU ON R.[MassUnitId] = MU.Id;