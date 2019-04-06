CREATE VIEW [dbo].[NormalizedVouchersView]
AS
	SELECT
		D.Id As DocumentId,
		D.[DocumentType],
		D.[Frequency],
		D.[SerialNumber],
		D.[AssigneeId],
		D.[StartDateTime],
		D.[EndDateTime],
		E.[Id] As EntryId,
		E.[LineType],
		E.[Direction],
		E.[AccountId],
		A.[IFRSAccountId],
		E.[ResponsibilityCenterId],
		RC.[OperationId],
		RC.[ProductCategoryId],
		RC.[GeographicRegionId],
		RC.[CustomerSegmentId],
		RC.[TaxSegmentId],
		E.[AgentAccountId],
		E.[ResourceId],
		E.[MoneyAmount], -- normalization is already done in the Value and stored in the entry
		E.[Mass],
		E.[Mass] * MU.[BaseAmount] / MU.[UnitAmount] As NormalizedMass,
		E.[Volume],
		E.[Volume] * MU.[BaseAmount] / MU.[UnitAmount] As NormalizedVolume,
		E.[Count], -- we can normalize every measure, but just showing a proof of concept
		E.[Time],
		E.[Value],
		E.[IFRSNoteId],
		E.[Reference],
		E.[Memo],
		E.[ExpectedSettlingDate],
		E.[RelatedResourceId],
		E.[RelatedReference],
		E.[RelatedAgentAccountId],
		E.[RelatedMoneyAmount]
	FROM 
		[dbo].[Entries] E
		JOIN [dbo].[Documents] D ON E.DocumentId = D.Id
		JOIN [dbo].[Accounts] A ON E.AccountId = A.Id
		JOIN dbo.[Resources] R ON E.ResourceId = R.Id
		LEFT JOIN dbo.[ResponsibilityCenters] RC ON E.ResponsibilityCenterId = RC.Id
		LEFT JOIN dbo.MeasurementUnits MU ON R.MassUnitId = MU.Id
		LEFT JOIN dbo.MeasurementUnits MV ON R.VolumeUnitId = MV.Id
	WHERE
		D.Mode			= N'Posted'
		AND D.[State]	= N'Voucher'
