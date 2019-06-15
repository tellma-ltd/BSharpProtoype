CREATE VIEW [dbo].[TransactionsEntriesView]
AS
	SELECT
		E.[Id],
		E.[DocumentId],
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
		E.[IsSystem],
		E.[Direction],
		E.[AccountId],
		A.[CustomClassificationId],
		A.[IfrsAccountId],
		A.[AgentId],
		E.[IfrsNoteId],
		E.[ResponsibilityCenterId],
		--RC.[OperationId],
		--RC.[ProductCategoryId],
		--RC.[GeographicRegionId],
		--RC.[CustomerSegmentId],
		--RC.[TaxSegmentId],
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
		--E.[RelatedResponsibilityCenterId],
		E.[RelatedQuantity],
		E.[RelatedMoneyAmount],
		--E.[RelatedMass],
		--E.[RelatedVolume],
		--E.[RelatedCount],
		--E.[RelatedTime],
		--E.[RelatedValue],
		E.[CreatedAt],
		E.[CreatedById],
		E.[ModifiedAt],
		E.[ModifiedById]
	FROM 
		[dbo].[TransactionEntries] E
		JOIN [dbo].[Documents] D ON E.[DocumentId] = D.[Id]
		JOIN dbo.[DocumentTypes] DT ON D.[DocumentType] = DT.[Id]
		JOIN [dbo].[Accounts] A ON E.[AccountId] = A.[Id]
	WHERE
		DT.[DocumentCategory] = N'Transaction' AND D.[DocumentState] = N'Posted';
GO;