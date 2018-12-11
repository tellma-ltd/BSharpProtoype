CREATE PROCEDURE [dbo].[bll_Documents_Submit__Validate]
	@Documents [dbo].IndexedIdList READONLY,
	@ValidationErrorsJson NVARCHAR(MAX) OUTPUT
AS
SET NOCOUNT ON;
	DECLARE @ValidationErrors ValidationErrorList;
	DECLARE @Now DATETIMEOFFSET(7) = SYSDATETIMEOFFSET();

	-- Cannot submit unless in draft mode
	INSERT INTO @ValidationErrors([Key], [ErrorName], [Argument1], [Argument2], [Argument3], [Argument4], [Argument5]) 
	SELECT
		'[' + CAST(FE.[Index] AS NVARCHAR(255)) + '].Mode' As [Key], N'TheDocument{{0}}IsIn{{1}}Mode' As [ErrorName],
		BE.[SerialNumber] AS Argument1, BE.[Mode] AS Argument2, NULL AS Argument3, NULL AS Argument4, NULL AS Argument5
	FROM @Documents FE
	JOIN [dbo].[Documents] BE ON FE.[Id] = BE.[Id]
	WHERE BE.Mode <> N'Draft';

	-- Cannot submit with no lines
	INSERT INTO @ValidationErrors([Key], [ErrorName], [Argument1], [Argument2], [Argument3], [Argument4], [Argument5]) 
	SELECT '[' + CAST(FE.[Index] AS NVARCHAR(255)) + ']' As [Key], N'TheDocument{{0}}HasNoEntries' As [ErrorName],
		D.[SerialNumber] AS Argument1, NULL AS Argument2, NULL AS Argument3, NULL AS Argument4, NULL AS Argument5
	FROM @Documents FE 
	JOIN dbo.Documents D ON D.[Id] = FE.[Id]
	LEFT JOIN (
		SELECT L.[DocumentId]
		FROM dbo.Lines L
		JOIN dbo.Entries E ON L.[Id] = E.[LineId]
	) BE ON D.[Id] = BE.[DocumentId]
	WHERE BE.DocumentId IS NULL;

	-- Cannot submit a non-balanced transaction
	INSERT INTO @ValidationErrors([Key], [ErrorName], [Argument1], [Argument2], [Argument3], [Argument4], [Argument5]) 
	SELECT
		'[' + CAST(FE.[Index] AS NVARCHAR(255)) + '].Lines[' + CAST(L.[Id] AS NVARCHAR(255)) + ']' As [Key], 
		N'Document{{0}}Line{{1}}HasDebitCreditDifference{{2}}' As [ErrorName],
		D.[SerialNumber] AS Argument1, L.[Id] AS Argument2, SUM(E.[Direction] * E.[Value]) AS Argument3, NULL AS Argument4, NULL AS Argument5
	FROM @Documents FE
	JOIN dbo.Documents D ON FE.[Id] = D.[Id]
	JOIN dbo.Lines L ON D.[Id] = L.[DocumentId]
	JOIN dbo.Entries E ON L.[Id] = E.[LineId]
	GROUP BY FE.[Index], D.[SerialNumber], L.[Id]
	HAVING SUM(E.[Direction] * E.[Value]) <> 0;
	
	-- No inactive account
	INSERT INTO @ValidationErrors([Key], [ErrorName], [Argument1], [Argument2], [Argument3], [Argument4], [Argument5]) 
	SELECT
		'[' + CAST(FE.[Index] AS NVARCHAR(255)) + '].Lines[' + CAST(L.[Id] AS NVARCHAR(255)) + '].[' +
		CAST(E.[Id] AS NVARCHAR(255)) + '].AccountId' As [Key], N'TheDocument{{0}}Entry{{1}}TheAccount{{0}}IsInactive' As [ErrorName],
		D.SerialNumber AS Argument1, E.[EntryNumber] AS Argument2, A.[Name] AS Argument3, NULL AS Argument4, NULL AS Argument5
	FROM @Documents FE
	JOIN dbo.Documents D ON FE.[Id] = D.[Id]
	JOIN dbo.Lines L ON D.[Id] = L.[DocumentId]
	JOIN dbo.Entries E ON L.[Id] = E.[LineId]
	JOIN dbo.Accounts A ON E.AccountId = A.Id
	WHERE A.IsActive = 0

	-- No inactive note
	INSERT INTO @ValidationErrors([Key], [ErrorName], [Argument1], [Argument2], [Argument3], [Argument4], [Argument5]) 
	SELECT
		'[' + CAST(FE.[Index] AS NVARCHAR(255)) + '].Lines[' + CAST(L.[Id] AS NVARCHAR(255)) + '].[' +
		CAST(E.[Id] AS NVARCHAR(255)) + '].NoteId' As [Key], N'TheDocument{{0}}Entry{{1}}TheNote{{0}}IsInactive' As [ErrorName],
		D.SerialNumber AS Argument1, E.[EntryNumber] AS Argument2, N.[Name] AS Argument3, NULL AS Argument4, NULL AS Argument5
	FROM @Documents FE
	JOIN dbo.Documents D ON FE.[Id] = D.[Id]
	JOIN dbo.Lines L ON D.[Id] = L.[DocumentId]
	JOIN dbo.Entries E ON L.[Id] = E.[LineId]
	JOIN dbo.Notes N ON E.NoteId = N.Id
	WHERE N.IsActive = 0

	SELECT @ValidationErrorsJson = 
	(
		SELECT [Key], [ErrorName], [Argument1], [Argument2], [Argument3], [Argument4], [Argument5]
		FROM @ValidationErrors
		FOR JSON PATH
	);