CREATE PROCEDURE [dbo].[bll_Documents__Fill] -- UI logic to fill missing fields
	@Documents [dbo].DocumentForSaveList2 READONLY, 
	@Lines [dbo].LineForSaveList2 READONLY, 
	@Entries [dbo].EntryForSaveList2 READONLY,
	@WideLines [dbo].WideLineForSaveList2 READONLY, 
	@DocumentsResultJson NVARCHAR(MAX) OUTPUT,
	@LinesResultJson NVARCHAR(MAX) OUTPUT,
	@EntriesResultJson NVARCHAR(MAX) OUTPUT
AS
BEGIN 
DECLARE @DocumentsLocal [dbo].DocumentForSaveList2, @LinesLocal [dbo].LineForSaveList2, @EntriesLocal [dbo].EntryForSaveList2,
		@EntriesLocalW [dbo].EntryForSaveList; -- to get an index

	INSERT INTO @DocumentsLocal SELECT * FROM @Documents;
	INSERT INTO @LinesLocal SELECT * FROM @Lines
	INSERT INTO @EntriesLocal SELECT * FROM @Entries;
		SELECT * FROM [dbo].[LineTypeCalculationsView] ;
	INSERT INTO @LinesLocal(
		[Index], [DocumentIndex], [Id],	[DocumentId], [LineType], [BaseLineId],	[ScalingFactor], [Memo], [EntityState]
		)
	SELECT 
		[LineIndex], [DocumentIndex], [LineId],	[DocumentId], [LineType], [BaseLineId],	[ScalingFactor], [Memo], [EntityState]
	FROM @WideLines;

	BEGIN -- Pivot Widelines
	INSERT @EntriesLocalW([EntryNumber], [LineIndex], [LineId],
		[Id], [OperationId], [Reference], [AccountId], [CustodyId], [ResourceId], [Direction], [Amount], [Value], [NoteId],
		[RelatedReference], [RelatedAgentId], [RelatedResourceId], [RelatedAmount], [EntityState]
	)
	SELECT 1, [LineIndex], [LineId],
		[EntryId1], [Operation1], [Reference1], [Account1], [Custody1], [Resource1], [Direction1], [Amount1], [Value1], [Note1],
		[RelatedReference1], [RelatedAgent1], [RelatedResource1], [RelatedAmount1], [EntityState]
	FROM @WideLines
	UNION
	SELECT 2, [LineIndex], [LineId],
		[EntryId2], [Operation2], [Reference2], [Account2], [Custody2], [Resource2], [Direction2], [Amount2], [Value2], [Note2],
		[RelatedReference2], [RelatedAgent2], [RelatedResource2], [RelatedAmount2], [EntityState]
	FROM @WideLines
	UNION
	SELECT 3, [LineIndex], [LineId],
		[EntryId3], [Operation3], [Reference3], [Account3], [Custody3], [Resource3], [Direction3], [Amount3], [Value3], [Note3],
		[RelatedReference3], [RelatedAgent3], [RelatedResource3], [RelatedAmount3], [EntityState]
	FROM @WideLines 
	WHERE LineType IN (
		SELECT LineType
		FROM [dbo].[LineTypeCalculationsView] 
		Group BY LineType
		Having Count(*) > = 3
		)
	--SELECT 4, [LineIndex], [LineId],
	--	[EntryId4], [Operation4], [Reference4], [Account4], [Custody4], [Resource4], [Direction4], [Amount4], [Value4], [Note4],
	--	[RelatedReference4], [RelatedAgent4], [RelatedResource4], [RelatedAmount4], [EntityState]
	--FROM @WideLines 
	--WHERE LineType IN (
	--	SELECT LineType
	--	FROM [dbo].[LineTypeCalculationsView] 
	--	Group BY LineType
	--	Having Count(*) > = 4
	--	)
	;
END
--select * from @EntriesLocalW;
	BEGIN -- Fill constant values
		UPDATE E
		SET 
			E.AccountId = (CASE 
								WHEN LEFT(LC.Account,3) = N'@V:' THEN SUBSTRING(LC.Account , 4, 1024)
								ELSE E.AccountId 
							END),
			E.Direction = (CASE 
								WHEN LEFT(LC.Direction,3) = N'@V:' THEN SUBSTRING(LC.Direction, 4, 1024)
								ELSE E.Direction 
							END),
			E.ResourceId = (CASE
								WHEN LC.[ResourceCalculationBase] = N'Input' THEN E.ResourceId
								WHEN LC.[ResourceCalculationBase] = N'Direct' THEN LC.[ResourceExpression]
								WHEN LC.[ResourceCalculationBase] = N'FromCode' THEN (SELECT MIN([Id]) FROM dbo.Resources WHERE [Code] = LC.[ResourceExpression])
								--WHEN LC.[ResourceCalculationBase] = N'FromDocumentHeader' THEN D.ResourceId
							END),
			E.NoteId = (CASE 
							WHEN LEFT(LC.Note, 3) = N'@V:' THEN SUBSTRING(LC.Note, 4, 1024)
						END)
		FROM @EntriesLocalW E 
		JOIN @LinesLocal L ON L.[Index] = E.LineIndex
		JOIN dbo.LineTypeCalculationsView LC ON L.LineType = LC.LineType AND E.EntryNumber = LC.EntryNumber
		JOIN @DocumentsLocal D ON D.[Index] = L.[DocumentIndex]
		--JOIN @DocumentsLineTypesLocal DLT ON D.[Index] = DLT.[DocumentIdex] AND L.[LineType] = DLT.[LineType]
	--select * from @EntriesLocalW;
 -- better use more intuitive and robust convention.
	END
	INSERT INTO @EntriesLocal SELECT * FROM @EntriesLocalW;

	--SELECT * FROM @DocumentsLocal; SELECT * FROM @LinesLocal; SELECT * FROM @EntriesLocal; SELECT * FROM @WideLines;

	UPDATE D -- If end date is null, set it to start date.
	SET [EndDateTime] = 
		[dbo].[fn_EndDateTime__Frequency_Duration_StartDateTime]([Frequency], [Duration], [StartDateTime])
	FROM @DocumentsLocal D

	UPDATE L -- Inherit memo from header if not null
	SET L.Memo = D.Memo
	FROM @LinesLocal L
	JOIN @DocumentsLocal D ON L.DocumentIndex = D.[Index]
	WHERE D.Memo IS NOT NULL;

	UPDATE E
	SET E.OperationId = L.EntriesOperationId
	FROM @EntriesLocal E
	JOIN @LinesLocal L ON E.LineIndex = L.[Index]
	WHERE L.EntriesOperationId IS NOT NULL;

	UPDATE E
	SET [Value] = [Amount]
	FROM @EntriesLocal E
	WHERE [ResourceId] = dbo.fn_FunctionalCurrency();

	UPDATE E
	SET RelatedAgentId = CustodyId
	FROM @EntriesLocal E
	WHERE AccountId IN (N'ShorttermEmployeeBenefitsAccruals', N'CurrentPayablesToEmployees');



	SELECT @DocumentsResultJson = (SELECT * FROM @DocumentsLocal FOR JSON PATH);
	SELECT @LinesResultJson = (SELECT * FROM @LinesLocal FOR JSON PATH);
	SELECT @EntriesResultJson = (SELECT * FROM @EntriesLocal FOR JSON PATH);
	--PRINT @DocumentsResultJson;
END