
CREATE FUNCTION [dbo].[ft_Journal] (-- SELECT * FROM [dbo].[ft_Journal]( '01.01.2015','01.01.2020')
	@fromDate Datetime = '01.01.2000', 
	@toDate Datetime = '01.01.2100'
) RETURNS TABLE AS
RETURN
(
	SELECT
		D.Id,
		D.TransactionType,
		D.SerialNumber,
		D.RecordedByUserId,
		CONVERT(nvarchar(50), D.RecordedOnDateTime, 104) AS RecordedOnDateTime,
		L.LineNumber,
		L.LineType,
		L.ResponsibleAgentId,
		CONVERT(nvarchar(50), 
		(CASE WHEN @fromDate > L.StartDateTime THEN @fromDate ELSE L.StartDateTime END), 104) As StartDateTime,
		CONVERT(nvarchar(50), 			
		(CASE WHEN @toDate < L.EndDateTime THEN @toDate ELSE L.EndDateTime END), 104) As EndDateTime,
		E.EntryNumber,
		E.OperationId,
		E.Reference,
		E.AccountId,
		E.CustodyId,
		E.ResourceId,
		E.Direction,
		-- covering ratio: (min(End, @to) - max(Start, @from))/(end - start)
		 DATEDIFF(s, (CASE WHEN @toDate < L.EndDateTime THEN @toDate ELSE L.EndDateTime END), (CASE WHEN @fromDate > L.StartDateTime THEN @fromDate ELSE L.StartDateTime END))
		/ CAST(DATEDIFF(s, L.EndDateTime, L.StartDateTime) AS float) As CoveringRatio,
		E.Amount,
		E.[Value],
		E.NoteId,
		E.RelatedReference,
		E.RelatedAgentId,
		E.RelatedResourceId,
		E.RelatedAmount
	FROM dbo.Entries E
	INNER JOIN dbo.Lines L ON E.DocumentId = L.DocumentId AND E.LineNumber = L.LineNumber
	INNER JOIN dbo.Documents D ON L.DocumentId = D.Id
	WHERE D.Mode = N'Posted' AND D.State = N'Event'
	AND L.StartDateTime < @toDate AND L.EndDateTime >= @fromDate
)
