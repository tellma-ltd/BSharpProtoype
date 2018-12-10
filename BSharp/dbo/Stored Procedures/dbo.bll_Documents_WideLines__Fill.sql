CREATE PROCEDURE [dbo].[bll_Documents_WideLines__Fill]
		@Documents dbo.DocumentForSaveList READONLY, 
		@WideLines  dbo.WideLineForSaveList READONLY, 
		@LinesResultJson NVARCHAR(MAX) OUTPUT,
		@EntriesResultJson NVARCHAR(MAX) = NULL OUTPUT
AS
DECLARE
	@DocumentId int = 0,
	@TransactionType NVARCHAR(255),
	@ResponsibleAgentId int,
	@StartDateTime datetimeoffset(7),
	@EndDateTime datetimeoffset(7),	
	@Memo  nvarchar(255),

	@Operation1 int,
	@Reference1 NVARCHAR(255),
	@Account1 nvarchar(255),
	@Custody1 int, 
	@Resource1 int,
	@Direction1 smallint, 
	@Amount1 money,
	@Value1 money,
	@Note1 nvarchar(255),
	@RelatedReference1 NVARCHAR(255),
	@RelatedAgent1 int,
	@RelatedResource1 int,
	@RelatedAmount1 money,

	@Operation2 int,
	@Reference2 NVARCHAR(255),
	@Account2 nvarchar(255),
	@Custody2 int, 
	@Resource2 int,
	@Direction2 smallint, 
	@Amount2 money,
	@Value2 money,
	@Note2 nvarchar(255),
	@RelatedReference2 NVARCHAR(255),
	@RelatedAgent2 int,
	@RelatedResource2 int,
	@RelatedAmount2 money,

	@Operation3 int,
	@Reference3 NVARCHAR(255),
	@Account3 nvarchar(255),
	@Custody3 int, 
	@Resource3 int,
	@Direction3 smallint, 
	@Amount3 money,
	@Value3 money,
	@Note3 nvarchar(255),
	@RelatedReference3 NVARCHAR(255),
	@RelatedAgent3 int,
	@RelatedResource3 int,
	@RelatedAmount3 money,

	@LinesLocal dbo.LineForSaveList,
	@EntriesLocal dbo.EntryForSaveList,
	@EntriesTransit EntryList;
	-- in memory processing
	SET @DocumentId = (SELECT MIN(Id) FROM @Documents WHERE Id > @DocumentId);
	WHILE @DocumentId IS NOT NULL
	BEGIN
		DECLARE	@LineId int = 0;
		SET @LineId = (SELECT min([LineId]) FROM @WideLines WHERE DocumentId = @DocumentId AND [LineId] > @LineId)
		WHILE @LineId IS NOT NULL
		BEGIN
			--Print 'Document ' + cast(@DocumentId as NVARCHAR(255)) + ', Line ' + Cast(@LineId as NVARCHAR(255));
			SELECT
				@DocumentId = DocumentId,
				@TransactionType = TransactionType,
				@ResponsibleAgentId = ResponsibleAgentId,
				@StartDateTime = StartDateTime,
				@EndDateTime = EndDateTime,
				@Memo = Memo,

				@Operation1 = Operation1,
				@Reference1 = Reference1,
				@Account1 = Account1,
				@Custody1 = Custody1, 
				@Resource1 = Resource1,
				@Direction1 = Direction1, 
				@Amount1 = Amount1,
				@Value1 = Value1,
				@Note1 = Note1,
				@RelatedReference1 = RelatedReference1,
				@RelatedAgent1 = RelatedAgent1,
				@RelatedResource1 = RelatedResource1,
				@RelatedAmount1 = RelatedAmount1,

				@Operation2 = Operation2,
				@Reference2 = Reference2,
				@Account2 = Account2,
				@Custody2 = Custody2, 
				@Resource2 = Resource2,
				@Direction2 = Direction2, 
				@Amount2 = Amount2,
				@Value2 = Value2,
				@Note2 = Note2,
				@RelatedReference2 = RelatedReference2,
				@RelatedAgent2 = RelatedAgent2,
				@RelatedResource2 = RelatedResource2,
				@RelatedAmount2 = RelatedAmount2,

				@Operation3 = Operation3,
				@Reference3 = Reference3,
				@Account3 = Account3,
				@Custody3 = Custody3, 
				@Resource3 = Resource3,
				@Direction3 = Direction3, 
				@Amount3 = Amount3,
				@Value3 = Value3,
				@Note3 = Note3,
				@RelatedReference3 = RelatedReference3,
				@RelatedAgent3 = RelatedAgent3,
				@RelatedResource3 = RelatedResource3,
				@RelatedAmount3 = RelatedAmount3
			FROM @WideLines
			WHERE DocumentId = @DocumentId AND [LineId] = @LineId

			INSERT INTO @EntriesTransit 
			EXEC [dbo].[bll_WideLine__Entries] 
				@LineId = @LineId,
				@TransactionType = @TransactionType,

				@Operation1 = @Operation1,
				@Reference1 = @Reference1,
				@Account1 = @Account1,
				@Custody1 = @Custody1, 
				@Resource1 = @Resource1,
				@Direction1 = @Direction1, 
				@Amount1 = @Amount1,
				@Value1 = @Value1,
				@Note1 = @Note1,
				@RelatedReference1 = @RelatedReference1,
				@RelatedAgent1 = @RelatedAgent1,
				@RelatedResource1 = @RelatedResource1,
				@RelatedAmount1 = @RelatedAmount1,

				@Operation2 = @Operation2,
				@Reference2 = @Reference2,
				@Account2 = @Account2,
				@Custody2 = @Custody2, 
				@Resource2 = @Resource2,
				@Direction2 = @Direction2, 
				@Amount2 = @Amount2,
				@Value2 = @Value2,
				@Note2 = @Note2,
				@RelatedReference2 = @RelatedReference2,
				@RelatedAgent2 = @RelatedAgent2,
				@RelatedResource2 = @RelatedResource2,
				@RelatedAmount2 = @RelatedAmount2,

				@Operation3 = @Operation3,
				@Reference3 = @Reference3,
				@Account3 = @Account3,
				@Custody3 = @Custody3, 
				@Resource3 = @Resource3,
				@Direction3 = @Direction3, 
				@Amount3 = @Amount3,
				@Value3 = @Value3,
				@Note3 = @Note3,
				@RelatedReference3 = @RelatedReference3,
				@RelatedAgent3 = @RelatedAgent3,
				@RelatedResource3 = @RelatedResource3,
				@RelatedAmount3 = @RelatedAmount3
			SET @LineId = (SELECT min([LineId]) FROM @WideLines WHERE DocumentId = @DocumentId AND [LineId] > @LineId)
		END
		SET @DocumentId = (SELECT MIN(Id) FROM @Documents WHERE Id > @DocumentId);
	END

	IF EXISTS(SELECT * FROM @EntriesTransit)
		INSERT INTO @EntriesLocal
		EXEC [dbo].[bll_Document_Values__Update] 
				@WideLines = @WideLines, @Entries = @EntriesTransit
	
	INSERT INTO @LinesLocal(DocumentId, StartDateTime, EndDateTime, Memo)
	SELECT DocumentId, StartDateTime, EndDateTime, Memo FROM @WideLines;
/* commented out temporarily
	INSERT INTO @LinesLocal SELECT * FROM @Lines;
	INSERT INTO @EntriesLocal SELECT * FROM @Entries;
*/
	-- Bulk Update all null operations to business entity
	UPDATE @EntriesLocal
	SET OperationId = (SELECT min(Id) FROM [dbo].[Operations] WHERE OperationType = N'BusinessEntity')
	WHERE OperationId IS NULL

	--Bulk Balance all lines having only one null value, by setting the value to the total of the other entries
	UPDATE E
	SET E.Value = -SN2.Net
	FROM @EntriesLocal E
	JOIN (
		SELECT LineId
		FROM @EntriesLocal
		WHERE Value IS NULL
		GROUP BY LineId
		HAVING COUNT(*) = 1
	) SN1 ON E.LineId = SN1.LineId -- Single Null
	JOIN (
		SELECT LineId, SUM(Direction * Value) As Net
		FROM @EntriesLocal
		WHERE Value IS NOT NULL
		GROUP BY LineId
	) SN2 ON SN1.LineId = SN2.LineId
	WHERE E.Value IS NULL