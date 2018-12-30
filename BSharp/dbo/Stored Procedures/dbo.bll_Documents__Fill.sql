CREATE PROCEDURE [dbo].[bll_Documents__Fill] -- UI logic to fill missing fields
	@Documents [dbo].[DocumentList] READONLY, 
	@Lines [dbo].[LineList] READONLY, 
	@Entries [dbo].[EntryList] READONLY,
	@WideLines [dbo].[WideLineList] READONLY,
	@DocumentLineTypes [dbo].[DocumentLineTypeList] READONLY,
	@DocumentsResultJson NVARCHAR(MAX) OUTPUT,
	@LinesResultJson NVARCHAR(MAX) OUTPUT,
	@EntriesResultJson NVARCHAR(MAX) OUTPUT
AS
DECLARE @DocumentsLocal [dbo].[DocumentList], @LinesLocal [dbo].[LineList], @EntriesLocal [dbo].[EntryList],
		@WideLinesLocal [dbo].[WideLineList], @DocumentLineTypesLocal [dbo].[DocumentLineTypeList];

BEGIN 
	INSERT INTO @DocumentsLocal SELECT * FROM @Documents WHERE [EntityState] <> N'Deleted';
	INSERT INTO @DocumentLineTypesLocal SELECT * FROM @DocumentLineTypes WHERE [EntityState] <> N'Deleted';

	INSERT INTO @LinesLocal SELECT * FROM @Lines WHERE [EntityState] <> N'Deleted';
	INSERT INTO @LinesLocal(
		[Index], [DocumentIndex], [Id],	[DocumentId], [LineType], [BaseLineId],	[ScalingFactor], [Memo], [EntityState]
		)
	SELECT 
		[LineIndex], [DocumentIndex], [LineId],	[DocumentId], [LineType], [BaseLineId],	[ScalingFactor], [Memo], [EntityState]
	FROM @WideLines
	WHERE [EntityState] <> N'Deleted';

	INSERT INTO @EntriesLocal SELECT * FROM @Entries WHERE [EntityState] <> N'Deleted';

	INSERT @EntriesLocal([EntryNumber], [LineIndex], [LineId], [Index], 
		[Id], [OperationId], [Reference], [AccountId], [CustodyId], [ResourceId], [Direction], [Amount], [Value], [NoteId],
		[RelatedReference], [RelatedAgentId], [RelatedResourceId], [RelatedAmount], [EntityState]
	) -- assuming less than 100M lines
	SELECT 1, [LineIndex], [LineId], 10000000 + ROW_NUMBER() OVER(ORDER BY [LineIndex] ASC), 
		[EntryId1], [Operation1], [Reference1], [Account1], [Custody1], [Resource1], [Direction1], [Amount1], [Value1], [Note1],
		[RelatedReference1], [RelatedAgent1], [RelatedResource1], [RelatedAmount1], [EntityState]
	FROM @WideLines WHERE [EntityState] <> N'Deleted'
	UNION
	SELECT 2, [LineIndex], [LineId], 20000000 + ROW_NUMBER() OVER(ORDER BY [LineIndex] ASC), 
		[EntryId2], [Operation2], [Reference2], [Account2], [Custody2], [Resource2], [Direction2], [Amount2], [Value2], [Note2],
		[RelatedReference2], [RelatedAgent2], [RelatedResource2], [RelatedAmount2], [EntityState]
	FROM @WideLines WHERE [EntityState] <> N'Deleted'
	UNION
	SELECT 3, [LineIndex], [LineId], 30000000 + ROW_NUMBER() OVER(ORDER BY [LineIndex] ASC), 
		[EntryId3], [Operation3], [Reference3], [Account3], [Custody3], [Resource3], [Direction3], [Amount3], [Value3], [Note3],
		[RelatedReference3], [RelatedAgent3], [RelatedResource3], [RelatedAmount3], [EntityState]
	FROM @WideLines WHERE [EntityState] <> N'Deleted'
	AND LineType IN (
		SELECT LineType
		FROM [dbo].[LineTypeCalculationsView] 
		Group BY LineType
		Having Count(*) > = 3
		)
	--SELECT 4, [LineIndex], [LineId], ROW_NUMBER() + 4000000
	--	[EntryId4], [Operation4], [Reference4], [Account4], [Custody4], [Resource4], [Direction4], [Amount4], [Value4], [Note4],
	--	[RelatedReference4], [RelatedAgent4], [RelatedResource4], [RelatedAmount4], [EntityState]
	--FROM @WideLines WHERE [EntityState] <> N'Deleted'
	--AND LineType IN (
	--	SELECT LineType
	--	FROM [dbo].[LineTypeCalculationsView] 
	--	Group BY LineType
	--	Having Count(*) > = 4
	--	)
	;
END
BEGIN
	UPDATE D -- Set End Date Time
	SET [EndDateTime] = 
		[dbo].[fn_EndDateTime__Frequency_Duration_StartDateTime]([Frequency], [Duration], [StartDateTime])
	FROM @DocumentsLocal D

	UPDATE DLT -- Inherit tab headers data from Documents data
	SET
		DLT.[BaseLineId] = CASE WHEN D.[BaseLineId] IS NOT NULL THEN D.[BaseLineId] ELSE DLT.[BaseLineId] END,
		DLT.[ScalingFactor] = CASE WHEN D.[ScalingFactor] IS NOT NULL THEN D.[ScalingFactor] ELSE DLT.[ScalingFactor] END,
		DLT.[Memo] = CASE WHEN D.[Memo] IS NOT NULL THEN D.[Memo] ELSE DLT.[Memo] END,
		DLT.[OperationId] = CASE WHEN D.[OperationId] IS NOT NULL THEN D.[OperationId] ELSE DLT.[OperationId] END,
		DLT.[AccountId] = CASE WHEN D.[AccountId] IS NOT NULL THEN D.[AccountId] ELSE DLT.[AccountId] END,
		DLT.[CustodyId] = CASE WHEN D.[CustodyId] IS NOT NULL THEN D.[CustodyId] ELSE DLT.[CustodyId] END,
		DLT.[ResourceId] = CASE WHEN D.[ResourceId] IS NOT NULL THEN D.[ResourceId] ELSE DLT.[ResourceId] END,
		DLT.[Direction] = CASE WHEN D.[Direction] IS NOT NULL THEN D.[Direction] ELSE DLT.[Direction] END,
		DLT.[Amount] = CASE WHEN D.[Amount] IS NOT NULL THEN D.[Amount] ELSE DLT.[Amount] END,
		DLT.[Value] = CASE WHEN D.[Value] IS NOT NULL THEN D.[Value] ELSE DLT.[Value] END,
		DLT.[NoteId] = CASE WHEN D.[NoteId] IS NOT NULL THEN D.[NoteId] ELSE DLT.[NoteId] END,
		DLT.[Reference] = CASE WHEN D.[Reference] IS NOT NULL THEN D.[Reference] ELSE DLT.[Reference] END,
		DLT.[RelatedReference] = CASE WHEN D.[RelatedReference] IS NOT NULL THEN D.[RelatedReference] ELSE DLT.[RelatedReference] END,
		DLT.[RelatedAgentId] = CASE WHEN D.[RelatedAgentId] IS NOT NULL THEN D.[RelatedAgentId] ELSE DLT.[RelatedAgentId] END,
		DLT.[RelatedResourceId] = CASE WHEN D.[RelatedResourceId] IS NOT NULL THEN D.[RelatedResourceId] ELSE DLT.[RelatedResourceId] END,
		DLT.[RelatedAmount] = CASE WHEN D.[RelatedAmount] IS NOT NULL THEN D.[RelatedAmount] ELSE DLT.[RelatedAmount] END
	FROM 
	@DocumentsLocal D
	JOIN @DocumentLineTypesLocal DLT ON D.[Index] = DLT.[DocumentIndex]

	UPDATE L -- Inherit lines data from tab headers data
	SET 
		L.[BaseLineId]	= CASE WHEN DLT.[BaseLineId] IS NOT NULL THEN DLT.[BaseLineId] ELSE L.[BaseLineId] END,
		L.[ScalingFactor]= CASE WHEN DLT.[ScalingFactor] IS NOT NULL THEN DLT.[ScalingFactor] ELSE L.[ScalingFactor] END,
		L.[Memo] = CASE WHEN DLT.[Memo] IS NOT NULL THEN DLT.[Memo] ELSE L.[Memo] END,

		L.[OperationId] = CASE WHEN DLT.[OperationId] IS NOT NULL THEN DLT.[OperationId] ELSE L.[OperationId] END,
		L.[AccountId] = CASE WHEN DLT.[AccountId] IS NOT NULL THEN DLT.[AccountId] ELSE L.[AccountId] END,
		L.[CustodyId] = CASE WHEN DLT.[CustodyId] IS NOT NULL THEN DLT.[CustodyId] ELSE L.[CustodyId] END,
		L.[ResourceId] = CASE WHEN DLT.[ResourceId] IS NOT NULL THEN DLT.[ResourceId] ELSE L.[ResourceId] END,
		L.[Direction] = CASE WHEN DLT.[Direction] IS NOT NULL THEN DLT.[Direction] ELSE L.[Direction] END,
		L.[Amount] = CASE WHEN DLT.[Amount] IS NOT NULL THEN DLT.[Amount] ELSE L.[Amount] END,
		L.[Value] = CASE WHEN DLT.[Value] IS NOT NULL THEN DLT.[Value] ELSE L.[Value] END,
		L.[NoteId] = CASE WHEN DLT.[NoteId] IS NOT NULL THEN DLT.[NoteId] ELSE L.[NoteId] END,
		L.[Reference] = CASE WHEN DLT.[Reference] IS NOT NULL THEN DLT.[Reference] ELSE L.[Reference] END,
		L.[RelatedReference] = CASE WHEN DLT.[RelatedReference] IS NOT NULL THEN DLT.[RelatedReference] ELSE L.[RelatedReference] END,
		L.[RelatedAgentId] = CASE WHEN DLT.[RelatedAgentId] IS NOT NULL THEN DLT.[RelatedAgentId] ELSE L.[RelatedAgentId] END,
		L.[RelatedResourceId] = CASE WHEN DLT.[RelatedResourceId] IS NOT NULL THEN DLT.[RelatedResourceId] ELSE L.[RelatedResourceId] END,
		L.[RelatedAmount] = CASE WHEN DLT.[RelatedAmount] IS NOT NULL THEN DLT.[RelatedAmount] ELSE L.[RelatedAmount] END
	FROM @LinesLocal L
	JOIN @DocumentLineTypesLocal DLT ON L.DocumentIndex = DLT.[DocumentIndex] AND L.[LineType] = DLT.[LineType]

	UPDATE E -- Inherit entries data from tab headers data
	SET
		E.[OperationId] = CASE WHEN DLT.[OperationId] IS NOT NULL THEN DLT.[OperationId] ELSE E.[OperationId] END,
		E.[AccountId] = CASE WHEN DLT.[AccountId] IS NOT NULL THEN DLT.[AccountId] ELSE E.[AccountId] END,
		E.[CustodyId] = CASE WHEN DLT.[CustodyId] IS NOT NULL THEN DLT.[CustodyId] ELSE E.[CustodyId] END,
		E.[ResourceId] = CASE WHEN DLT.[ResourceId] IS NOT NULL THEN DLT.[ResourceId] ELSE E.[ResourceId] END,
		E.[Direction] = CASE WHEN DLT.[Direction] IS NOT NULL THEN DLT.[Direction] ELSE E.[Direction] END,
		E.[Amount] = CASE WHEN DLT.[Amount] IS NOT NULL THEN DLT.[Amount] ELSE E.[Amount] END,
		E.[Value] = CASE WHEN DLT.[Value] IS NOT NULL THEN DLT.[Value] ELSE E.[Value] END,
		E.[NoteId] = CASE WHEN DLT.[NoteId] IS NOT NULL THEN DLT.[NoteId] ELSE E.[NoteId] END,
		E.[Reference] = CASE WHEN DLT.[Reference] IS NOT NULL THEN DLT.[Reference] ELSE E.[Reference] END,
		E.[RelatedReference] = CASE WHEN DLT.[RelatedReference] IS NOT NULL THEN DLT.[RelatedReference] ELSE E.[RelatedReference] END,
		E.[RelatedAgentId] = CASE WHEN DLT.[RelatedAgentId] IS NOT NULL THEN DLT.[RelatedAgentId] ELSE E.[RelatedAgentId] END,
		E.[RelatedResourceId] = CASE WHEN DLT.[RelatedResourceId] IS NOT NULL THEN DLT.[RelatedResourceId] ELSE E.[RelatedResourceId] END,
		E.[RelatedAmount] = CASE WHEN DLT.[RelatedAmount] IS NOT NULL THEN DLT.[RelatedAmount] ELSE E.[RelatedAmount] END
	FROM @EntriesLocal E 
	JOIN @LinesLocal L ON L.[Index] = E.LineIndex
	JOIN @DocumentsLocal D ON D.[Index] = L.[DocumentIndex]
	JOIN @DocumentLineTypesLocal DLT ON D.[Index] = DLT.[DocumentIndex] AND L.[LineType] = DLT.[LineType]

	BEGIN -- Fill entries from specifications
		UPDATE E
		SET
			E.OperationId = (CASE 
								WHEN LC.[OperationCalculationBase] = N'Equal' THEN LC.[OperationExpression]
								WHEN LC.[OperationCalculationBase] = N'FromCode' THEN (SELECT MIN([Id]) FROM dbo.Operations WHERE [Code] = LC.[OperationExpression])
								ELSE E.OperationId 
							END),
			E.AccountId = (CASE 
								WHEN LC.[AccountCalculationBase] = N'Equal' THEN LC.[AccountExpression]
								ELSE E.AccountId 
							END),
			E.CustodyId = (CASE 
								WHEN LC.[CustodyCalculationBase] = N'Equal' THEN LC.[CustodyExpression]
								WHEN LC.[CustodyCalculationBase] = N'FromCode' THEN (SELECT MIN([Id]) FROM dbo.Custodies WHERE [Code] = LC.[CustodyExpression])
								ELSE E.CustodyId 
							END),
			E.ResourceId = (CASE
								WHEN LC.[ResourceCalculationBase] = N'Equal' THEN LC.[ResourceExpression]
								WHEN LC.[ResourceCalculationBase] = N'FromCode' THEN (SELECT MIN([Id]) FROM dbo.Resources WHERE [Code] = LC.[ResourceExpression])
								ELSE E.ResourceId 
							END),
			E.Direction = (CASE 
								WHEN LC.[DirectionCalculationBase] = N'Equal' THEN LC.[DirectionExpression]
								ELSE E.Direction 
							END),

			E.Amount = (CASE 
								WHEN LC.[AmountCalculationBase] = N'Equal' THEN LC.[AmountExpression]								
								WHEN LC.[AmountCalculationBase] = N'FromEntry' THEN (SELECT [Amount] FROM @EntriesLocal WHERE LineIndex = E.LineIndex AND EntryNumber = LC.[AmountExpression])
								ELSE E.Amount 
							END),
			E.NoteId = (CASE 
								WHEN LC.[NoteCalculationBase] = N'Equal' THEN LC.[NoteExpression]
								ELSE E.NoteId 
						END),
			E.Reference = (CASE 
								WHEN LC.[ReferenceCalculationBase] = N'Equal' THEN LC.[ReferenceExpression]
								ELSE E.Reference 
							END),
			E.RelatedReference = (CASE 
								WHEN LC.[RelatedReferenceCalculationBase] = N'Equal' THEN LC.[RelatedReferenceExpression]
								ELSE E.RelatedReference 
							END),
			E.RelatedAgentId = (CASE
								WHEN LC.[RelatedAgentCalculationBase] = N'Equal' THEN LC.[RelatedAgentExpression]
								WHEN LC.[RelatedAgentCalculationBase] = N'FromCode' THEN (SELECT MIN([Id]) FROM dbo.Custodies WHERE [Code] = LC.[RelatedAgentExpression])
								ELSE E.RelatedAgentId 
							END),
			E.RelatedResourceId = (CASE
								WHEN LC.[RelatedResourceCalculationBase] = N'Equal' THEN LC.[RelatedResourceExpression]
								WHEN LC.[RelatedResourceCalculationBase] = N'FromCode' THEN (SELECT MIN([Id]) FROM dbo.Resources WHERE [Code] = LC.[RelatedResourceExpression])
								ELSE E.RelatedResourceId 
							END),
			E.RelatedAmount = (CASE 
								WHEN LC.[RelatedAmountCalculationBase] = N'Equal' THEN LC.[RelatedAmountExpression]								
								ELSE E.RelatedAmount 
							END)
		FROM @EntriesLocal E 
		JOIN @LinesLocal L ON L.[Index] = E.LineIndex
		JOIN dbo.LineTypeCalculationsView LC ON L.LineType = LC.LineType AND E.EntryNumber = LC.EntryNumber
		JOIN @DocumentsLocal D ON D.[Index] = L.[DocumentIndex]
		JOIN @DocumentLineTypesLocal DLT ON D.[Index] = DLT.[DocumentIndex] AND L.[LineType] = DLT.[LineType]
	--select * from @EntriesLocalW;
	END
	--SELECT * FROM @DocumentsLocal; SELECT * FROM @LinesLocal; SELECT * FROM @EntriesLocal;

	BEGIN -- Fill entries using dynamic SQL
		DECLARE @LineType NVARCHAR(255), @EntryNumber TINYINT, @Sql NVARCHAR(MAX), @EntriesTransit dbo.EntryList;
		SELECT @LineType = Min(LineType) FROM @DocumentLineTypesLocal;
		WHILE @LineType IS NOT NULL
		BEGIN
			SELECT @EntryNumber = MIN(EntryNumber) FROM LineTypeCalculationsView WHERE LineType = @LineType;
			WHILE @EntryNumber IS NOT NULL
			BEGIN -- direction, amount, value, note, ref, relatedref, relatedagent, reosurce, amount
				SELECT @Sql = '
				DECLARE @EntriesLocal [dbo].[EntryList];
				INSERT INTO @EntriesLocal SELECT * FROM @Entries;
				UPDATE E
				SET
					E.OperationId = ' + CASE WHEN [OperationCalculationBase] = N'FromSQL' THEN OperationExpression ELSE ' E.OperationId' END + ',
					E.AccountId = ' + CASE WHEN [AccountCalculationBase] = N'FromSQL' THEN AccountExpression ELSE ' E.AccountId' END + ', 
					E.CustodyId = ' + CASE WHEN [CustodyCalculationBase] = N'FromSQL' THEN CustodyExpression ELSE ' E.CustodyId' END + ',
					E.ResourceId = ' + CASE WHEN [ResourceCalculationBase] = N'FromSQL' THEN ResourceExpression ELSE ' E.ResourceId' END + ',
					E.Amount = ' + CASE WHEN [AmountCalculationBase] = N'FromSQL' THEN AmountExpression ELSE ' E.Amount' END + ',
					E.[Value] = ' + CASE WHEN [ValueCalculationBase] = N'FromSQL' THEN ValueExpression ELSE ' E.[Value]' END + ',
					E.NoteId = ' + CASE WHEN [NoteCalculationBase] = N'FromSQL' THEN ResourceExpression ELSE ' E.NoteId' END + '
				FROM @EntriesLocal E
				JOIN @Lines L ON L.[Index] = E.LineIndex
				JOIN dbo.LineTypeCalculationsView LC ON L.LineType = N''' + @LineType + ''' AND E.EntryNumber = ' + CAST(@EntryNumber AS NVARCHAR(5))
				FROM dbo.LineTypeCalculationsView WHERE LineType = @LineType AND EntryNumber = @EntryNumber;
				SELECT @Sql = @Sql + ';
				SELECT * FROM @EntriesLocal;'
				--PRINT @Sql;
				DELETE FROM @EntriesTransit;
				INSERT INTO @EntriesTransit
				EXEC sp_executesql @Sql, N'@Lines dbo.LineList READONLY, @Entries dbo.EntryList READONLY',
					@Lines = @LinesLocal, @Entries = @EntriesLocal;

				UPDATE E
				SET
					E.OperationId = ET.OperationId,
					E.AccountId = ET.AccountId,
					E.CustodyId = ET.CustodyId,
					E.ResourceId = ET.ResourceId
				FROM @EntriesLocal E JOIN @EntriesTransit ET ON E.[Index] = ET.[Index];
				SET @EntryNumber = (SELECT MIN(EntryNumber) FROM dbo.[LineTypeCalculationsView] WHERE LineType = @LineType AND ENtryNumber > @EntryNumber);
			END
			SET @LineType = (SELECT Min(LineType) FROM @DocumentLineTypesLocal WHERE LineType > @LineType);
		END
	END

	UPDATE E 
	SET [Value] = [Amount]
	FROM @EntriesLocal E
	WHERE [ResourceId] = dbo.fn_FunctionalCurrency();

	--TODO: Use Exchange Rates to update for foreign currency

	UPDATE E -- When a line has only one null value, make it balanced
	SET E.[Value] = -SN2.Net
	FROM @EntriesLocal E
	JOIN (
		SELECT [LineIndex]
		FROM @EntriesLocal
		WHERE Value IS NULL
		GROUP BY [LineIndex]
		HAVING COUNT(*) = 1
	) SN1 ON E.[LineIndex] = SN1.[LineIndex] -- Single Null
	JOIN (
		SELECT [LineIndex], SUM([Direction] * [Value]) As Net
		FROM @EntriesLocal
		WHERE Value IS NOT NULL
		GROUP BY [LineIndex]
	) SN2 ON SN1.[LineIndex] = SN2.[LineIndex]
	WHERE E.[Value] IS NULL

	UPDATE E
	SET RelatedAgentId = CustodyId
	FROM @EntriesLocal E
	WHERE AccountId IN (N'ShorttermEmployeeBenefitsAccruals', N'CurrentPayablesToEmployees');

	INSERT INTO @DocumentsLocal SELECT * FROM @Documents WHERE [EntityState] = N'Deleted';
	INSERT INTO @LinesLocal SELECT * FROM @Lines WHERE [EntityState] = N'Deleted';
	INSERT INTO @LinesLocal(
		[Index], [DocumentIndex], [Id],	[DocumentId], [LineType], [BaseLineId],	[ScalingFactor], [Memo], [EntityState]
		)
	SELECT 
		[LineIndex], [DocumentIndex], [LineId],	[DocumentId], [LineType], [BaseLineId],	[ScalingFactor], [Memo], [EntityState]
	FROM @WideLines
	WHERE [EntityState] = N'Deleted';
	INSERT INTO @EntriesLocal SELECT * FROM @Entries WHERE [EntityState] = N'Deleted';

	SELECT @DocumentsResultJson = (SELECT * FROM @DocumentsLocal FOR JSON PATH);
	SELECT @LinesResultJson = (SELECT * FROM @LinesLocal FOR JSON PATH);
	SELECT @EntriesResultJson = (SELECT * FROM @EntriesLocal FOR JSON PATH);
	--PRINT @DocumentsResultJson;
END