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
		D.AssigneeId,
		CONVERT(NVARCHAR(255), 
		(CASE WHEN @fromDate > D.StartDateTime THEN @fromDate ELSE D.StartDateTime END), 102) As StartDateTime,
		CONVERT(NVARCHAR(255), 			
		(CASE WHEN @toDate < D.EndDateTime THEN @toDate ELSE D.EndDateTime END), 102) As EndDateTime,
		E.Id As EntryId,
		E.LineType,
		E.Direction,
		E.AccountId,
		E.OperationId,
		E.[AgentId],
		E.ResourceId,
		E.[Mass],
		E.[Volume],
		E.[Count],
		E.[Usage],
		E.[FCY],
		E.[Value],
		E.[NoteId],
		E.[Reference],
		E.[Memo],
		E.[ExpectedClosingDate],
		E.[RelatedResourceId],
		E.[RelatedReference],
		E.[RelatedAgentId],
		E.[RelatedAmount]
		/*
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
		*/

	FROM 
		[dbo].[Entries] E
		INNER JOIN [dbo].[Documents] D ON E.DocumentId = D.Id
	WHERE
		D.Mode		= N'Posted' AND 
		D.[State]	= N'Voucher' AND
		D.StartDateTime < @toDate AND D.EndDateTime >= @fromDate;