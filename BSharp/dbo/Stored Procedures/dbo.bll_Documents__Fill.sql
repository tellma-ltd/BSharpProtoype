﻿CREATE PROCEDURE [dbo].[bll_Documents__Fill] -- UI logic to fill missing fields
	@Documents [dbo].[DocumentList] READONLY, 
	@Lines [dbo].[LineList] READONLY, 
	@Entries [dbo].[EntryList] READONLY,
	@DocumentLineTypes [dbo].[DocumentLineTypeList] READONLY,
	@ResultJson NVARCHAR(MAX) OUTPUT
AS
DECLARE @DEBUG int = 0;
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
	JOIN @DocumentsLocal D ON E.[DocumentIndex] = D.[Index];

	UPDATE L -- Inherit lines data from tab headers data. Useful..
	SET 
		L.[BaseLineId]	= CASE WHEN DLT.[BaseLineId] IS NOT NULL THEN DLT.[BaseLineId] ELSE L.[BaseLineId] END,
		L.[ScalingFactor]= CASE WHEN DLT.[ScalingFactor] IS NOT NULL THEN DLT.[ScalingFactor] ELSE L.[ScalingFactor] END,
		L.[Memo] = CASE WHEN DLT.[Memo] IS NOT NULL THEN DLT.[Memo] ELSE L.[Memo] END,

		L.[OperationId1] = COALESCE(D.[OperationId], DLT.[OperationId1], L.[OperationId1]),
		L.[AccountId1] = COALESCE(D.[AccountId], DLT.[AccountId1], L.[AccountId1]),
		L.[CustodyId1] = COALESCE(D.[CustodyId], DLT.[CustodyId1], L.[CustodyId1]),
		L.[ResourceId1] = COALESCE(D.[ResourceId], DLT.[ResourceId1], L.[ResourceId1]),
		L.[Amount1] = COALESCE(D.[Amount], DLT.[Amount1], L.[Amount1]),
		L.[Value1] = COALESCE(D.[Value], DLT.[Value1], L.[Value1]),
		L.[NoteId1] = COALESCE(D.[NoteId], DLT.[NoteId1], L.[NoteId1]),
		L.[Reference1] = COALESCE(D.[Reference], DLT.[Reference1], L.[Reference1]),
		L.[RelatedReference1] = COALESCE(D.[RelatedReference], DLT.[RelatedReference1], L.[RelatedReference1]),
		L.[RelatedAgentId1] = COALESCE(D.[RelatedAgentId], DLT.[RelatedAgentId1], L.[RelatedAgentId1]),
		L.[RelatedResourceId1] = COALESCE(D.[RelatedResourceId], DLT.[RelatedResourceId1], L.[RelatedResourceId1]),
		L.[RelatedAmount1] = COALESCE(D.[RelatedAmount], DLT.[RelatedAmount1], L.[RelatedAmount1]),

		L.[OperationId2] = COALESCE(D.[OperationId], DLT.[OperationId2], L.[OperationId2]),
		L.[AccountId2] = COALESCE(D.[AccountId], DLT.[AccountId2], L.[AccountId2]),
		L.[CustodyId2] = COALESCE(D.[CustodyId], DLT.[CustodyId2], L.[CustodyId2]),
		L.[ResourceId2] = COALESCE(D.[ResourceId], DLT.[ResourceId2], L.[ResourceId2]),
		L.[Amount2] = COALESCE(D.[Amount], DLT.[Amount2], L.[Amount2]),
		L.[Value2] = COALESCE(D.[Value], DLT.[Value2], L.[Value2]),
		L.[NoteId2] = COALESCE(D.[NoteId], DLT.[NoteId2], L.[NoteId2]),
		L.[Reference2] = COALESCE(D.[Reference], DLT.[Reference2], L.[Reference2]),
		L.[RelatedReference2] = COALESCE(D.[RelatedReference], DLT.[RelatedReference2], L.[RelatedReference2]),
		L.[RelatedAgentId2] = COALESCE(D.[RelatedAgentId], DLT.[RelatedAgentId2], L.[RelatedAgentId2]),
		L.[RelatedResourceId2] = COALESCE(D.[RelatedResourceId], DLT.[RelatedResourceId2], L.[RelatedResourceId2]),
		L.[RelatedAmount2] = COALESCE(D.[RelatedAmount], DLT.[RelatedAmount2], L.[RelatedAmount2]),

		L.[OperationId3] = COALESCE(D.[OperationId], DLT.[OperationId3], L.[OperationId3]),
		L.[AccountId3] = COALESCE(D.[AccountId], DLT.[AccountId3], L.[AccountId3]),
		L.[CustodyId3] = COALESCE(D.[CustodyId], DLT.[CustodyId3], L.[CustodyId3]),
		L.[ResourceId3] = COALESCE(D.[ResourceId], DLT.[ResourceId3], L.[ResourceId3]),
		L.[Amount3] = COALESCE(D.[Amount], DLT.[Amount3], L.[Amount3]),
		L.[Value3] = COALESCE(D.[Value], DLT.[Value3], L.[Value3]),
		L.[NoteId3] = COALESCE(D.[NoteId], DLT.[NoteId3], L.[NoteId3]),
		L.[Reference3] = COALESCE(D.[Reference], DLT.[Reference3], L.[Reference3]),
		L.[RelatedReference3] = COALESCE(D.[RelatedReference], DLT.[RelatedReference3], L.[RelatedReference3]),
		L.[RelatedAgentId3] = COALESCE(D.[RelatedAgentId], DLT.[RelatedAgentId3], L.[RelatedAgentId3]),
		L.[RelatedResourceId3] = COALESCE(D.[RelatedResourceId], DLT.[RelatedResourceId3], L.[RelatedResourceId3]),
		L.[RelatedAmount3] = COALESCE(D.[RelatedAmount], DLT.[RelatedAmount3], L.[RelatedAmount3]),
		
		L.[OperationId4] = COALESCE(D.[OperationId], DLT.[OperationId4], L.[OperationId4]),
		L.[AccountId4] = COALESCE(D.[AccountId], DLT.[AccountId4], L.[AccountId4]),
		L.[CustodyId4] = COALESCE(D.[CustodyId], DLT.[CustodyId4], L.[CustodyId4]),
		L.[ResourceId4] = COALESCE(D.[ResourceId], DLT.[ResourceId4], L.[ResourceId4]),
		L.[Amount4] = COALESCE(D.[Amount], DLT.[Amount4], L.[Amount4]),
		L.[Value4] = COALESCE(D.[Value], DLT.[Value4], L.[Value4]),
		L.[NoteId4] = COALESCE(D.[NoteId], DLT.[NoteId4], L.[NoteId4]),
		L.[Reference4] = COALESCE(D.[Reference], DLT.[Reference4], L.[Reference4]),
		L.[RelatedReference4] = COALESCE(D.[RelatedReference], DLT.[RelatedReference4], L.[RelatedReference4]),
		L.[RelatedAgentId4] = COALESCE(D.[RelatedAgentId], DLT.[RelatedAgentId4], L.[RelatedAgentId4]),
		L.[RelatedResourceId4] = COALESCE(D.[RelatedResourceId], DLT.[RelatedResourceId4], L.[RelatedResourceId4]),
		L.[RelatedAmount4] = COALESCE(D.[RelatedAmount], DLT.[RelatedAmount4], L.[RelatedAmount4])
	FROM @LinesLocal L
	JOIN @DocumentLineTypesLocal DLT ON L.DocumentIndex = DLT.[DocumentIndex] AND L.[LineType] = DLT.[LineType]
	JOIN @DocumentsLocal D ON D.[Index] = L.[DocumentIndex]
END

BEGIN -- Fill lines from specifications
	DECLARE @Sql NVARCHAR(4000), @ParmDefinition NVARCHAR(255), @AppendSQL NVARCHAR(4000), @LineType NVARCHAR(255);
	SELECT @LineType = MIN(LineType) FROM @DocumentLineTypes;
	WHILE @LineType IS NOT NULL
	BEGIN
		IF @DEBUG IN (0, 1)
		BEGIN
			SET @SQL = N'
				DECLARE @LinesLocal [dbo].[LineList];
				INSERT INTO @LinesLocal SELECT * FROM @Lines;
				UPDATE L
				SET 
				' +	ISNULL('L.OperationId1 = ' + (SELECT Operation1FillSQL FROM LineTypeSpecifications WHERE LineType = @LineType) + ',
				', '') + ISNULL('L.AccountId1 = ' +	(SELECT Account1FillSQL FROM LineTypeSpecifications WHERE LineType = @LineType) + ',
				', '') + ISNULL('L.CustodyId1 = ' +	(SELECT Custody1FillSQL FROM LineTypeSpecifications WHERE LineType = @LineType) + ',
				', '') + ISNULL('L.ResourceId1 = ' +	(SELECT Resource1FillSQL FROM LineTypeSpecifications WHERE LineType = @LineType) + ',
				', '') + ISNULL('L.Direction1 = ' +	(SELECT Direction1FillSQL FROM LineTypeSpecifications WHERE LineType = @LineType) + ',
				', '') + ISNULL('L.Amount1 = ' +	(SELECT Amount1FillSQL FROM LineTypeSpecifications WHERE LineType = @LineType) + ',
				', '') + ISNULL('L.Value1 = ' +	(SELECT Value1FillSQL FROM LineTypeSpecifications WHERE LineType = @LineType) + ',
				', '') + ISNULL('L.NoteId1 = ' +	(SELECT Note1FillSQL FROM LineTypeSpecifications WHERE LineType = @LineType) + ',
				', '') + ISNULL('L.Reference1 = ' +	(SELECT Reference1FillSQL FROM LineTypeSpecifications WHERE LineType = @LineType) + ',
				', '') + ISNULL('L.OperationId2 = ' +	(SELECT Operation2FillSQL FROM LineTypeSpecifications WHERE LineType = @LineType) + ',
				', '') + ISNULL('L.AccountId2 = ' +	(SELECT Account2FillSQL FROM LineTypeSpecifications WHERE LineType = @LineType) + ',
				', '') + ISNULL('L.CustodyId2 = ' +	(SELECT Custody2FillSQL FROM LineTypeSpecifications WHERE LineType = @LineType) + ',
				', '') + ISNULL('L.ResourceId2 = ' +	(SELECT Resource2FillSQL FROM LineTypeSpecifications WHERE LineType = @LineType) + ',
				', '') + ISNULL('L.Direction2 = ' +	(SELECT Direction2FillSQL FROM LineTypeSpecifications WHERE LineType = @LineType) + ',
				', '') + ISNULL('L.Amount2 = ' +	(SELECT Amount2FillSQL FROM LineTypeSpecifications WHERE LineType = @LineType) + ',
				', '') + ISNULL('L.Value2 = ' +	(SELECT Value2FillSQL FROM LineTypeSpecifications WHERE LineType = @LineType) + ',
				', '') + ISNULL('L.NoteId2 = ' +	(SELECT Note2FillSQL FROM LineTypeSpecifications WHERE LineType = @LineType) + ',
				', '') + ISNULL('L.Reference2 = ' +	(SELECT Reference2FillSQL FROM LineTypeSpecifications WHERE LineType = @LineType) + ',
				', '') + 'L.[Index] = L.[Index]
				FROM @LinesLocal L
				JOIN @DocumentsLocal D ON D.[Index] = L.[DocumentIndex]
				JOIN @DocumentLineTypesLocal DLT ON D.[Index] = DLT.[DocumentIndex] AND L.[LineType] = DLT.[LineType];
				SELECT * FROM @LinesLocal
			';
			SELECT @AppendSQL = AppendSQL FROM dbo.LineTypeSpecifications WHERE LineType = @LineType;

			IF @DEBUG = 0
			BEGIN
				DECLARE @LTemp LineList;
				SET @ParmDefinition = N'@DocumentsLocal dbo.DocumentList READONLY, @DocumentLineTypesLocal dbo.DocumentLineTypeList READONLY, @Lines dbo.LineList READONLY';		
				INSERT INTO @LTemp
					EXEC sp_executesql @SQL, @ParmDefinition,
						@DocumentsLocal = @DocumentsLocal, @DocumentLineTypesLocal = @DocumentLineTypesLocal, @Lines = @LinesLocal;
				DELETE FROM @LinesLocal WHERE [LineType] = @LineType;
				INSERT INTO @LinesLocal SELECT * FROM @LTemp;
				EXEC sp_executesql @AppendSQL, @ParmDefinition,
					@DocumentsLocal = @DocumentsLocal, @DocumentLineTypesLocal = @DocumentLineTypesLocal, @Lines = @LinesLocal;
			END
			ELSE BEGIN-- @DEBUG = 1
				PRINT @SQL;
				Print @AppendSQL;
			END
		END
		ELSE BEGIN -- DEBUG = 2, use
			IF @LineType = N'IssueOfEquity'
			BEGIN
				UPDATE L
				SET 
				L.AccountId1 = N'BalancesWithBanks',
				L.Direction1 = +1,
				L.NoteId1 = N'ProceedsFromIssuingShares',
				L.OperationId2 = L.[OperationId1],
				L.AccountId2 = N'IssuedCapital',
				L.ResourceId2 = (SELECT Id FROM dbo.Resources WHERE [SystemCode] = N'CMNSTCK'),
				L.Direction2 = -1,
				L.Value2 = L.[Value1],
				L.NoteId2 = N'IssueOfEquity',
				L.[Index] = L.[Index]
				FROM @LinesLocal L
				JOIN @DocumentsLocal D ON D.[Index] = L.[DocumentIndex]
				JOIN @DocumentLineTypesLocal DLT ON D.[Index] = DLT.[DocumentIndex] AND L.[LineType] = DLT.[LineType];			END
			IF @LineType = N'Overtime'
			BEGIN
				UPDATE L
				SET 
				L.AccountId1 = N'UnassignedLabor',
				L.ResourceId1 = (SELECT [Id] FROM dbo.Resources WHERE [SystemCode] = N'LaborHourly'),
				L.Direction1 = +1,
				L.Value1 = (
					SELECT L.[Amount1] * [UnitCost] FROM dbo.CustodiesResources
					WHERE CustodyId = L.[RelatedAgentId1] AND ResourceId = L.[RelatedResourceId1] And RelationType = N'Employee'
				),
				L.Reference1 = Year(D.[StartDateTime]) * 100 + Month(D.[StartDateTime]),
				L.[Index] = L.[Index]
				FROM @LinesLocal L
				JOIN @DocumentsLocal D ON D.[Index] = L.[DocumentIndex]
				JOIN @DocumentLineTypesLocal DLT ON D.[Index] = DLT.[DocumentIndex] AND L.[LineType] = DLT.[LineType];

				INSERT INTO @SmartEntriesLocal([Index], [DocumentIndex], [LineType], OperationId, AccountId, CustodyId, ResourceId, Direction, Amount, Value, Reference)
				SELECT [Index]+1, [DocumentIndex],  [LineType], OperationId, N'ShorttermEmployeeBenefitsAccruals', RelatedAgentId, RelatedResourceId, -1, Amount, Value, Reference
				FROM @SmartEntriesLocal
				WHERE LineType = N'Overtime'
			END
		END
		SELECT @LineType = MIN(LineType) FROM @DocumentLineTypes WHERE LineType > @LineType;
	END
END
BEGIN	-- Smart Posting
	INSERT @SmartEntriesLocal([Index],	[DocumentIndex], [Id], [DocumentId], [LineType],
		[OperationId], [AccountId], [CustodyId], [ResourceId], [Direction], [Amount], [Value], [NoteId], [Reference],
		[RelatedReference], [RelatedAgentId], [RelatedResourceId], [RelatedAmount], [EntityState]
	) -- assuming a line will not capture more than 100 entries (currently it only captures 4)
	SELECT 100 + [Index],	[DocumentIndex], [Id], [DocumentId], [LineType],
		[OperationId1], [AccountId1], [CustodyId1], [ResourceId1], [Direction1], [Amount1], [Value1], [NoteId1], [Reference1], 
		[RelatedReference1], [RelatedAgentId1], [RelatedResourceId1], [RelatedAmount1], [EntityState]
	FROM @LinesLocal WHERE [EntityState] IN (N'Inserted', N'Updated') AND [Direction1] IS NOT NULL
	UNION
	SELECT 200 + [Index],	[DocumentIndex], [Id], [DocumentId], [LineType],
		[OperationId2], [AccountId2], [CustodyId2], [ResourceId2], [Direction2], [Amount2], [Value2], [NoteId2], [Reference2], 
		[RelatedReference2], [RelatedAgentId2], [RelatedResourceId2], [RelatedAmount2], [EntityState]
	FROM @LinesLocal WHERE [EntityState] IN (N'Inserted', N'Updated') AND [Direction2] IS NOT NULL
	UNION
	SELECT 300 + [Index],	[DocumentIndex], [Id], [DocumentId], [LineType],
		[OperationId3], [AccountId3], [CustodyId3], [ResourceId3], [Direction3], [Amount3], [Value3], [NoteId3], [Reference3], 
		[RelatedReference3], [RelatedAgentId3], [RelatedResourceId3], [RelatedAmount3], [EntityState]
	FROM @LinesLocal WHERE [EntityState] IN (N'Inserted', N'Updated') AND [Direction3] IS NOT NULL
	UNION
	SELECT 400 + [Index],	[DocumentIndex], [Id], [DocumentId], [LineType],
		[OperationId4], [AccountId4], [CustodyId4], [ResourceId4], [Direction4], [Amount4], [Value4], [NoteId4], [Reference4], 
		[RelatedReference4], [RelatedAgentId4], [RelatedResourceId4], [RelatedAmount4], [EntityState]
	FROM @LinesLocal WHERE [EntityState] IN (N'Inserted', N'Updated') AND [Direction4] IS NOT NULL;
	
--	SELECT * FROM @SmartEntriesLocal;
	UPDATE @SmartEntriesLocal SET [Index] = [Index] + (SELECT ISNULL(MAX([Index]), 0) FROM @EntriesLocal);
	IF @DEBUG = 2 SELECT * FROM @SmartEntriesLocal;
	INSERT INTO @EntriesLocal([Index], [DocumentIndex], [Id], [DocumentId], [LineType],	[OperationId],
		[AccountId], [CustodyId], [ResourceId], [Direction], [Amount], [Value], [NoteId], [Memo],
		[Reference], [RelatedReference], [RelatedAgentId], [RelatedResourceId], [RelatedAmount], [EntityState])
	SELECT ROW_NUMBER() OVER(ORDER BY [DocumentIndex] ASC, [Direction] DESC), [DocumentIndex], [Id], [DocumentId], [LineType],	[OperationId],
		[AccountId], [CustodyId], [ResourceId], [Direction], SUM([Amount]), SUM([Value]), [NoteId], [Memo],
		[Reference], [RelatedReference], [RelatedAgentId], [RelatedResourceId], [RelatedAmount], N'Inserted' AS [EntityState]
	FROM @SmartEntriesLocal
	GROUP BY [DocumentIndex], [Id], [DocumentId], [LineType], [OperationId],
		[AccountId], [CustodyId], [ResourceId], [Direction], [NoteId], [Memo],
		[Reference], [RelatedReference], [RelatedAgentId], [RelatedResourceId], [RelatedAmount]
END
--SELECT * FROM @DocumentLineTypesLocal;
--SELECT * FROM @LinesLocal;
IF @DEBUG = 2 SELECT * FROM @EntriesLocal;

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