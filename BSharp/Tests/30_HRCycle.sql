SELECT @DIdx = ISNULL(MAX([Index]), -1) + 1 FROM @DSave;
INSERT INTO @DSave(
[Index], [DocumentType],	[StartDateTime],[Memo]	) VALUES (
@DIdx, N'Overtime',			'2017.01.02',	N'Production Dept Overtime'
);

INSERT INTO @DLTSave(
[DocumentIndex], [LineType], [OperationId1], [CustodyId1]) VALUES
(@DIdx,			N'Overtime',	@Expansion, @Production);

SELECT @LIdx = ISNULL(MAX([Index]), -1) FROM @LSave;
INSERT INTO @LSave ([Index],
[DocumentIndex], [LineType], [Amount1], [CustodyId2], [ResourceId2])   
							-- Overtime Hours, Employee, Overtime type
VALUES
(@LIdx + 1, @DIdx, N'Overtime', 10,		@MohamadAkra,	@HOvertime),
(@LIdx + 2, @DIdx, N'Overtime', 5,		@AhmadAkra,		@ROvertime)

EXEC [dbo].[api_Documents__Save]
	@Documents = @DSave, @DocumentLineTypes = @DLTSave,
	@Lines = @LSave, @Entries = @ESave,
	@ValidationErrorsJson = @ValidationErrorsJson OUTPUT,
	@ResultJson = @ResultJson OUTPUT;
DELETE FROM @DSave; DELETE FROM @DLTSave; DELETE FROM @LSave; DELETE FROM @ESave;

IF @ValidationErrorsJson IS NOT NULL 
BEGIN
	Print 'Overtime (W): Save'
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