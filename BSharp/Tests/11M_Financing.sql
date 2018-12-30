SELECT @DIdx = ISNULL(MAX([Index]), -1) + 1 FROM @DSave;
INSERT INTO @DSave(
[Index], [DocumentType],	[StartDateTime],	[Memo],					[OperationId]) VALUES (
@DIdx, N'ManualJournal',	'2017.01.01',		N'Capital investment',	@Common
);

INSERT INTO @DLTSave(
	[DocumentIndex],	[LineType]) VALUES(
	@DIdx,				N'ManualJournalLine'
);

SELECT @LIdx = ISNULL(MAX([Index]), -1) + 1 FROM @LSave;
INSERT INTO @LSave (
	[Index],	[DocumentIndex],	[LineType]) VALUES (
	@LIdx,		@DIdx,				N'ManualJournalLine'
); -- Issue of Equity

SELECT @EIdx = ISNULL(MAX([Index]), -1) + 1 FROM @ESave;
INSERT INTO @ESave (
[Index],	[LineIndex],EntryNumber,AccountId,		CustodyId,		ResourceId,	Direction, Amount,	[Value],	NoteId) VALUES
(@EIdx,		@LIdx,		1,N'BalancesWithBanks',		@CBEUSD,		@USD,			+1,		100000, NULL,		N'ProceedsFromIssuingShares'),
(@EIdx + 1, @LIdx,		2,N'IssuedCapital',			@MohamadAkra,	@CommonStock,	-1,		1000,	2350000,	N'IssueOfEquity'),
(@EIdx + 2, @LIdx,		3,N'IssuedCapital',			@AhmadAkra,		@CommonStock,	-1,		1000,	2350000,	N'IssueOfEquity');

--SELECT * FROM @DSave; SELECT * FROM @LSave; SELECT * FROM @ESave;
EXEC [dbo].[api_Documents__Save]
	@Documents = @DSave, @DocumentLineTypes = @DLTSave, @WideLines = @WLSave,
	@Lines = @LSave, @Entries = @ESave,
	@ValidationErrorsJson = @ValidationErrorsJson OUTPUT,
	@DocumentsResultJson = @DResultJson OUTPUT, @LinesResultJson = @LResultJson OUTPUT, @EntriesResultJson = @EResultJson OUTPUT

	DELETE FROM @DSave; DELETE FROM @DLTSave; DELETE FROM @WLSave; DELETE FROM @LSave; DELETE FROM @ESave;

IF @ValidationErrorsJson IS NOT NULL 
BEGIN
	Print 'Capital Investment (M): Save'
	GOTO Err_Label;
END;

DELETE FROM @Docs;
INSERT INTO @Docs([Id]) 
SELECT [Id] FROM dbo.Documents 
WHERE [Mode] = N'Draft';

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