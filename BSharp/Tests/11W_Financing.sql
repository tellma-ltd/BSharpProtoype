INSERT INTO @DSave(
[DocumentType],			[Memo],			[StartDateTime]) VALUES
(N'CapitalInvestment',	N'Capital Investment',	'2017.01.01');
SET @DIdx = SCOPE_IDENTITY();

INSERT INTO @WLSave (
[DocumentIndex], [LineType], [Operation1], [Custody2], [Amount2],	[Value2],		[Amount1],	[Resource1], [Custody1])   
					-- Operation, Shareholder,	NumberOfShares, CapitalInvested, PaidInAmount, PaidInCurrency, PaidInAccount
VALUES
(@DIdx, N'IssueOfEquity',	@Common,		@MohamadAkra,1000,		2350000,		100000,		@USD,		@CBEUSD),
(@DIdx,	N'IssueOfEquity',	@Common,		@AhmadAkra,	1000,		2350000,		100000,		@USD,		@CBEUSD);

EXEC [dbo].[api_Documents__Save]
	@Documents = @DSave, @Lines = @LSave, @Entries = @ESave, @WideLines = @WLSave,
	@ValidationErrorsJson = @ValidationErrorsJson OUTPUT,
	@DocumentsResultJson = @DResultJson OUTPUT, @LinesResultJson = @LResultJson OUTPUT, @EntriesResultJson = @EResultJson OUTPUT

IF @ValidationErrorsJson IS NOT NULL 
BEGIN
	Print 'Capital Investment (M): Save'
	GOTO Err_Label;
END