CREATE FUNCTION [dbo].[ft_Journal] (-- SELECT * FROM [dbo].[ft_Journal]('01.01.2015','01.01.2020')
	@fromDate Datetime = '2000.01.01', 
	@toDate Datetime = '2100.01.01'
) RETURNS TABLE AS
RETURN
(
	SELECT
		D.Id,
		D.[TransactionType],
		D.SerialNumber,
		--D.ResponsibleAgentId,
		--D.ForwardedToAgentId,
		L.Id As [LineId],
		CONVERT(NVARCHAR(255), 
		(CASE WHEN @fromDate > L.StartDateTime THEN @fromDate ELSE L.StartDateTime END), 104) As StartDateTime,
		CONVERT(NVARCHAR(255), 			
		(CASE WHEN @toDate < L.EndDateTime THEN @toDate ELSE L.EndDateTime END), 104) As EndDateTime,
		L.Memo,
		E.Id As EntryId,
		E.EntryNumber,
		E.OperationId,
		E.Reference,
		E.AccountId,
		E.CustodyId,
		E.ResourceId,
		E.Direction,
		CASE WHEN 
			L.StartDateTime = L.EndDateTime 
		THEN 
			E.[Amount]
		ELSE
			DATEDIFF(DAY,
				(SELECT MAX(startDT)	FROM (VALUES (L.StartDateTime), (@fromDate)) As StartTimes(startDT)),
				(SELECT MIN(endDT)		FROM (VALUES (L.EndDateTime),	(@toDate))	As EndTimes(endDT))
			) * E.[Amount]
		END AS Amount,
		CASE WHEN 
			L.StartDateTime = L.EndDateTime 
		THEN 
			E.[Value]
		ELSE
			DATEDIFF(DAY,
				(SELECT MAX(startDT)	FROM (VALUES (L.StartDateTime), (@fromDate)) As StartTimes(startDT)),
				(SELECT MIN(endDT)		FROM (VALUES (L.EndDateTime),	(@toDate))	As EndTimes(endDT))
			) * E.[Value]
		END AS [Value],
--CAST(DATEDIFF(DAY, L.EndDateTime, L.StartDateTime) AS FLOAT) 
		E.NoteId,
		E.RelatedReference,
		E.RelatedAgentId,
		E.RelatedResourceId,
		E.RelatedAmount
	FROM 
		[dbo].Entries E
		INNER JOIN [dbo].[Lines] L ON E.TenantId = L.TenantId AND E.LineId = L.Id
		INNER JOIN [dbo].[Documents] D ON L.TenantId = D.TenantId AND L.DocumentId = D.Id
	WHERE
		D.Mode = N'Posted' AND 
		D.State = N'Voucher' AND
		L.StartDateTime < @toDate AND L.EndDateTime >= @fromDate
)
