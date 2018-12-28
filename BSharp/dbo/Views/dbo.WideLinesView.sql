CREATE VIEW [dbo].[WideLinesView]  
AS
 SELECT
 	D.Id As DocumentId, D.DocumentType, L.Id As [LineId], D.StartDateTime, D.EndDateTime,
	L.[BaseLineId], L.[ScalingFactor], L.[Memo], L.[CreatedAt], L.[CreatedBy], L.[ModifiedAt], L.[ModifiedBy],
	MAX(CASE WHEN E.EntryNumber = 1 THEN E.[OperationId] ELSE NULL END) AS Operation1,
	MAX(CASE WHEN E.EntryNumber = 1 THEN E.[AccountId] ELSE NULL END) AS Account1,
	MAX(CASE WHEN E.EntryNumber = 1 THEN E.[CustodyId] ELSE NULL END) AS Custody1,
	MAX(CASE WHEN E.EntryNumber = 1 THEN E.[ResourceId] ELSE NULL END) AS Resource1,
	MAX(CASE WHEN E.EntryNumber = 1 THEN E.[Direction] ELSE NULL END) AS Direction1,
	MAX(CASE WHEN E.EntryNumber = 1 THEN E.[Amount] ELSE NULL END) AS Amount1,
	MAX(CASE WHEN E.EntryNumber = 1 THEN E.[Value] ELSE NULL END) AS Value1,
	MAX(CASE WHEN E.EntryNumber = 1 THEN E.[NoteId] ELSE NULL END) AS Note1,
	MAX(CASE WHEN E.EntryNumber = 1 THEN E.[RelatedReference] ELSE NULL END) AS RelatedReference1,
	MAX(CASE WHEN E.EntryNumber = 1 THEN E.[RelatedAgentId] ELSE NULL END) AS RelatedAgent1,
	MAX(CASE WHEN E.EntryNumber = 1 THEN E.[RelatedResourceId] ELSE NULL END) AS RelatedResource1,
	MAX(CASE WHEN E.EntryNumber = 1 THEN E.[RelatedAmount] ELSE NULL END) AS RelatedAmount1,

	MAX(CASE WHEN E.EntryNumber = 2 THEN E.[OperationId] ELSE NULL END) AS Operation2,
	MAX(CASE WHEN E.EntryNumber = 2 THEN E.[AccountId] ELSE NULL END) AS Account2,
	MAX(CASE WHEN E.EntryNumber = 2 THEN E.[CustodyId] ELSE NULL END) AS Custody2,
	MAX(CASE WHEN E.EntryNumber = 2 THEN E.[ResourceId] ELSE NULL END) AS Resource2,
	MAX(CASE WHEN E.EntryNumber = 2 THEN E.[Direction] ELSE NULL END) AS Direction2,
	MAX(CASE WHEN E.EntryNumber = 2 THEN E.[Amount] ELSE NULL END) AS Amount2,
	MAX(CASE WHEN E.EntryNumber = 2 THEN E.[Value] ELSE NULL END) AS Value2,
	MAX(CASE WHEN E.EntryNumber = 2 THEN E.[NoteId] ELSE NULL END) AS Note2,
	MAX(CASE WHEN E.EntryNumber = 2 THEN E.[RelatedReference] ELSE NULL END) AS RelatedReference2,
	MAX(CASE WHEN E.EntryNumber = 2 THEN E.[RelatedAgentId] ELSE NULL END) AS RelatedAgent2,
	MAX(CASE WHEN E.EntryNumber = 2 THEN E.[RelatedResourceId] ELSE NULL END) AS RelatedResource2,
	MAX(CASE WHEN E.EntryNumber = 2 THEN E.[RelatedAmount] ELSE NULL END) AS RelatedAmount2,

	MAX(CASE WHEN E.EntryNumber = 3 THEN E.[OperationId] ELSE NULL END) AS Operation3,
	MAX(CASE WHEN E.EntryNumber = 3 THEN E.[AccountId] ELSE NULL END) AS Account3,
	MAX(CASE WHEN E.EntryNumber = 3 THEN E.[CustodyId] ELSE NULL END) AS Custody3,
	MAX(CASE WHEN E.EntryNumber = 3 THEN E.[ResourceId] ELSE NULL END) AS Resource3,
	MAX(CASE WHEN E.EntryNumber = 3 THEN E.[Direction] ELSE NULL END) AS Direction3,
	MAX(CASE WHEN E.EntryNumber = 3 THEN E.[Amount] ELSE NULL END) AS Amount3,
	MAX(CASE WHEN E.EntryNumber = 3 THEN E.[Value] ELSE NULL END) AS Value3,
	MAX(CASE WHEN E.EntryNumber = 3 THEN E.[NoteId] ELSE NULL END) AS Note3,
	MAX(CASE WHEN E.EntryNumber = 3 THEN E.[RelatedReference] ELSE NULL END) AS RelatedReference3,
	MAX(CASE WHEN E.EntryNumber = 3 THEN E.[RelatedAgentId] ELSE NULL END) AS RelatedAgent3,
	MAX(CASE WHEN E.EntryNumber = 3 THEN E.[RelatedResourceId] ELSE NULL END) AS RelatedResource3,
	MAX(CASE WHEN E.EntryNumber = 3 THEN E.[RelatedAmount] ELSE NULL END) AS RelatedAmount3

FROM [dbo].Entries E JOIN [dbo].[Lines] L ON E.LineId = L.Id
JOIN [dbo].[Documents] D ON D.Id = L.DocumentId
GROUP BY
	D.Id, D.DocumentType, L.Id, D.StartDateTime, D.EndDateTime,
	L.[BaseLineId], L.[ScalingFactor], L.[Memo],
	L.[CreatedAt], L.[CreatedBy], L.[ModifiedAt], L.[ModifiedBy];