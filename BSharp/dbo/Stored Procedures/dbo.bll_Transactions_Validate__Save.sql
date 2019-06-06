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
	INSERT INTO @ValidationErrors([Key], [ErrorName], [Argument0], [Argument1])
	SELECT
		'[' + CAST(E.[DocumentIndex] AS NVARCHAR (255)) + '].TransactionEntries[' +
			CAST(E.[Index] AS NVARCHAR (255)) + ']',
		N'Error_TheAmount0DoesNotMatchTheValue1',
		E.[MoneyAmount],
		E.[Value]
	FROM @Entries E
	WHERE (E.[ResourceId] = dbo.fn_FunctionalCurrency())
	AND (E.[Value] <> E.[MoneyAmount] )
	AND E.[EntityState] IN (N'Inserted', N'Updated');

	-- (FE Check, DB constraint)  Cannot save with a future date
	INSERT INTO @ValidationErrors([Key], [ErrorName], [Argument0])
	SELECT
		'[' + CAST(FE.[Index] AS NVARCHAR (255)) + '].DocumentDate',
		N'Error_TheTransactionDate0IsInTheFuture',
		FE.[DocumentDate]
	FROM @Transactions FE
	WHERE (FE.[DocumentDate] > DATEADD(DAY, 1, @Now)) -- More accurately, FE.[DocumentDate] > CONVERT(DATE, SWITCHOFFSET(@Now, user_time_zone)) 
	AND (FE.[EntityState] IN (N'Inserted', N'Updated'));

	-- (FE Check, DB constraint)  Cannot save with a date that lies in the archived period
	INSERT INTO @ValidationErrors([Key], [ErrorName], [Argument0])
	SELECT
		'[' + CAST(FE.[Index] AS NVARCHAR (255)) + '].DocumentDate',
		N'Error_TheTransactionDate0IsBeforeArchiveDate',
		FE.[DocumentDate]
	FROM @Transactions FE
	WHERE (FE.[DocumentDate] < (SELECT TOP 1 ArchiveDate FROM dbo.Settings)) 
	AND (FE.[EntityState] IN (N'Inserted', N'Updated'));
	
	-- (FE Check, DB IU trigger) Cannot save unless in draft mode
	INSERT INTO @ValidationErrors([Key], [ErrorName], [Argument0])
	SELECT
		'[' + CAST(FE.[Index] AS NVARCHAR (255)) + '].DocumentState',
		N'Error_CannotSaveADocumentIn0State',
		BE.[DocumentState]
	FROM @Transactions FE
	JOIN [dbo].[Documents] BE ON FE.[Id] = BE.[Id]
	WHERE (BE.[DocumentState] <> N'Draft')
	AND (FE.[EntityState] IN (N'Inserted', N'Updated'));
	
	-- Note Id is missing when required
	-- TODO: Add the condition that Ifrs Note is enforced
	INSERT INTO @ValidationErrors([Key], [ErrorName])
	SELECT
		'[' + CAST(E.[DocumentIndex] AS NVARCHAR (255)) + '].TransactionEntries[' +
			CAST(E.[Index] AS NVARCHAR (255)) + '].IfrsNoteId',
		N'Error_TheIfrsNoteIsRequired'
	FROM @Entries E
	JOIN dbo.Accounts A ON E.AccountId = A.Id
	WHERE (E.[IfrsNoteId] IS NULL)
	AND (A.[IfrsAccountId] IN (SELECT [IfrsAccountConcept] FROM dbo.[IfrsAccountConceptsNoteConcepts]))
	AND (E.[EntityState] IN (N'Inserted', N'Updated'));

	-- Invalid Note Id
	INSERT INTO @ValidationErrors([Key], [ErrorName], [Argument0])
	SELECT
		'[' + CAST(E.[DocumentIndex] AS NVARCHAR (255)) + '].TransactionEntries[' +
			CAST(E.[Index] AS NVARCHAR (255)) + '].IfrsNoteId',
		N'Error_TheIfrsNote0Incorrect',
		E.[IfrsNoteId]
	FROM @Entries E
	JOIN dbo.Accounts A ON E.AccountId = A.Id
	LEFT JOIN dbo.[IfrsAccountConceptsNoteConcepts] AN ON A.[IfrsAccountId] = AN.[IfrsAccountConcept] AND E.Direction = AN.Direction AND E.IfrsNoteId = AN.[IfrsNoteConcept]
	WHERE (E.[IfrsNoteId] IS NOT NULL)
	AND (AN.[IfrsNoteConcept] IS NULL)
	AND (E.[EntityState] IN (N'Inserted', N'Updated'));

	-- Reference is required for selected account and direction, 
	INSERT INTO @ValidationErrors([Key], [ErrorName])
	SELECT
		'[' + CAST(E.[DocumentIndex] AS NVARCHAR (255)) + '].TransactionEntries[' +
			CAST(E.[Index] AS NVARCHAR (255)) + '].Reference',
		N'Error_TheReferenceIsNotSpecified'
	FROM @Entries E
	JOIN dbo.[Accounts] A On E.AccountId = A.Id
	JOIN dbo.[IfrsAccounts] IA ON A.IfrsAccountId = IA.Id
	WHERE (E.[Reference] IS NULL)
	AND (E.[Direction] = 1 AND IA.[DebitReferenceSetting] = N'Required' OR
		E.[Direction] = -1 AND IA.[CreditReferenceSetting] = N'Required')
	AND (E.[EntityState] IN (N'Inserted', N'Updated'));

	-- RelatedReference is required for selected account and direction, 
	INSERT INTO @ValidationErrors([Key], [ErrorName])
	SELECT
		'[' + CAST(E.[DocumentIndex] AS NVARCHAR (255)) + '].TransactionEntries[' +
			CAST(E.[Index] AS NVARCHAR (255)) + '].RelatedReference',
		N'Error_TheRelatedReferenceIsNotSpecified'
	FROM @Entries E
	JOIN dbo.[Accounts] A On E.AccountId = A.Id
	JOIN dbo.[IfrsAccounts] IA ON A.IfrsAccountId = IA.Id
	WHERE (E.[RelatedReference] IS NULL)
	AND (E.[Direction] = 1 AND IA.[DebitRelatedReferenceSetting] = N'Required' OR
		E.[Direction] = -1 AND IA.[CreditRelatedReferenceSetting] = N'Required')
	AND (E.[EntityState] IN (N'Inserted', N'Updated'));

	-- REACHED HERE IN CLEANING validation
	-- RelatedAgent is required for selected account and direction, 
	INSERT INTO @ValidationErrors([Key], [ErrorName], [Argument1], [Argument2], [Argument3], [Argument4], [Argument5]) 
	SELECT '[' + CAST(E.[DocumentIndex] AS NVARCHAR (255)) + '].TransactionEntries[' +
				CAST(E.[Index] AS NVARCHAR (255)) + '].RelatedAgentId' As [Key], N'Error_TheRelatedAgentIsNotSpecified' As [ErrorName],
				NULL AS Argument1, NULL AS Argument2, NULL AS Argument3, NULL AS Argument4, NULL AS Argument5
	FROM @Entries E
	JOIN dbo.[Accounts] A On E.AccountId = A.Id
	JOIN dbo.[IfrsAccounts] IA ON A.IfrsAccountId = IA.Id
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
	JOIN dbo.[IfrsAccounts] IA ON A.IfrsAccountId = IA.Id
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
	--JOIN dbo.[IfrsAccounts] IA ON A.IfrsAccountId = IA.Id
	--WHERE (E.[RelatedMoneyAmount] IS NULL)
	--AND (IA.[RelatedMoneyAmountSetting] = N'Required')
	--AND (E.[EntityState] IN (N'Inserted', N'Updated'));
	
	SELECT @ValidationErrorsJson = (SELECT * FROM @ValidationErrors	FOR JSON PATH);