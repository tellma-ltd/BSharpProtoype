CREATE PROCEDURE [dbo].[rpt_AssetRegister] -- EXEC [dbo].[rpt_AssetRegister] @fromDate = '01.01.2015', @toDate = '01.01.2020'
	@fromDate Datetime = '01.01.2015', 
	@toDate Datetime = '01.01.2020'
AS
BEGIN
	SET NOCOUNT ON;
	SELECT
		R.[Name] As [Asset], J.[NoteId], 
		SUM([Value] * [Direction]) AS [Value],
		SUM([Amount] * [Direction]) AS [Lifetime], MU.[Name] As Unit
	FROM [dbo].ft_Journal(@fromDate, @toDate) J
	JOIN [dbo].[Resources] R ON J.ResourceId = R.Id
	JOIN [dbo].[MeasurementUnits] MU ON R.MeasurementUnitId = MU.Id
	JOIN dbo.[Notes] N ON J.NoteId = N.Id
	JOIN dbo.Accounts_H AH ON J.AccountId = AH.C
	WHERE AH.P IN (N'PropertyPlantAndEquipment')
	GROUP BY R.[Name], J.[NoteId], MU.[Name]
END