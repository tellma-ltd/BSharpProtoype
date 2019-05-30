CREATE FUNCTION [dbo].[fi_IFRSDisclosureDetails] (
	@fromDate Date = NULL, 
	@toDate Date = NULL
) RETURNS TABLE
AS
RETURN
	SELECT S.* FROM dbo.[IFRSDisclosureDetails] S
	JOIN (
	SELECT [IFRSDisclosureId], MAX([ValidSince]) AS ValidSince
	FROM [dbo].[IFRSDisclosureDetails]
	WHERE [ValidSince] <= @fromDate
	GROUP BY [IFRSDisclosureId]
	) H ON S.[IFRSDisclosureId] = H.[IFRSDisclosureId] AND S.[ValidSince] = H.[ValidSince];