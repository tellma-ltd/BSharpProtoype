CREATE PROCEDURE [dbo].[bll_Documents__Fill] -- UI logic to fill missing fields
	@Documents [dbo].[DocumentList] READONLY, 
	@Lines [dbo].[LineList] READONLY, 
	@Entries [dbo].[EntryList] READONLY,
	@DocumentLineTypes [dbo].[DocumentLineTypeList] READONLY,
	@ResultJson NVARCHAR(MAX) OUTPUT
AS
DECLARE @DocumentsLocal [dbo].[DocumentList], @LinesLocal [dbo].[LineList], @DocumentLineTypesLocal [dbo].[DocumentLineTypeList],
		@EntriesLocal [dbo].[EntryList], @SmartEntriesLocal [dbo].[EntryList], @Offset INT;
BEGIN -- fill missing data from the inserted/updated
	INSERT INTO @DocumentsLocal SELECT * FROM @Documents WHERE [EntityState] IN (N'Inserted', N'Updated');
	INSERT INTO @DocumentLineTypesLocal SELECT * FROM @DocumentLineTypes WHERE [EntityState] IN (N'Inserted', N'Updated');
	INSERT INTO @LinesLocal SELECT * FROM @Lines WHERE [EntityState] IN (N'Inserted', N'Updated');
	INSERT INTO @EntriesLocal SELECT * FROM @Entries WHERE [EntityState] IN (N'Inserted', N'Updated');
END
BEGIN -- Inherit from defaults
	UPDATE D -- Set End Date Time
	SET [EndDateTime] = 
		[dbo].[fn_EndDateTime__Frequency_Duration_StartDateTime]([Frequency], [Duration], [StartDateTime])
	FROM @DocumentsLocal D

	Update E
	SET
		E.[OperationId] = CASE WHEN D.[OperationId] IS NOT NULL THEN D.[OperationId] ELSE E.[OperationId] END,
		E.[AccountId] = CASE WHEN D.[AccountId] IS NOT NULL THEN D.[AccountId] ELSE E.[AccountId] END,
		E.[CustodyId] = CASE WHEN D.[CustodyId] IS NOT NULL THEN D.[CustodyId] ELSE E.[CustodyId] END,
		E.[ResourceId] = CASE WHEN D.[ResourceId] IS NOT NULL THEN D.[ResourceId] ELSE E.[ResourceId] END,
		E.[Amount] = CASE WHEN D.[Amount] IS NOT NULL THEN D.[Amount] ELSE E.[Amount] END,
		E.[Value] = CASE WHEN D.[Value] IS NOT NULL THEN D.[Value] ELSE E.[Value] END,
		E.[NoteId] = CASE WHEN D.[NoteId] IS NOT NULL THEN D.[NoteId] ELSE E.[NoteId] END,
		E.[Reference] = CASE WHEN D.[Reference] IS NOT NULL THEN D.[Reference] ELSE E.[Reference] END,
		E.[RelatedReference] = CASE WHEN D.[RelatedReference] IS NOT NULL THEN D.[RelatedReference] ELSE E.[RelatedReference] END,
		E.[RelatedAgentId] = CASE WHEN D.[RelatedAgentId] IS NOT NULL THEN D.[RelatedAgentId] ELSE E.[RelatedAgentId] END,
		E.[RelatedResourceId] = CASE WHEN D.[RelatedResourceId] IS NOT NULL THEN D.[RelatedResourceId] ELSE E.[RelatedResourceId] END,
		E.[RelatedAmount] = CASE WHEN D.[RelatedAmount] IS NOT NULL THEN D.[RelatedAmount] ELSE E.[RelatedAmount] END
	FROM @EntriesLocal E
	JOIN @DocumentsLocal D ON E.[DocumentIndex] = D.[Index]
/*
	UPDATE DLT -- Inherit tab headers data from Documents data. Useless?!
	SET
		DLT.[BaseLineId] = CASE WHEN D.[BaseLineId] IS NOT NULL THEN D.[BaseLineId] ELSE DLT.[BaseLineId] END,
		DLT.[ScalingFactor] = CASE WHEN D.[ScalingFactor] IS NOT NULL THEN D.[ScalingFactor] ELSE DLT.[ScalingFactor] END,
		DLT.[Memo] = CASE WHEN D.[Memo] IS NOT NULL THEN D.[Memo] ELSE DLT.[Memo] END,


		DLT.[OperationId2] = CASE WHEN D.[OperationId2] IS NOT NULL THEN D.[OperationId2] ELSE DLT.[OperationId2] END,
		DLT.[CustodyId2] = CASE WHEN D.[CustodyId2] IS NOT NULL THEN D.[CustodyId2] ELSE DLT.[CustodyId2] END,
		DLT.[ResourceId2] = CASE WHEN D.[ResourceId2] IS NOT NULL THEN D.[ResourceId2] ELSE DLT.[ResourceId2] END,
		DLT.[Amount2] = CASE WHEN D.[Amount2] IS NOT NULL THEN D.[Amount2] ELSE DLT.[Amount2] END,
		DLT.[Value2] = CASE WHEN D.[Value2] IS NOT NULL THEN D.[Value2] ELSE DLT.[Value2] END,
		DLT.[NoteId2] = CASE WHEN D.[NoteId2] IS NOT NULL THEN D.[NoteId2] ELSE DLT.[NoteId2] END,
		DLT.[Reference2] = CASE WHEN D.[Reference2] IS NOT NULL THEN D.[Reference2] ELSE DLT.[Reference2] END,
		DLT.[RelatedReference2] = CASE WHEN D.[RelatedReference2] IS NOT NULL THEN D.[RelatedReference2] ELSE DLT.[RelatedReference2] END,
		DLT.[RelatedAgentId2] = CASE WHEN D.[RelatedAgentId2] IS NOT NULL THEN D.[RelatedAgentId2] ELSE DLT.[RelatedAgentId2] END,
		DLT.[RelatedResourceId2] = CASE WHEN D.[RelatedResourceId2] IS NOT NULL THEN D.[RelatedResourceId2] ELSE DLT.[RelatedResourceId2] END,
		DLT.[RelatedAmount2] = CASE WHEN D.[RelatedAmount2] IS NOT NULL THEN D.[RelatedAmount2] ELSE DLT.[RelatedAmount2] END,

		DLT.[OperationId3] = CASE WHEN D.[OperationId3] IS NOT NULL THEN D.[OperationId3] ELSE DLT.[OperationId3] END,
		DLT.[CustodyId3] = CASE WHEN D.[CustodyId3] IS NOT NULL THEN D.[CustodyId3] ELSE DLT.[CustodyId3] END,
		DLT.[ResourceId3] = CASE WHEN D.[ResourceId3] IS NOT NULL THEN D.[ResourceId3] ELSE DLT.[ResourceId3] END,
		DLT.[Amount3] = CASE WHEN D.[Amount3] IS NOT NULL THEN D.[Amount3] ELSE DLT.[Amount3] END,
		DLT.[Value3] = CASE WHEN D.[Value3] IS NOT NULL THEN D.[Value3] ELSE DLT.[Value3] END,
		DLT.[NoteId3] = CASE WHEN D.[NoteId3] IS NOT NULL THEN D.[NoteId3] ELSE DLT.[NoteId3] END,
		DLT.[Reference3] = CASE WHEN D.[Reference3] IS NOT NULL THEN D.[Reference3] ELSE DLT.[Reference3] END,
		DLT.[RelatedReference3] = CASE WHEN D.[RelatedReference3] IS NOT NULL THEN D.[RelatedReference3] ELSE DLT.[RelatedReference3] END,
		DLT.[RelatedAgentId3] = CASE WHEN D.[RelatedAgentId3] IS NOT NULL THEN D.[RelatedAgentId3] ELSE DLT.[RelatedAgentId3] END,
		DLT.[RelatedResourceId3] = CASE WHEN D.[RelatedResourceId3] IS NOT NULL THEN D.[RelatedResourceId3] ELSE DLT.[RelatedResourceId3] END,
		DLT.[RelatedAmount3] = CASE WHEN D.[RelatedAmount3] IS NOT NULL THEN D.[RelatedAmount3] ELSE DLT.[RelatedAmount3] END,

		DLT.[OperationId4] = CASE WHEN D.[OperationId4] IS NOT NULL THEN D.[OperationId4] ELSE DLT.[OperationId4] END,
		DLT.[CustodyId4] = CASE WHEN D.[CustodyId4] IS NOT NULL THEN D.[CustodyId4] ELSE DLT.[CustodyId4] END,
		DLT.[ResourceId4] = CASE WHEN D.[ResourceId4] IS NOT NULL THEN D.[ResourceId4] ELSE DLT.[ResourceId4] END,
		DLT.[Amount4] = CASE WHEN D.[Amount4] IS NOT NULL THEN D.[Amount4] ELSE DLT.[Amount4] END,
		DLT.[Value4] = CASE WHEN D.[Value4] IS NOT NULL THEN D.[Value4] ELSE DLT.[Value4] END,
		DLT.[NoteId4] = CASE WHEN D.[NoteId4] IS NOT NULL THEN D.[NoteId4] ELSE DLT.[NoteId4] END,
		DLT.[Reference4] = CASE WHEN D.[Reference4] IS NOT NULL THEN D.[Reference4] ELSE DLT.[Reference4] END,
		DLT.[RelatedReference4] = CASE WHEN D.[RelatedReference4] IS NOT NULL THEN D.[RelatedReference4] ELSE DLT.[RelatedReference4] END,
		DLT.[RelatedAgentId4] = CASE WHEN D.[RelatedAgentId4] IS NOT NULL THEN D.[RelatedAgentId4] ELSE DLT.[RelatedAgentId4] END,
		DLT.[RelatedResourceId4] = CASE WHEN D.[RelatedResourceId4] IS NOT NULL THEN D.[RelatedResourceId4] ELSE DLT.[RelatedResourceId4] END,
		DLT.[RelatedAmount4] = CASE WHEN D.[RelatedAmount4] IS NOT NULL THEN D.[RelatedAmount4] ELSE DLT.[RelatedAmount4] END
	FROM 
	@DocumentsLocal D
	JOIN @DocumentLineTypesLocal DLT ON D.[Index] = DLT.[DocumentIndex]
*/
	UPDATE L -- Inherit lines data from tab headers data. Useful..
	SET 
		L.[BaseLineId]	= CASE WHEN DLT.[BaseLineId] IS NOT NULL THEN DLT.[BaseLineId] ELSE L.[BaseLineId] END,
		L.[ScalingFactor]= CASE WHEN DLT.[ScalingFactor] IS NOT NULL THEN DLT.[ScalingFactor] ELSE L.[ScalingFactor] END,
		L.[Memo] = CASE WHEN DLT.[Memo] IS NOT NULL THEN DLT.[Memo] ELSE L.[Memo] END,

		L.[OperationId1] = CASE WHEN DLT.[OperationId1] IS NOT NULL THEN DLT.[OperationId1] ELSE L.[OperationId1] END,
		L.[AccountId1] = CASE WHEN DLT.[AccountId1] IS NOT NULL THEN DLT.[AccountId1] ELSE L.[AccountId1] END,
		L.[CustodyId1] = CASE WHEN DLT.[CustodyId1] IS NOT NULL THEN DLT.[CustodyId1] ELSE L.[CustodyId1] END,
		L.[ResourceId1] = CASE WHEN DLT.[ResourceId1] IS NOT NULL THEN DLT.[ResourceId1] ELSE L.[ResourceId1] END,
		L.[Direction1] = CASE WHEN DLT.[Direction1] IS NOT NULL THEN DLT.[Direction1] ELSE L.[Direction1] END,
		L.[Amount1] = CASE WHEN DLT.[Amount1] IS NOT NULL THEN DLT.[Amount1] ELSE L.[Amount1] END,
		L.[Value1] = CASE WHEN DLT.[Value1] IS NOT NULL THEN DLT.[Value1] ELSE L.[Value1] END,
		L.[NoteId1] = CASE WHEN DLT.[NoteId1] IS NOT NULL THEN DLT.[NoteId1] ELSE L.[NoteId1] END,
		L.[Reference1] = CASE WHEN DLT.[Reference1] IS NOT NULL THEN DLT.[Reference1] ELSE L.[Reference1] END,
		L.[RelatedReference1] = CASE WHEN DLT.[RelatedReference1] IS NOT NULL THEN DLT.[RelatedReference1] ELSE L.[RelatedReference1] END,
		L.[RelatedAgentId1] = CASE WHEN DLT.[RelatedAgentId1] IS NOT NULL THEN DLT.[RelatedAgentId1] ELSE L.[RelatedAgentId1] END,
		L.[RelatedResourceId1] = CASE WHEN DLT.[RelatedResourceId1] IS NOT NULL THEN DLT.[RelatedResourceId1] ELSE L.[RelatedResourceId1] END,
		L.[RelatedAmount1] = CASE WHEN DLT.[RelatedAmount1] IS NOT NULL THEN DLT.[RelatedAmount1] ELSE L.[RelatedAmount1] END,

		L.[OperationId2] = CASE WHEN DLT.[OperationId2] IS NOT NULL THEN DLT.[OperationId2] ELSE L.[OperationId2] END,
		L.[AccountId2] = CASE WHEN DLT.[AccountId2] IS NOT NULL THEN DLT.[AccountId2] ELSE L.[AccountId2] END,
		L.[CustodyId2] = CASE WHEN DLT.[CustodyId2] IS NOT NULL THEN DLT.[CustodyId2] ELSE L.[CustodyId2] END,
		L.[ResourceId2] = CASE WHEN DLT.[ResourceId2] IS NOT NULL THEN DLT.[ResourceId2] ELSE L.[ResourceId2] END,
		L.[Direction2] = CASE WHEN DLT.[Direction2] IS NOT NULL THEN DLT.[Direction2] ELSE L.[Direction2] END,
		L.[Amount2] = CASE WHEN DLT.[Amount2] IS NOT NULL THEN DLT.[Amount2] ELSE L.[Amount2] END,
		L.[Value2] = CASE WHEN DLT.[Value2] IS NOT NULL THEN DLT.[Value2] ELSE L.[Value2] END,
		L.[NoteId2] = CASE WHEN DLT.[NoteId2] IS NOT NULL THEN DLT.[NoteId2] ELSE L.[NoteId2] END,
		L.[Reference2] = CASE WHEN DLT.[Reference2] IS NOT NULL THEN DLT.[Reference2] ELSE L.[Reference2] END,
		L.[RelatedReference2] = CASE WHEN DLT.[RelatedReference2] IS NOT NULL THEN DLT.[RelatedReference2] ELSE L.[RelatedReference2] END,
		L.[RelatedAgentId2] = CASE WHEN DLT.[RelatedAgentId2] IS NOT NULL THEN DLT.[RelatedAgentId2] ELSE L.[RelatedAgentId2] END,
		L.[RelatedResourceId2] = CASE WHEN DLT.[RelatedResourceId2] IS NOT NULL THEN DLT.[RelatedResourceId2] ELSE L.[RelatedResourceId2] END,
		L.[RelatedAmount2] = CASE WHEN DLT.[RelatedAmount2] IS NOT NULL THEN DLT.[RelatedAmount2] ELSE L.[RelatedAmount2] END,

		L.[OperationId3] = CASE WHEN DLT.[OperationId3] IS NOT NULL THEN DLT.[OperationId3] ELSE L.[OperationId3] END,
		L.[AccountId3] = CASE WHEN DLT.[AccountId3] IS NOT NULL THEN DLT.[AccountId3] ELSE L.[AccountId3] END,
		L.[CustodyId3] = CASE WHEN DLT.[CustodyId3] IS NOT NULL THEN DLT.[CustodyId3] ELSE L.[CustodyId3] END,
		L.[ResourceId3] = CASE WHEN DLT.[ResourceId3] IS NOT NULL THEN DLT.[ResourceId3] ELSE L.[ResourceId3] END,
		L.[Direction3] = CASE WHEN DLT.[Direction3] IS NOT NULL THEN DLT.[Direction3] ELSE L.[Direction3] END,
		L.[Amount3] = CASE WHEN DLT.[Amount3] IS NOT NULL THEN DLT.[Amount3] ELSE L.[Amount3] END,
		L.[Value3] = CASE WHEN DLT.[Value3] IS NOT NULL THEN DLT.[Value3] ELSE L.[Value3] END,
		L.[NoteId3] = CASE WHEN DLT.[NoteId3] IS NOT NULL THEN DLT.[NoteId3] ELSE L.[NoteId3] END,
		L.[Reference3] = CASE WHEN DLT.[Reference3] IS NOT NULL THEN DLT.[Reference3] ELSE L.[Reference3] END,
		L.[RelatedReference3] = CASE WHEN DLT.[RelatedReference3] IS NOT NULL THEN DLT.[RelatedReference3] ELSE L.[RelatedReference3] END,
		L.[RelatedAgentId3] = CASE WHEN DLT.[RelatedAgentId3] IS NOT NULL THEN DLT.[RelatedAgentId3] ELSE L.[RelatedAgentId3] END,
		L.[RelatedResourceId3] = CASE WHEN DLT.[RelatedResourceId3] IS NOT NULL THEN DLT.[RelatedResourceId3] ELSE L.[RelatedResourceId3] END,
		L.[RelatedAmount3] = CASE WHEN DLT.[RelatedAmount3] IS NOT NULL THEN DLT.[RelatedAmount3] ELSE L.[RelatedAmount3] END,

		L.[OperationId4] = CASE WHEN DLT.[OperationId4] IS NOT NULL THEN DLT.[OperationId4] ELSE L.[OperationId4] END,
		L.[AccountId4] = CASE WHEN DLT.[AccountId4] IS NOT NULL THEN DLT.[AccountId4] ELSE L.[AccountId4] END,
		L.[CustodyId4] = CASE WHEN DLT.[CustodyId4] IS NOT NULL THEN DLT.[CustodyId4] ELSE L.[CustodyId4] END,
		L.[ResourceId4] = CASE WHEN DLT.[ResourceId4] IS NOT NULL THEN DLT.[ResourceId4] ELSE L.[ResourceId4] END,
		L.[Direction4] = CASE WHEN DLT.[Direction4] IS NOT NULL THEN DLT.[Direction4] ELSE L.[Direction4] END,
		L.[Amount4] = CASE WHEN DLT.[Amount4] IS NOT NULL THEN DLT.[Amount4] ELSE L.[Amount4] END,
		L.[Value4] = CASE WHEN DLT.[Value4] IS NOT NULL THEN DLT.[Value4] ELSE L.[Value4] END,
		L.[NoteId4] = CASE WHEN DLT.[NoteId4] IS NOT NULL THEN DLT.[NoteId4] ELSE L.[NoteId4] END,
		L.[Reference4] = CASE WHEN DLT.[Reference4] IS NOT NULL THEN DLT.[Reference4] ELSE L.[Reference4] END,
		L.[RelatedReference4] = CASE WHEN DLT.[RelatedReference4] IS NOT NULL THEN DLT.[RelatedReference4] ELSE L.[RelatedReference4] END,
		L.[RelatedAgentId4] = CASE WHEN DLT.[RelatedAgentId4] IS NOT NULL THEN DLT.[RelatedAgentId4] ELSE L.[RelatedAgentId4] END,
		L.[RelatedResourceId4] = CASE WHEN DLT.[RelatedResourceId4] IS NOT NULL THEN DLT.[RelatedResourceId4] ELSE L.[RelatedResourceId4] END,
		L.[RelatedAmount4] = CASE WHEN DLT.[RelatedAmount4] IS NOT NULL THEN DLT.[RelatedAmount4] ELSE L.[RelatedAmount4] END
	FROM @LinesLocal L
	JOIN @DocumentLineTypesLocal DLT ON L.DocumentIndex = DLT.[DocumentIndex] AND L.[LineType] = DLT.[LineType]
END
BEGIN -- Fill lines from specifications
	DECLARE @Sql NVARCHAR(4000), @LineType NVARCHAR(255);
	SELECT @LineType = MIN(LineType) FROM @DocumentLineTypes;
	WHILE @LineType IS NOT NULL
	BEGIN
		SET @SQL = N'
			UPDATE L
			SET
				L.OperationId1 = ' + ISNULL((SELECT Operation1FillSQL FROM LineTypeSpecifications WHERE LineType = @LineType), '') + N'
			FROM @LinesLocal L
			JOIN @DocumentsLocal D ON D.[Index] = L.[DocumentIndex]
			JOIN @DocumentLineTypesLocal DLT ON D.[Index] = DLT.[DocumentIndex] AND L.[LineType] = DLT.[LineType]'
		PRINT @SQL;
		SELECT @LineType = MIN(LineType) FROM @DocumentLineTypes WHERE LineType > @LineType;
	END
END
BEGIN	-- Smart Posting
	INSERT @SmartEntriesLocal([Index],	[DocumentIndex], [Id], [DocumentId], [LineType],
		[OperationId], [AccountId], [CustodyId], [ResourceId], [Direction], [Amount], [Value], [NoteId], [Reference],
		[RelatedReference], [RelatedAgentId], [RelatedResourceId], [RelatedAmount], [EntityState]
	) -- assuming less than 100M lines
	SELECT 1 + [Index],	[DocumentIndex], [Id], [DocumentId], [LineType],
		[OperationId1], [AccountId1], [CustodyId1], [ResourceId1], [Direction1], [Amount1], [Value1], [NoteId1], [Reference1], 
		[RelatedReference1], [RelatedAgentId1], [RelatedResourceId1], [RelatedAmount1], [EntityState]
	FROM @Lines WHERE [EntityState] IN (N'Inserted', N'Updated') AND [Direction1] IS NOT NULL
	UNION
	SELECT 2 + [Index],	[DocumentIndex], [Id], [DocumentId], [LineType],
		[OperationId2], [AccountId2], [CustodyId2], [ResourceId2], [Direction2], [Amount2], [Value2], [NoteId2], [Reference2], 
		[RelatedReference2], [RelatedAgentId2], [RelatedResourceId2], [RelatedAmount2], [EntityState]
	FROM @Lines WHERE [EntityState] IN (N'Inserted', N'Updated') AND [Direction2] IS NOT NULL
	UNION
	SELECT 3 + [Index],	[DocumentIndex], [Id], [DocumentId], [LineType],
		[OperationId3], [AccountId3], [CustodyId3], [ResourceId3], [Direction3], [Amount3], [Value3], [NoteId3], [Reference3], 
		[RelatedReference3], [RelatedAgentId3], [RelatedResourceId3], [RelatedAmount3], [EntityState]
	FROM @Lines WHERE [EntityState] IN (N'Inserted', N'Updated') AND [Direction3] IS NOT NULL
	UNION
	SELECT 4 + [Index],	[DocumentIndex], [Id], [DocumentId], [LineType],
		[OperationId4], [AccountId4], [CustodyId4], [ResourceId4], [Direction4], [Amount4], [Value4], [NoteId4], [Reference4], 
		[RelatedReference4], [RelatedAgentId4], [RelatedResourceId4], [RelatedAmount4], [EntityState]
	FROM @Lines WHERE [EntityState] IN (N'Inserted', N'Updated') AND [Direction4] IS NOT NULL;
	
	UPDATE @SmartEntriesLocal SET [Index] = [Index] + (SELECT ISNULL(MAX([Index]), 0) FROM @EntriesLocal);
	INSERT INTO @EntriesLocal SELECT * FROM @SmartEntriesLocal;
END
BEGIN -- Append the deleted ones
	INSERT INTO @DocumentsLocal SELECT * FROM @Documents WHERE [EntityState] = N'Deleted';
	INSERT INTO @LinesLocal SELECT * FROM @Lines WHERE [EntityState] = N'Deleted';
	INSERT INTO @EntriesLocal SELECT * FROM @Entries WHERE [EntityState] = N'Deleted';
	SELECT @ResultJson = (
		SELECT
			*,
			(SELECT * FROM @EntriesLocal E WHERE E.[DocumentIndex] = D.[Index] FOR JSON PATH) Entries,
			(SELECT * FROM @LinesLocal L WHERE L.[DocumentIndex] = D.[Index] FOR JSON PATH) Lines
		FROM @DocumentsLocal D
		FOR JSON PATH 
	);
END