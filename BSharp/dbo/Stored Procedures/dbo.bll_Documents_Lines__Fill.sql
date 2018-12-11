CREATE PROCEDURE [dbo].[bll_Documents_Lines__Fill]
	@Documents [dbo].DocumentForSaveList READONLY, 
	@Lines [dbo].LineForSaveList READONLY, 
	@Entries [dbo].EntryForSaveList READONLY,
	@DocumentsResultJson NVARCHAR(MAX) OUTPUT,
	@LinesResultJson NVARCHAR(MAX) OUTPUT,
	@EntriesResultJson NVARCHAR(MAX) = NULL OUTPUT
AS
SET NOCOUNT ON;
DECLARE 	
	@FilledDocuments [dbo].DocumentForSaveNoIdentityList , 
	@FilledLines [dbo].LineForSaveNoIdentityList, 
	@FilledEntries [dbo].EntryForSaveNoIdentityList;

	INSERT INTO @FilledDocuments SELECT * FROM @Documents;
	INSERT INTO @FilledLines SELECT * FROM @Lines;
	INSERT INTO @FilledEntries SELECT * FROM @Entries;

	UPDATE L -- Inherit memo from header if not null
	SET L.Memo = D.LinesMemo
	FROM @FilledLines L
	JOIN @FilledDocuments D ON L.DocumentIndex = D.[Index]
	WHERE D.LinesMemo IS NOT NULL;
	
	UPDATE L -- Inherit end time from header if not null
	SET L.EndDateTime = D.LinesEndDateTime
	FROM @FilledLines L
	JOIN @FilledDocuments D ON L.DocumentIndex = D.[Index]
	WHERE D.LinesEndDateTime IS NOT NULL;

	UPDATE L -- Inherit start time from header if not null
	SET L.StartDateTime = D.LinesStartDateTime
	FROM @FilledLines L
	JOIN @FilledDocuments D ON L.DocumentIndex = D.[Index]
	WHERE D.LinesStartDateTime IS NOT NULL;

	UPDATE L -- For instant transaction types, make end time equals start time
	SET EndDateTime = StartDateTime
	FROM @FilledLines L
	JOIN @FilledDocuments D ON L.DocumentIndex = D.[Index]
	JOIN [dbo].TransactionTypes T ON D.TransactionType = T.Id
	WHERE T.IsInstant = 1
	AND EndDateTime IS NULL;

	SELECT @DocumentsResultJson = (SELECT * FROM @FilledDocuments FOR JSON PATH);
	SELECT @LinesResultJson = (SELECT * FROM @FilledLines FOR JSON PATH);
	SELECT @EntriesResultJson = (SELECT * FROM @FilledEntries FOR JSON PATH);