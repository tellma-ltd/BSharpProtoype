CREATE VIEW [dbo].[TransactionsLinesEntriesDetailsView]
AS
	SELECT
		E.[Id],
		E.[TransactionLineId],
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
		L.[LineTypeId],
		E.[Direction],
		E.[AccountId],
		A.[CustomClassificationId],
		A.[IfrsAccountId],
		A.[AgentId],
		E.[IfrsNoteId],
		E.[ResponsibilityCenterId],
		E.[ResourceId],
		E.[InstanceId],
		E.[BatchCode],
		E.[DueDate],
		E.[Quantity],
		E.[MoneyAmount], -- normalization is already done in the Value and stored in the entry
		E.[Mass],
		E.[Volume],
		E.[Area],
		E.[Length],
		E.[Time],
		E.[Count], -- we can normalize every measure, but just showing a proof of concept
		E.[Value],
		E.[Memo],
		E.[ExternalReference],
		E.[AdditionalReference],
		E.[RelatedResourceId],
		E.[RelatedAgentId],
		E.[RelatedQuantity],
		E.[RelatedMoneyAmount],
		E.[SignedAt],
		E.[SignedById],
		E.[CreatedAt],
		E.[CreatedById],
		E.[ModifiedAt],
		E.[ModifiedById]
	FROM 
		[dbo].[TransactionEntries] E
		JOIN [dbo].[TransactionLines] L ON E.TransactionLineId = L.Id
		JOIN [dbo].[Documents] D ON L.[DocumentId] = D.[Id]
		JOIN dbo.[DocumentTypes] DT ON D.[DocumentType] = DT.[Id]
		JOIN [dbo].[Accounts] A ON E.[AccountId] = A.[Id]
	WHERE
		DT.[DocumentCategory] = N'Transaction' AND D.[DocumentState] = N'Posted';
GO;