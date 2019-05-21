CREATE VIEW [dbo].[TransactionEntriesView] WITH SCHEMABINDING
-- It probably helps to materialize it, and add indices to:
-- AccountId, IFRSAccountId, IFRSNoteId, ResponsibilityCenterId, AgentAccountId, ResourceId
-- Can we add referential integrity to IFRSAccountConcept_IFRSNoteConcept_Direction?
AS
	SELECT
		E.TenantId,
		E.Id,
		D.Id As DocumentId,
		D.[DocumentDate],
		D.[SerialNumber],
		D.[VoucherNumber],
		D.[TransactionType],
		D.[Frequency],
		D.[Repetitions],
		--CASE 
		--	WHEN [Frequency] = N'OneTime' THEN [DocumentDate]
		--	WHEN [Frequency] = N'Daily' THEN DATEADD(DAY, [Repetitions], [DocumentDate])
		--	WHEN [Frequency] = N'Weekly' THEN DATEADD(WEEK, [Repetitions], [DocumentDate])
		--	WHEN [Frequency] = N'Monthly' THEN DATEADD(MONTH, [Repetitions], [DocumentDate])
		--	WHEN [Frequency] = N'Quarterly' THEN DATEADD(QUARTER, [Repetitions], [DocumentDate])
		--	WHEN [Frequency] = N'Yearly' THEN DATEADD(YEAR, [Repetitions], [DocumentDate])
		--END AS EndDate,
		D.[EndDate],
		E.[IsSystem],
		E.[Direction],
		E.[AccountId],
		A.IFRSAccountId,
		COALESCE(A.[IFRSNoteId], E.[IFRSNoteId]) AS IFRSNoteId,
		COALESCE(A.[ResponsibilityCenterId], E.[ResponsibilityCenterId]) AS [ResponsibilityCenterId],
		--RC.[OperationId],
		--RC.[ProductCategoryId],
		--RC.[GeographicRegionId],
		--RC.[CustomerSegmentId],
		--RC.[TaxSegmentId],
		COALESCE(A.[AgentAccountId], E.[AgentAccountId]) AS [AgentAccountId],
		COALESCE(A.[ResourceId], E.[ResourceId]) AS [ResourceId],
		E.[Quantity],
		E.[MoneyAmount], -- normalization is already done in the Value and stored in the entry
		E.[Mass],
		E.[Volume],
		E.[Count], -- we can normalize every measure, but just showing a proof of concept
		E.[Time],
		E.[Value],
		E.[ExpectedSettlingDate],
		E.[Reference],
		COALESCE(D.[Memo], E.[Memo]) AS [Memo],
		E.[RelatedReference],
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
		JOIN [dbo].[Documents] D ON E.DocumentId = D.Id And E.TenantId = D.TenantId
		JOIN [dbo].[Accounts] A ON E.AccountId = A.Id AND E.TenantId = A.TenantId
	WHERE
		(D.[DocumentType] = N'Transaction' AND D.[DocumentState] = N'Posted');
GO;
--CREATE UNIQUE CLUSTERED INDEX IDX_TransactionEntriesView ON [dbo].[TransactionEntriesView];