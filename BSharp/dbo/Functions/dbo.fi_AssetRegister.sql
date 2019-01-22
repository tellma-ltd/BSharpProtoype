CREATE FUNCTION [dbo].[fi_AssetRegister] (
	@fromDate Datetime = '01.01.2015', 
	@toDate Datetime = '01.01.2020'
)
RETURNS TABLE 
AS 
RETURN
	SELECT
		RR.[Name] As [Asset], J.[NoteId], 
		SUM(J.[Value] * J.[Direction]) AS [Value],
		SUM(J.[Amount] * J.[Direction]) AS [Lifetime], MU.[Name] As Unit
	FROM [dbo].[fi_Journal](@fromDate, @toDate) J
	JOIN [dbo].[Resources] R ON J.ResourceId = R.Id
	JOIN [dbo].[Resources] RR ON R.ServiceOfId = RR.Id
	JOIN [dbo].[MeasurementUnits] MU ON R.MeasurementUnitId = MU.Id
	JOIN dbo.[Notes] N ON J.NoteId = N.Id
	JOIN dbo.[Accounts_H] AH ON J.[AccountId] = AH.C
	WHERE AH.P IN (N'PropertyPlantAndEquipment')
	GROUP BY RR.[Name], J.[NoteId], MU.[Name];