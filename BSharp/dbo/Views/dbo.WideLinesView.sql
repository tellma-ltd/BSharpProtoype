
CREATE VIEW [dbo].[WideLinesView]   
AS
SELECT [TransactionType], 
	MAX(CASE WHEN EntryNumber = 1 THEN [Operation] ELSE NULL END) AS Operation1,
	MAX(CASE WHEN EntryNumber = 1 THEN [Account] ELSE NULL END) AS Account1,
	MAX(CASE WHEN EntryNumber = 1 THEN [Custody] ELSE NULL END) AS Custody1,
	MAX(CASE WHEN EntryNumber = 1 THEN [Resource] ELSE NULL END) AS Resource1,
	MAX(CASE WHEN EntryNumber = 1 THEN [Direction] ELSE NULL END) AS Direction1,
	MAX(CASE WHEN EntryNumber = 1 THEN [Amount] ELSE NULL END) AS Amount1,
	MAX(CASE WHEN EntryNumber = 1 THEN [Value] ELSE NULL END) AS Value1,
	MAX(CASE WHEN EntryNumber = 1 THEN [Note] ELSE NULL END) AS Note1,
	MAX(CASE WHEN EntryNumber = 1 THEN [RelatedReference] ELSE NULL END) AS RelatedReference1,
	MAX(CASE WHEN EntryNumber = 1 THEN [RelatedAgent] ELSE NULL END) AS RelatedAgent1,
	MAX(CASE WHEN EntryNumber = 1 THEN [RelatedResource] ELSE NULL END) AS RelatedResource1,
	MAX(CASE WHEN EntryNumber = 1 THEN [RelatedAmount] ELSE NULL END) AS RelatedAmount1,

	MAX(CASE WHEN EntryNumber = 2 THEN [Operation] ELSE NULL END) AS Operation2,
	MAX(CASE WHEN EntryNumber = 2 THEN [Account] ELSE NULL END) AS Account2,
	MAX(CASE WHEN EntryNumber = 2 THEN [Custody] ELSE NULL END) AS Custody2,
	MAX(CASE WHEN EntryNumber = 2 THEN [Resource] ELSE NULL END) AS Resource2,
	MAX(CASE WHEN EntryNumber = 2 THEN [Direction] ELSE NULL END) AS Direction2,
	MAX(CASE WHEN EntryNumber = 2 THEN [Amount] ELSE NULL END) AS Amount2,
	MAX(CASE WHEN EntryNumber = 2 THEN [Value] ELSE NULL END) AS Value2,
	MAX(CASE WHEN EntryNumber = 2 THEN [Note] ELSE NULL END) AS Note2,
	MAX(CASE WHEN EntryNumber = 2 THEN [RelatedReference] ELSE NULL END) AS RelatedReference2,
	MAX(CASE WHEN EntryNumber = 2 THEN [RelatedAgent] ELSE NULL END) AS RelatedAgent2,
	MAX(CASE WHEN EntryNumber = 2 THEN [RelatedResource] ELSE NULL END) AS RelatedResource2,
	MAX(CASE WHEN EntryNumber = 2 THEN [RelatedAmount] ELSE NULL END) AS RelatedAmount2,

	MAX(CASE WHEN EntryNumber = 3 THEN [Operation] ELSE NULL END) AS Operation3,
	MAX(CASE WHEN EntryNumber = 3 THEN [Account] ELSE NULL END) AS Account3,
	MAX(CASE WHEN EntryNumber = 3 THEN [Custody] ELSE NULL END) AS Custody3,
	MAX(CASE WHEN EntryNumber = 3 THEN [Resource] ELSE NULL END) AS Resource3,
	MAX(CASE WHEN EntryNumber = 3 THEN [Direction] ELSE NULL END) AS Direction3,
	MAX(CASE WHEN EntryNumber = 3 THEN [Amount] ELSE NULL END) AS Amount3,
	MAX(CASE WHEN EntryNumber = 3 THEN [Value] ELSE NULL END) AS Value3,
	MAX(CASE WHEN EntryNumber = 3 THEN [Note] ELSE NULL END) AS Note3,
	MAX(CASE WHEN EntryNumber = 3 THEN [RelatedReference] ELSE NULL END) AS RelatedReference3,
	MAX(CASE WHEN EntryNumber = 3 THEN [RelatedAgent] ELSE NULL END) AS RelatedAgent3,
	MAX(CASE WHEN EntryNumber = 3 THEN [RelatedResource] ELSE NULL END) AS RelatedResource3,
	MAX(CASE WHEN EntryNumber = 3 THEN [RelatedAmount] ELSE NULL END) AS RelatedAmount3
FROM dbo.[TransactionSpecifications] 
WHERE Definition = N'Label'
GROUP BY [TransactionType]

