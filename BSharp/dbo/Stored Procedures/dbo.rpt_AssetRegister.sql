CREATE PROCEDURE [dbo].[rpt_AssetRegister] -- EXEC [dbo].[rpt_AssetRegister] @fromDate = '01.01.2015', @toDate = '01.01.2020'
	@fromDate Datetime = '01.01.2015', 
	@toDate Datetime = '01.01.2020'
AS
BEGIN
	SET NOCOUNT ON;
	SELECT
		RR.[Name] As [Asset], J.[NoteId], 
		SUM(J.[Value] * J.[Direction]) AS [Value],
		SUM(J.[Amount] * J.[Direction]) AS [Lifetime], MU.[Name] As Unit
	FROM [dbo].ft_Journal(@fromDate, @toDate) J
	JOIN [dbo].[Resources] R ON J.ResourceId = R.Id
	JOIN [dbo].[Resources] RR ON R.ServiceOfId = RR.Id
	JOIN [dbo].[MeasurementUnits] MU ON R.MeasurementUnitId = MU.Id
	JOIN dbo.[Notes] N ON J.NoteId = N.Id
	JOIN dbo.Accounts_H AH ON J.AccountId = AH.C
	WHERE AH.P IN (N'PropertyPlantAndEquipment')
	GROUP BY RR.[Name], J.[NoteId], MU.[Name]
END