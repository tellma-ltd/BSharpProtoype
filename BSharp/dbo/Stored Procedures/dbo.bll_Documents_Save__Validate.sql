﻿CREATE PROCEDURE [dbo].[bll_Documents_Save__Validate]
	@Documents [dbo].DocumentForSaveList READONLY,
	--@WideLines [dbo]. [dbo].WideLineForSaveList READONLY,
	@Lines [dbo].LineForSaveList READONLY,
	@Entries [dbo].EntryForSaveList READONLY,
	@ValidationErrorsJson NVARCHAR(MAX) OUTPUT
AS
SET NOCOUNT ON;
	DECLARE @ValidationErrors [dbo].[ValidationErrorList];
	DECLARE @Now DATETIMEOFFSET(7) = SYSDATETIMEOFFSET();

	-- Cannot save with a future date
	INSERT INTO @ValidationErrors([Key], [ErrorName], [Argument1], [Argument2], [Argument3], [Argument4], [Argument5]) 
	SELECT '[' + CAST(FE.[Index] AS NVARCHAR(255)) + '].LinesStartDateTime' As [Key], N'Error_TheStartDateTime0IsInTheFuture' As [ErrorName],
		FE.LinesStartDateTime AS Argument1, NULL AS Argument2, NULL AS Argument3, NULL AS Argument4, NULL AS Argument5
	FROM @Documents FE
	WHERE FE.LinesStartDateTime > @Now
	AND FE.[EntityState] IN (N'Inserted', N'Updated');
		
	-- Cannot save unless in draft mode
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

	-- If Resource = functional currency, the value must match the quantity

	SELECT @ValidationErrorsJson = (SELECT * FROM @ValidationErrors	FOR JSON PATH);
