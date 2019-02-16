CREATE FUNCTION [dbo].[fi_AssetRegister] (
	@fromDate Datetime = '01.01.2015', 
	@toDate Datetime = '01.01.2020'
)
RETURNS TABLE 
AS 
RETURN
	WITH PPE AS (
		SELECT IFRSConceptNode 
		FROM dbo.IFRSConcepts WHERE IFRSConceptId = N'PropertyPlandAndEquipment'
	)
	SELECT COALESCE(TB.[Asset], TM.[Asset]) AS [Asset],
			TB.[Count] AS OpeningCount,
			TM.[Count] AS CountChange,
			ISNULL(TB.[Count], 0) + ISNULL(TM.[Count], 0) AS EndingCount

	FROM
	(
		SELECT
			R.[Id], R.[Name] As [Asset],
			SUM(J.[Count] * J.[Direction]) AS [Count],
			SUM(J.[Value] * J.[Direction]) AS [Value],
			SUM(J.[Usage] * J.[Direction]) AS [Lifetime], MU.[Name] As Unit
		FROM [dbo].[fi_Journal](NULL, @fromDate) J
		JOIN [dbo].[Resources] R ON J.ResourceId = R.Id
		JOIN [dbo].[MeasurementUnits] MU ON R.MeasurementUnitId = MU.Id
		JOIN dbo.[Notes] N ON J.NoteId = N.Id
		JOIN dbo.[Accounts] A ON J.AccountId = A.Id
		JOIN dbo.IFRSConcepts I ON A.IFRSConceptId = I.IFRSConceptId
		WHERE I.IFRSConceptNode.IsDescendantOf((SELECT * FROM PPE))	= 1
		GROUP BY R.[Name], MU.[Name]
	) TB
	FULL OUTER JOIN
	(
		SELECT
			R.[Id], R.[Name] As [Asset], J.[NoteId],
			SUM(J.[Count] * J.[Direction]) AS [Count],
			SUM(J.[Value] * J.[Direction]) AS [Value],
			SUM(J.[Usage] * J.[Direction]) AS [Lifetime], MU.[Name] As Unit
		FROM [dbo].[fi_Journal](@fromDate, @toDate) J
		JOIN [dbo].[Resources] R ON J.ResourceId = R.Id
		JOIN [dbo].[MeasurementUnits] MU ON R.MeasurementUnitId = MU.Id
		JOIN dbo.[Notes] N ON J.NoteId = N.Id
		JOIN dbo.[Accounts] A ON J.AccountId = A.Id
		JOIN dbo.IFRSConcepts I ON A.IFRSConceptId = I.IFRSConceptId
		WHERE I.IFRSConceptNode.IsDescendantOf((SELECT * FROM PPE))	= 1
		GROUP BY R.[Id], R.[Name], J.[NoteId], MU.[Name]
	) TM ON TB.Id = TM.Id