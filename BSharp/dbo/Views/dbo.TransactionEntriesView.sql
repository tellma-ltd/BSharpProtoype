CREATE VIEW [dbo].[TransactionEntriesView]
AS
	SELECT
		E.[Id],
		E.[DocumentId],
		D.[DocumentType],
		D.[SerialNumber],
		D.[DocumentDate],
		D.[VoucherReference],
		D.[Lookup1Id] As HeaderLookup1Id,
		D.[Lookup2Id] As HeaderLookup2Id,
		D.[String1] As HeaderString1,
		D.[String2] As HeaderString2,
		D.[Frequency],
		D.[Repetitions],
		D.[EndDate],
		E.[IsSystem],
		E.[Direction],
		E.[AccountId],
		A.[CustomClassificationId],
		A.[IfrsAccountId],		
		E.[IfrsNoteId],
		E.[ResponsibilityCenterId],
		--RC.[OperationId],
		--RC.[ProductCategoryId],
		--RC.[GeographicRegionId],
		--RC.[CustomerSegmentId],
		--RC.[TaxSegmentId],
		E.[AgentAccountId],
		E.[ResourceId],
		E.[Quantity],
		E.[MoneyAmount], -- normalization is already done in the Value and stored in the entry
		E.[Mass],
		E.[Volume],
		E.[Count], -- we can normalize every measure, but just showing a proof of concept
		E.[Time],
		E.[Value],
		E.[ExpectedSettlingDate],
		COALESCE(D.[Memo], E.[Memo]) AS [Memo], -- or is it COALESCE(E.[Memo], D.[Memo])?!
		E.[ExternalReference],
		E.[RelatedResourceId],
		E.[RelatedAgentAccountId],
		E.[RelatedResponsibilityCenterId],
		E.[RelatedQuantity],
		E.[RelatedMoneyAmount],
		E.[RelatedMass],
		E.[RelatedVolume],
		E.[RelatedCount],
		E.[RelatedTime],
		E.[RelatedValue],
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