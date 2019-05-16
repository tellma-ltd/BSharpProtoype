﻿CREATE PROCEDURE [dbo].[bll_Documents_Validate__Unpost]
	@Documents [dbo].[IndexedIdList] READONLY,
	@ValidationErrorsJson NVARCHAR(MAX) OUTPUT
AS
SET NOCOUNT ON;
	DECLARE @ValidationErrors [dbo].[ValidationErrorList];
	DECLARE @Now DATETIMEOFFSET(7) = SYSDATETIMEOFFSET();

	DECLARE @ArchiveDate DATETIMEOFFSET(7) = (SELECT ArchiveDate FROM dbo.Settings);

	-- Cannot unpost if the period is closed	
	INSERT INTO @ValidationErrors([Key], [ErrorName], [Argument1], [Argument2], [Argument3], [Argument4], [Argument5]) 
	SELECT
		'[' + CAST(FE.[Index] AS NVARCHAR(255)) + '].StartDateTime' As [Key], N'Error_TheDocumentDate0FallsBefore1ArchiveDate' As [ErrorName],
		BE.[DocumentDate] AS Argument1, @ArchiveDate AS Argument2, NULL AS Argument3, NULL AS Argument4, NULL AS Argument5
	FROM @Documents FE
	JOIN [dbo].[Documents] BE ON FE.[Id] = BE.[Id]
	WHERE (BE.[DocumentDate] < @ArchiveDate)

	-- Cannot unpost if not the user who posted

	-- No inactive account
	INSERT INTO @ValidationErrors([Key], [ErrorName], [Argument1], [Argument2], [Argument3], [Argument4], [Argument5]) 
	SELECT
		'[' + CAST(FE.[Index] AS NVARCHAR(255)) + '].Entries[' +
		CAST(E.[Id] AS NVARCHAR(255)) + '].AccountId' As [Key], N'Error_TheDocument0TheAccountId1IsInactive' As [ErrorName],
		D.SerialNumber AS Argument1, A.[Id] AS Argument2, NULL AS Argument3, NULL AS Argument4, NULL AS Argument5
	FROM @Documents FE
	JOIN dbo.Documents D ON FE.[Id] = D.[Id]
	JOIN dbo.[TransactionEntries] E ON D.[Id] = E.[DocumentId]
	JOIN dbo.[Accounts] A ON E.[AccountId] = A.[Id]
	WHERE (A.IsActive = 0);

	-- No inactive note
	INSERT INTO @ValidationErrors([Key], [ErrorName], [Argument1], [Argument2], [Argument3], [Argument4], [Argument5]) 
	SELECT
		'[' + CAST(FE.[Index] AS NVARCHAR(255)) + '].Entries[' +
		CAST(E.[Id] AS NVARCHAR(255)) + '].NoteId' As [Key], N'Error_TheDocument0TheNoteId1IsInactive' As [ErrorName],
		D.SerialNumber AS Argument1, N.[Name] AS Argument2, NULL AS Argument3, NULL AS Argument4, NULL AS Argument5
	FROM @Documents FE
	JOIN dbo.[Documents] D ON FE.[Id] = D.[Id]
	JOIN dbo.[TransactionEntries] E ON D.[Id] = E.[DocumentId]
	JOIN dbo.[IFRSNotes] N ON E.[IFRSNoteId] = N.Id
	WHERE (N.IsActive = 0);

	-- No inactive custody
	-- No inactive resource

	SELECT @ValidationErrorsJson = (SELECT * FROM @ValidationErrors	FOR JSON PATH);