CREATE PROCEDURE [dbo].[bll_Transactions_Validate__Save]
	@Transactions [dbo].[TransactionList] READONLY,
	@Lines [dbo].[TransactionLineList] READONLY,
	@Entries [dbo].[TransactionEntryList] READONLY,
	@ValidationErrorsJson NVARCHAR(MAX) OUTPUT
AS
SET NOCOUNT ON;
	DECLARE @ValidationErrors [dbo].[ValidationErrorList];
	DECLARE @Now DATETIMEOFFSET(7) = SYSDATETIMEOFFSET();

	-- (FE Check) If Resource = functional currency, the value must match the quantity
	INSERT INTO @ValidationErrors([Key], [ErrorName], [Argument1], [Argument2], [Argument3], [Argument4], [Argument5]) 
	SELECT '[' + CAST(E.[DocumentIndex] AS NVARCHAR (255)) + '].TransactionEntries[' +
				CAST(E.[Index] AS NVARCHAR (255)) + ']' As [Key], N'Error_TheAmount0DoesNotMatchTheValue' As [ErrorName],
				E.[MoneyAmount] AS Argument1, E.[Value] AS Argument2, NULL AS Argument3, NULL AS Argument4, NULL AS Argument5
	FROM @Entries E
	WHERE (E.[ResourceId] = dbo.fn_FunctionalCurrency())
	AND (E.[Value] <> E.[MoneyAmount] )
	AND E.[EntityState] IN (N'Inserted', N'Updated');

	-- (FE Check, DB constraint)  Cannot save with a future date
	INSERT INTO @ValidationErrors([Key], [ErrorName], [Argument1], [Argument2], [Argument3], [Argument4], [Argument5]) 
	SELECT '[' + CAST(FE.[Index] AS NVARCHAR (255)) + '].DocumentDate' As [Key], N'Error_TheTransactionDate0IsInTheFuture' As [ErrorName],
		FE.[DocumentDate] AS Argument1, NULL AS Argument2, NULL AS Argument3, NULL AS Argument4, NULL AS Argument5
	FROM @Transactions FE
	WHERE (FE.[DocumentDate] > DATEADD(DAY, 1, @Now)) -- More accurately, FE.[DocumentDate] > CONVERT(DATE, SWITCHOFFSET(@Now, user_time_zone)) 
	AND (FE.[EntityState] IN (N'Inserted', N'Updated'));

	-- (FE Check, DB constraint)  Cannot save with a date that lies in the archived period
	INSERT INTO @ValidationErrors([Key], [ErrorName], [Argument1], [Argument2], [Argument3], [Argument4], [Argument5]) 
	SELECT '[' + CAST(FE.[Index] AS NVARCHAR (255)) + '].DocumentDate' As [Key], N'Error_TheTransactionDate0IsBeforeArchiveDate' As [ErrorName],
		FE.[DocumentDate] AS Argument1, NULL AS Argument2, NULL AS Argument3, NULL AS Argument4, NULL AS Argument5
	FROM @Transactions FE
	WHERE (FE.[DocumentDate] < (SELECT TOP 1 ArchiveDate FROM dbo.Settings)) 
	AND (FE.[EntityState] IN (N'Inserted', N'Updated'));
	
	-- (FE Check, DB IU trigger) Cannot save unless in draft mode
	INSERT INTO @ValidationErrors([Key], [ErrorName], [Argument1], [Argument2], [Argument3], [Argument4], [Argument5]) 
	SELECT '[' + CAST(FE.[Index] AS NVARCHAR (255)) + '].DocumentState' As [Key], N'Error_CannotSaveADocumentIn0State' As [ErrorName],
		BE.[DocumentState] AS Argument1, NULL AS Argument2, NULL AS Argument3, NULL AS Argument4, NULL AS Argument5
	FROM @Transactions FE
	JOIN [dbo].[Documents] BE ON FE.[Id] = BE.[Id]
	WHERE (BE.[DocumentState] <> N'Draft')
	AND (FE.[EntityState] IN (N'Inserted', N'Updated'));
	
	-- No inactive account
	INSERT INTO @ValidationErrors([Key], [ErrorName], [Argument1], [Argument2], [Argument3], [Argument4], [Argument5]) 
	SELECT
		'[' + CAST(FE.[Index] AS NVARCHAR (255)) + '].TransactionEntries[' +
		CAST(E.[Id] AS NVARCHAR (255)) + '].AccountId' As [Key], N'Error_TheDocument0TheAccountId1IsInactive' As [ErrorName],
		D.SerialNumber AS Argument1, A.[Id] AS Argument2, NULL AS Argument3, NULL AS Argument4, NULL AS Argument5
	FROM @Transactions FE
	JOIN dbo.Documents D ON FE.[Id] = D.[Id]
	JOIN dbo.[TransactionEntries] E ON D.[Id] = E.[DocumentId]
	JOIN dbo.[Accounts] A ON E.[AccountId] = A.[Id]
	WHERE (A.IsActive = 0);

	-- No inactive note
	INSERT INTO @ValidationErrors([Key], [ErrorName], [Argument1], [Argument2], [Argument3], [Argument4], [Argument5]) 
	SELECT '[' + CAST(E.[DocumentIndex] AS NVARCHAR (255)) + '].TransactionEntries[' +
				CAST(E.[Index] AS NVARCHAR (255)) + '].IFRSNoteId' As [Key], N'Error_TheIFRSNote0IsInactive' As [ErrorName],
				E.[IFRSNoteId] AS Argument1, NULL AS Argument2, NULL AS Argument3, NULL AS Argument4, NULL AS Argument5
	FROM @Entries E
	JOIN [dbo].[IFRSNotes] BE ON E.[IFRSNoteId] = BE.[Id]
	WHERE (BE.IsActive = 0)
	AND (E.[EntityState] IN (N'Inserted', N'Updated'));

	-- Note Id is missing when required
	INSERT INTO @ValidationErrors([Key], [ErrorName], [Argument1], [Argument2], [Argument3], [Argument4], [Argument5]) 
	SELECT '[' + CAST(E.[DocumentIndex] AS NVARCHAR (255)) + '].TransactionEntries[' +
				CAST(E.[Index] AS NVARCHAR (255)) + '].IFRSNoteId' As [Key], N'Error_TheIFRSNoteIsRequired' As [ErrorName],
				NULL AS Argument1, NULL AS Argument2, NULL AS Argument3, NULL AS Argument4, NULL AS Argument5
	FROM @Entries E
	WHERE (E.[IFRSNoteId] IS NULL)
	AND (E.AccountId IN (SELECT [IFRSAccountConcept] FROM dbo.[IFRSAccountConceptsNoteConcepts]))
	AND (E.[EntityState] IN (N'Inserted', N'Updated'));

	-- Invalid Note Id
	INSERT INTO @ValidationErrors([Key], [ErrorName], [Argument1], [Argument2], [Argument3], [Argument4], [Argument5]) 
	SELECT '[' + CAST(E.[DocumentIndex] AS NVARCHAR (255)) + '].TransactionEntries[' +
				CAST(E.[Index] AS NVARCHAR (255)) + '].IFRSNoteId' As [Key], N'Error_TheIFRSNote0Incorrect' As [ErrorName],
				E.[IFRSNoteId] AS Argument1, NULL AS Argument2, NULL AS Argument3, NULL AS Argument4, NULL AS Argument5
	FROM @Entries E
	LEFT JOIN dbo.[IFRSAccountConceptsNoteConcepts] AN ON E.AccountId = AN.[IFRSAccountConcept] AND E.Direction = AN.Direction AND E.IFRSNoteId = AN.[IFRSNoteConcept]
	WHERE (E.[IFRSNoteId] IS NOT NULL)
	AND (AN.[IFRSNoteConcept] IS NULL)
	AND (E.[EntityState] IN (N'Inserted', N'Updated'));

	-- Reference is required for selected account and direction, 
	INSERT INTO @ValidationErrors([Key], [ErrorName], [Argument1], [Argument2], [Argument3], [Argument4], [Argument5]) 
	SELECT '[' + CAST(E.[DocumentIndex] AS NVARCHAR (255)) + '].TransactionEntries[' +
				CAST(E.[Index] AS NVARCHAR (255)) + '].Reference' As [Key], N'Error_TheReferenceIsNotSpecified' As [ErrorName],
				NULL AS Argument1, NULL AS Argument2, NULL AS Argument3, NULL AS Argument4, NULL AS Argument5
	FROM @Entries E
	JOIN dbo.[Accounts] A On E.AccountId = A.Id
	JOIN dbo.[IFRSAccounts] IA ON A.IFRSAccountId = IA.Id
	WHERE (E.[Reference] IS NULL)
	AND (E.[Direction] = 1 AND IA.[DebitReferenceSetting] = N'Required' OR
		E.[Direction] = -1 AND IA.[CreditReferenceSetting] = N'Required')
	AND (E.[EntityState] IN (N'Inserted', N'Updated'));

		-- RelatedReference is required for selected account and direction, 
	INSERT INTO @ValidationErrors([Key], [ErrorName], [Argument1], [Argument2], [Argument3], [Argument4], [Argument5]) 
	SELECT '[' + CAST(E.[DocumentIndex] AS NVARCHAR (255)) + '].TransactionEntries[' +
				CAST(E.[Index] AS NVARCHAR (255)) + '].RelatedReference' As [Key], N'Error_TheRelatedReferenceIsNotSpecified' As [ErrorName],
				NULL AS Argument1, NULL AS Argument2, NULL AS Argument3, NULL AS Argument4, NULL AS Argument5
	FROM @Entries E
	JOIN dbo.[Accounts] A On E.AccountId = A.Id
	JOIN dbo.[IFRSAccounts] IA ON A.IFRSAccountId = IA.Id
	WHERE (E.[RelatedReference] IS NULL)
	AND (E.[Direction] = 1 AND IA.[DebitRelatedReferenceSetting] = N'Required' OR
		E.[Direction] = -1 AND IA.[CreditRelatedReferenceSetting] = N'Required')
	AND (E.[EntityState] IN (N'Inserted', N'Updated'));

	-- RelatedAgent is required for selected account and direction, 
	INSERT INTO @ValidationErrors([Key], [ErrorName], [Argument1], [Argument2], [Argument3], [Argument4], [Argument5]) 
	SELECT '[' + CAST(E.[DocumentIndex] AS NVARCHAR (255)) + '].TransactionEntries[' +
				CAST(E.[Index] AS NVARCHAR (255)) + '].RelatedAgentId' As [Key], N'Error_TheRelatedAgentIsNotSpecified' As [ErrorName],
				NULL AS Argument1, NULL AS Argument2, NULL AS Argument3, NULL AS Argument4, NULL AS Argument5
	FROM @Entries E
	JOIN dbo.[Accounts] A On E.AccountId = A.Id
	JOIN dbo.[IFRSAccounts] IA ON A.IFRSAccountId = IA.Id
	WHERE (E.[RelatedAgentAccountId] IS NULL)
	AND (IA.[RelatedAgentAccountSetting] = N'Required')
	AND (E.[EntityState] IN (N'Inserted', N'Updated'));
	
	-- RelatedResource is required for selected account and direction, 
	INSERT INTO @ValidationErrors([Key], [ErrorName], [Argument1], [Argument2], [Argument3], [Argument4], [Argument5]) 
	SELECT '[' + CAST(E.[DocumentIndex] AS NVARCHAR (255)) + '].TransactionEntries[' +
				CAST(E.[Index] AS NVARCHAR (255)) + '].RelatedResourceId' As [Key], N'Error_TheRelatedResourceIsNotSpecified' As [ErrorName],
				NULL AS Argument1, NULL AS Argument2, NULL AS Argument3, NULL AS Argument4, NULL AS Argument5
	FROM @Entries E
	JOIN dbo.[Accounts] A On E.AccountId = A.Id
	JOIN dbo.[IFRSAccounts] IA ON A.IFRSAccountId = IA.Id
	WHERE (E.[RelatedResourceId] IS NULL)
	AND (IA.[RelatedResourceSetting] = N'Required')
	AND (E.[EntityState] IN (N'Inserted', N'Updated'));

	---- RelatedAmount is required for selected account and direction, 
	--INSERT INTO @ValidationErrors([Key], [ErrorName], [Argument1], [Argument2], [Argument3], [Argument4], [Argument5]) 
	--SELECT '[' + CAST(E.[DocumentIndex] AS NVARCHAR (255)) + '].TransactionEntries[' +
	--			CAST(E.[Index] AS NVARCHAR (255)) + '].RelatedAmount' As [Key], N'Error_TheRelatedAmountIsNotSpecified' As [ErrorName],
	--			NULL AS Argument1, NULL AS Argument2, NULL AS Argument3, NULL AS Argument4, NULL AS Argument5
	--FROM @Entries E
	--JOIN dbo.[Accounts] A On E.AccountId = A.Id
	--JOIN dbo.[IFRSAccounts] IA ON A.IFRSAccountId = IA.Id
	--WHERE (E.[RelatedMoneyAmount] IS NULL)
	--AND (IA.[RelatedMoneyAmountSetting] = N'Required')
	--AND (E.[EntityState] IN (N'Inserted', N'Updated'));
	
	SELECT @ValidationErrorsJson = (SELECT * FROM @ValidationErrors	FOR JSON PATH);