﻿SELECT @DIdx = ISNULL(MAX([Index]), -1) + 1 FROM @DSave;
INSERT INTO @DSave(
[Index], [DocumentType],	[StartDateTime],[Memo],					[OperationId]) VALUES (
@DIdx, N'CapitalInvestment','2017.01.01',	N'Capital investment',	@Common
);

INSERT INTO @DLTSave(
[DocumentIndex], [LineType]) VALUES
(@DIdx,			N'IssueOfEquity');

SELECT @WLIdx = ISNULL(MAX([Index]), -1) FROM @LSave;
INSERT INTO @WLSave ([LineIndex],
[DocumentIndex], [LineType], [Custody2], [Amount2],	[Value2],	[Amount1],	[Resource1], [Custody1])   
					-- Operation, Shareholder,	NumberOfShares, CapitalInvested, PaidInAmount, PaidInCurrency, PaidInAccount
VALUES
(@WLIdx + 1, @DIdx, N'IssueOfEquity',	@MohamadAkra,	1000,	2350000,	100000,		@USD,		@CBEUSD),
(@WLIdx + 2, @DIdx,	N'IssueOfEquity',	@AhmadAkra,		1000,	2350000,	100000,		@USD,		@CBEUSD);

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