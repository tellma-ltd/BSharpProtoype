CREATE VIEW [dbo].[TransactionEntriesView]
-- It probably helps to materialize it, and add indices to:
-- AccountId, IFRSAccountId, IFRSNoteId, ResponsibilityCenterId, AgentAccountId, ResourceId
-- Can we add referential integrity to IFRSAccountConcept_IFRSNoteConcept_Direction?
AS
	SELECT
		D.Id As DocumentId,
		D.[DocumentDate],
		D.[SerialNumber],
		D.[TransactionType],
		D.[Frequency],
		D.[Repetitions],
		D.[EndDate],
		--DA.[AssigneeId],
		E.[Id] As EntryId,
		E.[IsSystem],
		E.[Direction],
		E.[AccountId],
		COALESCE(A.[IFRSAccountId], E.[IFRSAccountId]) AS IFRSAccountId,
		COALESCE(A.[IFRSNoteId], E.[IFRSNoteId]) AS IFRSNoteId,
		COALESCE(A.[ResponsibilityCenterId], E.[ResponsibilityCenterId]) AS [ResponsibilityCenterId],
		--RC.[OperationId],
		--RC.[ProductCategoryId],
		--RC.[GeographicRegionId],
		--RC.[CustomerSegmentId],
		--RC.[TaxSegmentId],
		COALESCE(A.[AgentAccountId], E.[AgentAccountId]) AS [AgentAccountId],
		COALESCE(A.[ResourceId], E.[ResourceId]) AS [ResourceId],
		E.ValueMeasure,
		E.[MoneyAmount], -- normalization is already done in the Value and stored in the entry
		E.[Mass],
		--E.[Mass] * MU.[BaseAmount] / MU.[UnitAmount] As NormalizedMass,
		E.[Volume],
		--E.[Volume] * MU.[BaseAmount] / MU.[UnitAmount] As NormalizedVolume,
		E.[Count], -- we can normalize every measure, but just showing a proof of concept
		E.[Time],
		E.[Value],
		E.[ExpectedSettlingDate],
		COALESCE(D.[Reference], E.[Reference]) AS [Reference],
		COALESCE(D.[Memo], E.[Memo]) AS [Memo],
		E.[RelatedReference],
		COALESCE(A.[RelatedResourceId], E.[RelatedResourceId]) AS [RelatedResourceId],
		COALESCE(A.[RelatedAgentAccountId], E.[RelatedAgentAccountId]) AS [RelatedAgentAccountId],
		E.[RelatedMoneyAmount],
		E.[CreatedAt],
		E.[CreatedById],
		E.[ModifiedAt],
		E.[ModifiedById]
	FROM 
		[dbo].[TransactionEntries] E
		JOIN [dbo].[Documents] D ON E.DocumentId = D.Id
		JOIN [dbo].[Accounts] A ON E.AccountId = A.Id
		--LEFT JOIN dbo.MeasurementUnits MU ON R.MassUnitId = MU.Id
		--LEFT JOIN dbo.MeasurementUnits MV ON R.VolumeUnitId = MV.Id
		--LEFT JOIN dbo.DocumentAssignments DA ON D.Id = DA.DocumentId
	WHERE
		(D.[DocumentType] = N'Transaction' AND D.[DocumentState] = N'Posted')