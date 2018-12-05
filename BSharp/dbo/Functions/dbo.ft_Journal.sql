CREATE FUNCTION [dbo].[ft_Journal] (-- SELECT * FROM [dbo].[ft_Journal]( '01.01.2015','01.01.2020')
	@fromDate Datetime = '2000.01.01', 
	@toDate Datetime = '2100.01.01'
) RETURNS TABLE AS
RETURN
(
	SELECT
		D.Id,
		D.[TransactionType],
		D.SerialNumber,
		D.ResponsibleAgentId,
		L.Id As LineId,
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
		-- covering ratio: (min(End, @to) - max(Start, @from))/(end - start)
		CASE WHEN L.EndDateTime <= @toDate AND L.StartDateTime >= @fromDate THEN 1 ELSE
		(
		 DATEDIFF(s, 
					(CASE WHEN @toDate < L.EndDateTime THEN @toDate ELSE L.EndDateTime END),
					(CASE WHEN @fromDate > L.StartDateTime THEN @fromDate ELSE L.StartDateTime END))
		/ CAST(DATEDIFF(s, L.EndDateTime, L.StartDateTime) AS float) 
		) 
		END As CoveringRatio,
		E.Amount,
		E.[Value],
		E.NoteId,
		E.RelatedReference,
		E.RelatedAgentId,
		E.RelatedResourceId,
		E.RelatedAmount
	FROM 
		[dbo].Entries E
		INNER JOIN [dbo].Lines L ON E.TenantId = L.TenantId AND E.LineId = L.Id
		INNER JOIN [dbo].Documents D ON L.TenantId = D.TenantId AND L.DocumentId = D.Id
	WHERE
		D.TenantId = [dbo].fn_TenantId() AND
		D.Mode = N'Posted' AND 
		D.State = N'Voucher' AND
		L.StartDateTime <= @toDate AND L.EndDateTime >= @fromDate
)
