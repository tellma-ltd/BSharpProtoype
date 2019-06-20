CREATE VIEW [dbo].[TransactionsEntriesSummaryView]
AS
	SELECT
		ROW_NUMBER() OVER(ORDER BY L.[DocumentId] ASC,
			SUM(E.[Direction] * E.[Value]) DESC) AS [Id],
		L.[DocumentId],
		D.[DocumentType],
		D.[SerialNumber],
		D.[DocumentDate],
		D.[VoucherReference],
		D.[DocumentLookup1Id],
		D.[DocumentLookup2Id],
		D.[DocumentLookup3Id],
		D.[DocumentText1],
		D.[DocumentText2],
		D.[Frequency],
		D.[Repetitions],
		D.[EndDate],
		D.[CreatedAt],
		D.[CreatedById],
		D.[ModifiedAt],
		D.[ModifiedById],
		CASE
			WHEN SUM(E.[Direction] * E.[Quantity]) > 0 OR 
					SUM(E.[Direction] * E.[Value]) > 0
			THEN 1 ELSE -1 END AS [Direction],
		E.[AccountId],
		E.[IfrsNoteId],
		E.[ResponsibilityCenterId],
		E.[ResourceId],
		E.[InstanceId],
		E.[BatchCode],
		SUM(E.[Direction] * E.[Quantity]) AS [Quantity],
		SUM(E.[Direction] * E.[MoneyAmount]) AS [MoneyAmount],
		SUM(E.[Direction] * E.[Mass]) AS [Mass],
		SUM(E.[Direction] * E.[Volume]) AS [Volume],
		SUM(E.[Direction] * E.[Area]) AS [Area],
		SUM(E.[Direction] * E.[Length]) AS [Length],
		SUM(E.[Direction] * E.[Time]) AS [Time],
		SUM(E.[Direction] * E.[Count]) AS [Count], -- we can normalize every measure, but just showing a proof of concept
		SUM(E.[Direction] * E.[Value]) AS [Value],
		E.[Memo],
		E.[ExternalReference],
		E.[AdditionalReference],
		E.[RelatedResourceId],
		E.[RelatedAgentId],
		SUM(E.[Direction] * E.[RelatedQuantity]) AS [RelatedQuantity],
		SUM(E.[Direction] * E.[RelatedMoneyAmount]) AS [RelatedMoneyAmount]
	FROM 
		[dbo].[TransactionEntries] E
		JOIN [dbo].[TransactionLines] L ON E.TransactionLineId = L.Id
		JOIN [dbo].[Documents] D ON L.[DocumentId] = D.[Id]
		JOIN dbo.[DocumentTypes] DT ON D.[DocumentType] = DT.[Id]
	WHERE
		DT.[DocumentCategory] = N'Transaction' AND D.[DocumentState] = N'Posted'
	GROUP BY
		L.[DocumentId],
		D.[DocumentType],
		D.[SerialNumber],
		D.[DocumentDate],
		D.[VoucherReference],
		D.[DocumentLookup1Id],
		D.[DocumentLookup2Id],
		D.[DocumentLookup3Id],
		D.[DocumentText1],
		D.[DocumentText2],
		D.[Frequency],
		D.[Repetitions],
		D.[EndDate],
		D.[CreatedAt],
		D.[CreatedById],
		D.[ModifiedAt],
		D.[ModifiedById],
		E.[AccountId],
		E.[IfrsNoteId],
		E.[ResponsibilityCenterId],
		E.[ResourceId],
		E.[InstanceId],
		E.[BatchCode],
		E.[Memo],
		E.[ExternalReference],
		E.[AdditionalReference],
		E.[RelatedResourceId],
		E.[RelatedAgentId]
	HAVING
			SUM(E.[Direction] * E.[Quantity]) <> 0 OR
			SUM(E.[Direction] * E.[Value]) <> 0
	;
GO;