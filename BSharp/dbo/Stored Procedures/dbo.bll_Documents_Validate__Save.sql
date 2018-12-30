CREATE PROCEDURE [dbo].[bll_Documents_Validate__Save]
	@Documents [dbo].[DocumentList] READONLY,
	--@WideLines [dbo]. [dbo].WideLineList READONLY,
	@Lines [dbo].[LineList] READONLY,
	@Entries [dbo].[EntryList] READONLY,
	@ValidationErrorsJson NVARCHAR(MAX) OUTPUT
AS
SET NOCOUNT ON;
	DECLARE @ValidationErrors [dbo].[ValidationErrorList];
	DECLARE @Now DATETIMEOFFSET(7) = SYSDATETIMEOFFSET();

	-- (FE Check) If Resource = functional currency, the value must match the quantity
	INSERT INTO @ValidationErrors([Key], [ErrorName], [Argument1], [Argument2], [Argument3], [Argument4], [Argument5]) 
	SELECT '[' + CAST(L.[DocumentIndex] AS NVARCHAR(255)) + '].[' + 
				CAST(L.[Index] AS NVARCHAR(255)) + '].[' +
				CAST(E.[Index] AS NVARCHAR(255)) + ']' As [Key], N'Error_TheAmount0DoesNotMatchTheValue' As [ErrorName],
				E.[Amount] AS Argument1, E.[Value] AS Argument2, NULL AS Argument3, NULL AS Argument4, NULL AS Argument5
	FROM @Entries E
	JOIN @Lines L ON E.LineIndex = L.[Index]
	WHERE E.[ResourceId] = dbo.fn_FunctionalCurrency()
	AND E.[Value] <> E.[Amount] 
	AND E.[EntityState] IN (N'Inserted', N'Updated');

	-- (FE Check, DB constraint)  Cannot save with a future date
	INSERT INTO @ValidationErrors([Key], [ErrorName], [Argument1], [Argument2], [Argument3], [Argument4], [Argument5]) 
	SELECT '[' + CAST(FE.[Index] AS NVARCHAR(255)) + '].StartDateTime' As [Key], N'Error_TheStartDateTime0IsInTheFuture' As [ErrorName],
		FE.[StartDateTime] AS Argument1, NULL AS Argument2, NULL AS Argument3, NULL AS Argument4, NULL AS Argument5
	FROM @Documents FE
	WHERE FE.[StartDateTime] > @Now
	AND FE.[EntityState] IN (N'Inserted', N'Updated');
		
	-- (FE Check, DB IU trigger) Cannot save unless in draft mode
	INSERT INTO @ValidationErrors([Key], [ErrorName], [Argument1], [Argument2], [Argument3], [Argument4], [Argument5]) 
	SELECT '[' + CAST(FE.[Index] AS NVARCHAR(255)) + '].Mode' As [Key], N'Error_CannotSaveADocumentIn0Mode' As [ErrorName],
		BE.[Mode] AS Argument1, NULL AS Argument2, NULL AS Argument3, NULL AS Argument4, NULL AS Argument5
	FROM @Documents FE
	JOIN [dbo].[Documents] BE ON FE.[Id] = BE.[Id]
	WHERE BE.Mode <> N'Draft'
	AND FE.[EntityState] IN (N'Inserted', N'Updated');
	
	-- No inactive account
	INSERT INTO @ValidationErrors([Key], [ErrorName], [Argument1], [Argument2], [Argument3], [Argument4], [Argument5]) 
	SELECT '[' + CAST(L.[DocumentIndex] AS NVARCHAR(255)) + '].[' + 
				CAST(L.[Index] AS NVARCHAR(255)) + '].[' +
				CAST(E.[Index] AS NVARCHAR(255)) + '].AccountId' As [Key], N'Error_TheAccount0IsInactive' As [ErrorName],
				BE.[Name] AS Argument1, NULL AS Argument2, NULL AS Argument3, NULL AS Argument4, NULL AS Argument5
	FROM @Entries E
	JOIN @Lines L ON E.LineIndex = L.[Index]
	JOIN [dbo].Accounts BE ON E.[NoteId] = BE.[Id]
	WHERE BE.IsActive = 0
	AND E.[EntityState] IN (N'Inserted', N'Updated');

	-- No inactive note
	INSERT INTO @ValidationErrors([Key], [ErrorName], [Argument1], [Argument2], [Argument3], [Argument4], [Argument5]) 
	SELECT '[' + CAST(L.[DocumentIndex] AS NVARCHAR(255)) + '].[' + 
				CAST(L.[Index] AS NVARCHAR(255)) + '].[' +
				CAST(E.[Index] AS NVARCHAR(255)) + '].NoteId' As [Key], N'Error_TheNote0IsInactive' As [ErrorName],
				E.[NoteId] AS Argument1, NULL AS Argument2, NULL AS Argument3, NULL AS Argument4, NULL AS Argument5
	FROM @Entries E
	JOIN @Lines L ON E.LineIndex = L.[Index]
	JOIN [dbo].Notes BE ON E.[NoteId] = BE.[Id]
	WHERE BE.IsActive = 0
	AND E.[EntityState] IN (N'Inserted', N'Updated');

	-- Note Id is missing when required
	INSERT INTO @ValidationErrors([Key], [ErrorName], [Argument1], [Argument2], [Argument3], [Argument4], [Argument5]) 
	SELECT '[' + CAST(L.[DocumentIndex] AS NVARCHAR(255)) + '].[' + 
				CAST(L.[Index] AS NVARCHAR(255)) + '].[' +
				CAST(E.[Index] AS NVARCHAR(255)) + '].NoteId' As [Key], N'Error_TheNoteIsRequired' As [ErrorName],
				NULL AS Argument1, NULL AS Argument2, NULL AS Argument3, NULL AS Argument4, NULL AS Argument5
	FROM @Entries E
	JOIN @Lines L ON E.LineIndex = L.[Index]
	WHERE E.NoteId IS NULL
	AND E.AccountId IN (SELECT AccountId FROM dbo.AccountsNotes)
	AND E.[EntityState] IN (N'Inserted', N'Updated');

	-- Invalid Note Id
	INSERT INTO @ValidationErrors([Key], [ErrorName], [Argument1], [Argument2], [Argument3], [Argument4], [Argument5]) 
	SELECT '[' + CAST(L.[DocumentIndex] AS NVARCHAR(255)) + '].[' + 
				CAST(L.[Index] AS NVARCHAR(255)) + '].[' +
				CAST(E.[Index] AS NVARCHAR(255)) + '].NoteId' As [Key], N'Error_TheNote0Incorrect' As [ErrorName],
				E.[NoteId] AS Argument1, NULL AS Argument2, NULL AS Argument3, NULL AS Argument4, NULL AS Argument5
	FROM @Entries E
	JOIN @Lines L ON E.LineIndex = L.[Index]
	LEFT JOIN dbo.AccountsNotes AN ON E.AccountId = AN.AccountId AND E.Direction = AN.Direction AND E.NoteId = AN.NoteId
	WHERE E.NoteId IS NOT NULL
	AND AN.NoteId IS NULL
	AND E.[EntityState] IN (N'Inserted', N'Updated');
 
	SELECT @ValidationErrorsJson = (SELECT * FROM @ValidationErrors	FOR JSON PATH);
