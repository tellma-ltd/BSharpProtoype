INSERT INTO @DSave(
[DocumentType],		[Memo],			[StartDateTime]) VALUES
(N'ManualJournal',	N'Capital investment',	'2017.01.01');
SET @DIdx = SCOPE_IDENTITY();

INSERT INTO @LSave ([DocumentIndex], [LineType], [EntriesOperationId]) 
VALUES (@DIdx, N'ManualJournalLine', @Common); -- Issue of Equity
SET @LIdx = SCOPE_IDENTITY();

INSERT INTO @ESave
([LineIndex],EntryNumber,AccountId,		CustodyId,		ResourceId,	Direction, Amount,	[Value],	NoteId) VALUES
(@LIdx,	1,	N'ControlAccount',			@System,		@ETB,			+1,		2350000, NULL,		NULL),
(@LIdx,	2,	N'IssuedCapital',			@MohamadAkra,	@CommonStock,	-1,		1000,	2350000,	N'IssueOfEquity');

INSERT INTO @LSave ([DocumentIndex], [LineType], [EntriesOperationId]) 
VALUES (@DIdx, N'ManualJournalLine', @Common); -- Issue of Equity
SET @LIdx = SCOPE_IDENTITY();

INSERT INTO @ESave
([LineIndex],EntryNumber,AccountId,		CustodyId,		ResourceId,	Direction, Amount,	[Value],	NoteId) VALUES
(@LIdx,	1,	N'ControlAccount',			@System,		@ETB,			+1,		2350000, NULL,		NULL),
(@LIdx,	2,	N'IssuedCapital',			@AhmadAkra,		@CommonStock,	-1,		1000,	2350000,	N'IssueOfEquity');

INSERT INTO @LSave ([DocumentIndex], [LineType], [EntriesOperationId]) 
VALUES (@DIdx, N'ManualJournalLine', @Common); -- Proceeds from issuing shares
SET @LIdx = SCOPE_IDENTITY();

INSERT INTO @ESave
([LineIndex],EntryNumber,AccountId,		CustodyId,		ResourceId,	Direction, Amount,	[Value],	NoteId) VALUES
-- Capital Investment
(@LIdx,	1,	N'BalancesWithBanks',		@CBEUSD,		@USD,			+1,		200000, 4700000,	N'ProceedsFromIssuingShares'),
(@LIdx,	2,	N'ControlAccount',			@System,		@ETB,			-1,		4700000, NULL,		NULL);

--SELECT * FROM @DSave; SELECT * FROM @LSave; SELECT * FROM @ESave;
EXEC [dbo].[api_Documents__Save]
	@Documents = @DSave, @Lines = @LSave, @Entries = @ESave,
	@ValidationErrorsJson = @ValidationErrorsJson OUTPUT,
	@DocumentsResultJson = @DResultJson OUTPUT, @LinesResultJson = @LResultJson OUTPUT, @EntriesResultJson = @EResultJson OUTPUT
PRINT @DResultJson;
IF @ValidationErrorsJson IS NOT NULL 
BEGIN
	Print 'Capital Investment (M): Save'
	GOTO Err_Label;
END

DELETE FROM @Docs;
INSERT INTO @Docs([Id]) 
SELECT [Id] FROM dbo.Documents 
WHERE [DocumentType] = N'ManualJournal' 
AND [Id] IN (SELECT DocumentId FROM dbo.Lines WHERE Memo = N'Capital Investment');

EXEC [dbo].[api_Documents__Submit]
	@Documents = @Docs,
	@ValidationErrorsJson = @ValidationErrorsJson OUTPUT,
	@ReturnEntities = 0,
 	@DocumentsResultJson = @DResultJson OUTPUT,
	@LinesResultJson = @LResultJson OUTPUT,
	@EntriesResultJson = @EResultJson OUTPUT

IF @ValidationErrorsJson IS NOT NULL 
BEGIN
	Print 'Capital Investment: Submit'
	GOTO Err_Label;
END

EXEC [dbo].[api_Documents__Post]
	@Documents = @Docs,
	@ValidationErrorsJson = @ValidationErrorsJson OUTPUT,
	@ReturnEntities = 0,
 	@DocumentsResultJson = @DResultJson OUTPUT,
	@LinesResultJson = @LResultJson OUTPUT,
	@EntriesResultJson = @EResultJson OUTPUT;

IF @ValidationErrorsJson IS NOT NULL 
BEGIN
	Print 'Capital Investment: Post'
	GOTO Err_Label;
END