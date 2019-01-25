SELECT @DIdx = ISNULL(MAX([Index]), -1) + 1 FROM @DSave;
INSERT INTO @DSave(
[Index], [DocumentType],	[StartDateTime],[Memo],					[OperationId]) VALUES (
@DIdx, N'CapitalInvestment','2017.01.01',	N'Capital investment',	@Unspecified
);

INSERT INTO @DLTSave(
[DocumentIndex], [LineType], [CustodyId1], [ResourceId1]) VALUES
(@DIdx,			N'IssueOfEquity', @CBEUSD, @USD);

SELECT @LIdx = ISNULL(MAX([Index]), -1) FROM @LSave;
INSERT INTO @LSave ([Index],
[DocumentIndex], [LineType], [CustodyId2], [Amount2],	[Value1],	[Amount1], [Reference1])   
						-- Shareholder,	NumberOfShares, CapitalInvested, PaidInAmount
VALUES
(@LIdx + 1, @DIdx, N'IssueOfEquity',	@MohamadAkra,	1000,	2350000,	100000, N'LT101'),
(@LIdx + 2, @DIdx, N'IssueOfEquity',	@AhmadAkra,		1000,	2350000,	100000, N'LT101');

EXEC [dbo].[api_Documents__Save]
	@Documents = @DSave, @DocumentLineTypes = @DLTSave,
	@Lines = @LSave, @Entries = @ESave,
	@ValidationErrorsJson = @ValidationErrorsJson OUTPUT,
	@ResultJson = @ResultJson OUTPUT;
DELETE FROM @DSave; DELETE FROM @DLTSave; DELETE FROM @LSave; DELETE FROM @ESave;

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
 	@ResultJson = @ResultJson OUTPUT;

IF @ValidationErrorsJson IS NOT NULL 
BEGIN
	Print 'Capital Investment: Post'
	GOTO Err_Label;
END;