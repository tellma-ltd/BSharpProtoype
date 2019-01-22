SELECT @DIdx = ISNULL(MAX([Index]), -1) + 1 FROM @DSave;
INSERT INTO @DSave(
[Index], [DocumentType],	[StartDateTime],	[Memo],					[OperationId]) VALUES (
@DIdx, N'ManualJournal',	'2017.01.01',		N'Capital investment',	@Common
);

UPDATE @DSave -- Set End Date Time
SET [EndDateTime] = 
	[dbo].[fn_EndDateTime__Frequency_Duration_StartDateTime]([Frequency], [Duration], [StartDateTime])

SELECT @EIdx = ISNULL(MAX([Index]), -1) + 1 FROM @ESave;
INSERT INTO @ESave (
[Index],	[DocumentIndex], [OperationId], AccountId,		CustodyId,		ResourceId,	Direction, Amount,	[Value],	NoteId) VALUES
(@EIdx,		@DIdx,			@Common, N'BalancesWithBanks',	@CBEUSD,		@USD,			+1,		100000, 4700000,	N'ProceedsFromIssuingShares'),
(@EIdx + 1, @DIdx,			@Common, N'IssuedCapital',		@MohamadAkra,	@CommonStock,	-1,		1000,	2350000,	N'IssueOfEquity'),
(@EIdx + 2, @DIdx,			@Common, N'IssuedCapital',		@AhmadAkra,		@CommonStock,	-1,		1000,	2350000,	N'IssueOfEquity');



EXEC [dbo].[api_Documents__Save]
	@Documents = @DSave,-- @DocumentLineTypes = @DLTSave, @WideLines = @WLSave, @Lines = @LSave, 
	@Entries = @ESave,
	@ValidationErrorsJson = @ValidationErrorsJson OUTPUT,
	@DocumentsResultJson = @DResultJson OUTPUT, --@LinesResultJson = @LResultJson OUTPUT, 
	@EntriesResultJson = @EResultJson OUTPUT;

	DELETE FROM @DSave; DELETE FROM @DLTSave; DELETE FROM @WLSave; DELETE FROM @LSave; DELETE FROM @ESave;
--SELECT * FROM dbo.Documents
IF @ValidationErrorsJson IS NOT NULL 
BEGIN
	Print 'Capital Investment (M): Save'
	GOTO Err_Label;
END;

DELETE FROM @Docs;
INSERT INTO @Docs([Index], [Id]) 
SELECT ROW_NUMBER() OVER(ORDER BY [Id]), [Id] FROM dbo.Documents 
WHERE [Mode] = N'Draft';

EXEC [dbo].[api_Documents__Post]
	@Documents = @Docs,
	@ValidationErrorsJson = @ValidationErrorsJson OUTPUT,
	@ReturnEntities = 0,
 	@DocumentsResultJson = @DResultJson OUTPUT,
	--@LinesResultJson = @LResultJson OUTPUT,
	@EntriesResultJson = @EResultJson OUTPUT;

IF @ValidationErrorsJson IS NOT NULL 
BEGIN
	Print 'Capital Investment: Post'
	GOTO Err_Label;
END;