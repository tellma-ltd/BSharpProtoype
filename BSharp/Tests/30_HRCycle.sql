SELECT @DIdx = ISNULL(MAX([Index]), -1) + 1 FROM @DSave;
INSERT INTO @DSave(
[Index], [DocumentType],			[StartDateTime],[Memo],						[OperationId], [ResourceId]) VALUES (
@DIdx,	N'Purchase',	'2017.01.02',	N'Purchase of two vehicles',@ExecOffice, @ETB
);

INSERT INTO @DLTSave(
[DocumentIndex], [LineType]) VALUES
(@DIdx,			N'PaymentIssueToSupplier');

SELECT @WLIdx = ISNULL(MAX([Index]), -1) FROM @LSave
SELECT @WLIdx = @WLIdx + ISNULL(MAX([LineIndex]), -1) FROM @WLSave;
;
INSERT INTO @WLSave ([LineIndex],
[DocumentIndex], [LineType], [Custody2], [Amount1],	[Custody1])   
				--		Supplier, Amount Paid, From Cash Account
VALUES
(@WLIdx + 1, @DIdx, N'PaymentIssueToSupplier',	@Lifan,	200000,	@CBEETB);

EXEC [dbo].[api_Documents__Save]
	@Documents = @DSave, @DocumentLineTypes = @DLTSave, @WideLines = @WLSave,
	@Lines = @LSave, @Entries = @ESave,
	@ValidationErrorsJson = @ValidationErrorsJson OUTPUT,
	@DocumentsResultJson = @DResultJson OUTPUT, @LinesResultJson = @LResultJson OUTPUT, @EntriesResultJson = @EResultJson OUTPUT
DELETE FROM @DSave; DELETE FROM @DLTSave; DELETE FROM @WLSave; DELETE FROM @LSave; DELETE FROM @ESave;

IF @ValidationErrorsJson IS NOT NULL 
BEGIN
	Print 'Payment to Supplier: Save'
	GOTO Err_Label;
END;

DELETE FROM @Docs;
INSERT INTO @Docs([Id]) 
SELECT [Id] FROM dbo.Documents 
WHERE [Mode] = N'Draft';

EXEC [dbo].[api_Documents__Post]
	@Documents = @Docs,
	@ValidationErrorsJson = @ValidationErrorsJson OUTPUT,
	@ReturnEntities = 0,
 	@DocumentsResultJson = @DResultJson OUTPUT,
	@LinesResultJson = @LResultJson OUTPUT,
	@EntriesResultJson = @EResultJson OUTPUT;

IF @ValidationErrorsJson IS NOT NULL 
BEGIN
	Print 'Payment to Supplier: Post'
	GOTO Err_Label;
END