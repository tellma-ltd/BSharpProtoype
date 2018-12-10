CREATE PROCEDURE [dbo].[bll_Documents_Save__Validate]
	@Documents dbo.DocumentForSaveList READONLY,
	--@WideLines dbo. dbo.WideLineForSaveList READONLY,
	@Lines dbo.LineForSaveList READONLY,
	@Entries dbo.EntryForSaveList READONLY,
	@ValidationErrorsJson NVARCHAR(MAX) OUTPUT
AS
SET NOCOUNT ON;
	DECLARE @ValidationErrors ValidationErrorList;
	DECLARE @Now DATETIMEOFFSET(7) = SYSDATETIMEOFFSET();

	-- Cannot save with a future date
	INSERT INTO @ValidationErrors([Key], [ErrorName], [Argument1], [Argument2], [Argument3], [Argument4], [Argument5]) 
	SELECT '[' + CAST(FE.[Index] AS NVARCHAR(255)) + '].LinesStartDateTime' As [Key], N'TheStartDateTime{{0}}IsInTheFuture' As [ErrorName],
		FE.LinesStartDateTime AS Argument1, NULL AS Argument2, NULL AS Argument3, NULL AS Argument4, NULL AS Argument5
	FROM @Documents FE
	WHERE FE.LinesStartDateTime > @Now;
		
	-- Cannot save unless in draft mode
	INSERT INTO @ValidationErrors([Key], [ErrorName], [Argument1], [Argument2], [Argument3], [Argument4], [Argument5]) 
	SELECT '[' + CAST(FE.[Index] AS NVARCHAR(255)) + '].Mode' As [Key], N'CannotSaveADocumentIn{{0}}Mode' As [ErrorName],
		BE.[Mode] AS Argument1, NULL AS Argument2, NULL AS Argument3, NULL AS Argument4, NULL AS Argument5
	FROM @Documents FE
	JOIN dbo.Documents BE ON FE.[Id] = BE.[Id]
	WHERE BE.Mode <> N'Draft'

	-- No inactive account
	INSERT INTO @ValidationErrors([Key], [ErrorName], [Argument1], [Argument2], [Argument3], [Argument4], [Argument5]) 
	SELECT '[' + CAST(L.[DocumentIndex] AS NVARCHAR(255)) + '].[' + 
				CAST(L.[Index] AS NVARCHAR(255)) + '].[' +
				CAST(E.[Index] AS NVARCHAR(255)) + '].AccountId' As [Key], N'TheAccount{{0}}IsInactive' As [ErrorName],
				E.[AccountId] AS Argument1, NULL AS Argument2, NULL AS Argument3, NULL AS Argument4, NULL AS Argument5
	FROM @Entries E
	JOIN @Lines L ON E.LineIndex = L.[Index]
	JOIN dbo.Notes BE ON E.[NoteId] = BE.[Id]
	WHERE BE.IsActive = 0;

	-- No inactive note
	INSERT INTO @ValidationErrors([Key], [ErrorName], [Argument1], [Argument2], [Argument3], [Argument4], [Argument5]) 
	SELECT '[' + CAST(L.[DocumentIndex] AS NVARCHAR(255)) + '].[' + 
				CAST(L.[Index] AS NVARCHAR(255)) + '].[' +
				CAST(E.[Index] AS NVARCHAR(255)) + '].NoteId' As [Key], N'TheNote{{0}}IsInactive' As [ErrorName],
				E.[NoteId] AS Argument1, NULL AS Argument2, NULL AS Argument3, NULL AS Argument4, NULL AS Argument5
	FROM @Entries E
	JOIN @Lines L ON E.LineIndex = L.[Index]
	JOIN dbo.Notes BE ON E.[NoteId] = BE.[Id]
	WHERE BE.IsActive = 0;

	SELECT @ValidationErrorsJson = 
	(
		SELECT [Key], [ErrorName], [Argument1], [Argument2], [Argument3], [Argument4], [Argument5]
		FROM @ValidationErrors
		FOR JSON PATH
	);