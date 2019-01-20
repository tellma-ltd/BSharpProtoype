CREATE FUNCTION [dbo].[fi_Journal] (-- SELECT * FROM [dbo].[fi_Journal]('01.01.2015','01.01.2020')
	@fromDate Datetime = '2000.01.01', 
	@toDate Datetime = '2100.01.01'
) RETURNS TABLE
AS
RETURN
	SELECT
		D.Id,
		D.[DocumentType],
		D.SerialNumber,
		--D.ResponsibleAgentId,
		--D.ForwardedToAgentId,
		L.Id As [LineId],
		CONVERT(NVARCHAR(255), 
		(CASE WHEN @fromDate > D.StartDateTime THEN @fromDate ELSE D.StartDateTime END), 102) As StartDateTime,
		CONVERT(NVARCHAR(255), 			
		(CASE WHEN @toDate < D.EndDateTime THEN @toDate ELSE D.EndDateTime END), 102) As EndDateTime,
		L.Memo,
		E.Id As EntryId,
		E.EntryNumber,
		E.OperationId,
		E.Reference,
		E.AccountId,
		E.CustodyId,
		E.ResourceId,
		E.Direction,
		CASE 
			WHEN D.Frequency = N'OneTime' THEN E.[Amount]
			WHEN D.Frequency = N'Daily'
			THEN
				DATEDIFF(DAY,
					(SELECT MAX(startDT)	FROM (VALUES (D.StartDateTime), (@fromDate)) As StartTimes(startDT)),
					(SELECT MIN(endDT)		FROM (VALUES (D.EndDateTime),	(@toDate))	As EndTimes(endDT))
				) * E.[Amount]
			WHEN D.Frequency = N'Weekly'
			THEN
				DATEDIFF(WEEK,
					(SELECT MAX(startDT)	FROM (VALUES (D.StartDateTime), (@fromDate)) As StartTimes(startDT)),
					(SELECT MIN(endDT)		FROM (VALUES (D.EndDateTime),	(@toDate))	As EndTimes(endDT))
				) * E.[Amount]
			WHEN D.Frequency = N'Monthly'
			THEN
				DATEDIFF(MONTH,
					(SELECT MAX(startDT)	FROM (VALUES (D.StartDateTime), (@fromDate)) As StartTimes(startDT)),
					(SELECT MIN(endDT)		FROM (VALUES (D.EndDateTime),	(@toDate))	As EndTimes(endDT))
				) * E.[Amount]
			WHEN D.Frequency = N'Quarterly'
			THEN
				DATEDIFF(QUARTER,
					(SELECT MAX(startDT)	FROM (VALUES (D.StartDateTime), (@fromDate)) As StartTimes(startDT)),
					(SELECT MIN(endDT)		FROM (VALUES (D.EndDateTime),	(@toDate))	As EndTimes(endDT))
				) * E.[Amount]
			WHEN D.Frequency = N'Yearly'
			THEN
				DATEDIFF(YEAR,
					(SELECT MAX(startDT)	FROM (VALUES (D.StartDateTime), (@fromDate)) As StartTimes(startDT)),
					(SELECT MIN(endDT)		FROM (VALUES (D.EndDateTime),	(@toDate))	As EndTimes(endDT))
				) * E.[Amount]
		END AS [Amount],
		CASE 
			WHEN D.Frequency = N'OneTime' THEN E.[Value]
			WHEN D.Frequency = N'Daily'
			THEN
				DATEDIFF(DAY,
					(SELECT MAX(startDT)	FROM (VALUES (D.StartDateTime), (@fromDate)) As StartTimes(startDT)),
					(SELECT MIN(endDT)		FROM (VALUES (D.EndDateTime),	(@toDate))	As EndTimes(endDT))
				) * E.[Value]
			WHEN D.Frequency = N'Weekly'
			THEN
				DATEDIFF(WEEK,
					(SELECT MAX(startDT)	FROM (VALUES (D.StartDateTime), (@fromDate)) As StartTimes(startDT)),
					(SELECT MIN(endDT)		FROM (VALUES (D.EndDateTime),	(@toDate))	As EndTimes(endDT))
				) * E.[Value]
			WHEN D.Frequency = N'Monthly'
			THEN
				DATEDIFF(MONTH,
					(SELECT MAX(startDT)	FROM (VALUES (D.StartDateTime), (@fromDate)) As StartTimes(startDT)),
					(SELECT MIN(endDT)		FROM (VALUES (D.EndDateTime),	(@toDate))	As EndTimes(endDT))
				) * E.[Value]
			WHEN D.Frequency = N'Quarterly'
			THEN
				DATEDIFF(QUARTER,
					(SELECT MAX(startDT)	FROM (VALUES (D.StartDateTime), (@fromDate)) As StartTimes(startDT)),
					(SELECT MIN(endDT)		FROM (VALUES (D.EndDateTime),	(@toDate))	As EndTimes(endDT))
				) * E.[Value]
			WHEN D.Frequency = N'Yearly'
			THEN
				DATEDIFF(YEAR,
					(SELECT MAX(startDT)	FROM (VALUES (D.StartDateTime), (@fromDate)) As StartTimes(startDT)),
					(SELECT MIN(endDT)		FROM (VALUES (D.EndDateTime),	(@toDate))	As EndTimes(endDT))
				) * E.[Value]
		END AS [Value],
		E.NoteId,
		E.RelatedReference,
		E.RelatedAgentId,
		E.RelatedResourceId,
		E.RelatedAmount
	FROM 
		[dbo].Entries E
		INNER JOIN [dbo].[Lines] L ON E.TenantId = L.TenantId AND E.LineId = L.Id
		INNER JOIN [dbo].[Documents] D ON L.TenantId = D.TenantId AND L.DocumentId = D.Id
		INNER JOIN [dbo].[Resources] R ON E.ResourceId = R.Id
	WHERE
		D.Mode = N'Posted' AND 
		D.State = N'Voucher' AND
		D.StartDateTime < @toDate AND D.EndDateTime >= @fromDate;