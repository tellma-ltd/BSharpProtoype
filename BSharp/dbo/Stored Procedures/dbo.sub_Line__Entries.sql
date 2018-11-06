
CREATE PROCEDURE [dbo].[sub_Line__Entries] -- [dbo].[sub_Line__Entries]1,1,N'ManualJV'
	@DocumentId int,
	@TransactionType nvarchar(50),
	@LineNumber int,

--	@ResponsibleAgentId int = NULL,
--	@StartDateTime datetimeoffset(7) = NULL,
--	@EndDateTime datetimeoffset(7) = NULL,
-- @Memo nvarchar(255) = NULL

	@Operation1 int = NULL,
	@Reference1 nvarchar(50) = NULL,
	@Account1 nvarchar(255) = NULL,
	@Custody1 int = NULL, 
	@Resource1 int = NULL,
	@Direction1 smallint = NULL, 
	@Amount1 money = NULL,
	@Value1 money = NULL,
	@Note1 nvarchar(255) = NULL,
	@RelatedReference1 nvarchar(50) = NULL,
	@RelatedAgent1 int = NULL,
	@RelatedResource1 int = NULL,
	@RelatedAmount1 money = NULL,

	@Operation2 int = NULL,
	@Reference2 nvarchar(50) = NULL,
	@Account2 nvarchar(255) = NULL,
	@Custody2 int = NULL, 
	@Resource2 int = NULL,
	@Direction2 smallint = NULL, 
	@Amount2 money = NULL,
	@Value2 money = NULL,
	@Note2 nvarchar(255) = NULL,
	@RelatedReference2 nvarchar(50) = NULL,
	@RelatedAgent2 int = NULL,
	@RelatedResource2 int = NULL,
	@RelatedAmount2 money = NULL,

	@Operation3 int = NULL,
	@Reference3 nvarchar(50) = NULL,
	@Account3 nvarchar(255) = NULL,
	@Custody3 int = NULL, 
	@Resource3 int = NULL,
	@Direction3 smallint = NULL, 
	@Amount3 money = NULL,
	@Value3 money = NULL,
	@Note3 nvarchar(255) = NULL,
	@RelatedReference3 nvarchar(50) = NULL,
	@RelatedAgent3 int = NULL,
	@RelatedResource3 int = NULL,
	@RelatedAmount3 money = NULL
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @Entries As EntryList;
	DECLARE @AccountCalculation nvarchar(255), @CustodyCalculation nvarchar(255), @ResourceCalculation nvarchar(255), @DirectionCalculation nvarchar(255), @AmountCalculation nvarchar(255), @ValueCalculation nvarchar(255), @NoteCalculation nvarchar(255),
			@StartDateTimeCalculation nvarchar(255), @EndDateTimeCalculation nvarchar(255), @RelatedReferenceCalculation nvarchar(255), @RelatedAgentCalculation nvarchar(255), @RelatedResourceCalculation nvarchar(255), @RelatedAmountCalculation  nvarchar(255);
	DECLARE @EntriesCount tinyint, @EntryNumber tinyint, @AccountId nvarchar(255), @CustodyId int, @ResourceId int, @Direction smallint, @Amount money, @Value money, @NoteId nvarchar(255),
			@RelatedReference nvarchar(50), @RelatedAgentId int, @RelatedResourceId int, @RelatedAmount decimal;

	BEGIN TRY

		INSERT INTO @Entries
			(DocumentId, LineNumber, EntryNumber, OperationId, Reference, AccountId, CustodyId, ResourceId, Direction, Amount, Value, NoteId, RelatedReference, RelatedAgentId, RelatedResourceId, RelatedAmount)
		VALUES
			(@DocumentId, @LineNumber, 1, @Operation1, @Reference1, @Account1, @Custody1, @Resource1 , @Direction1 , @Amount1, @Value1, @Note1, @RelatedReference1 , @RelatedAgent1, @RelatedResource1, @RelatedAmount1),
			(@DocumentId, @LineNumber, 2, @Operation2, @Reference2, @Account2, @Custody2, @Resource2 , @Direction2 , @Amount2, @Value2, @Note2, @RelatedReference2 , @RelatedAgent2, @RelatedResource2, @RelatedAmount2),
			(@DocumentId, @LineNumber, 3, @Operation3, @Reference3, @Account3, @Custody3, @Resource3 , @Direction3 , @Amount3, @Value3, @Note3, @RelatedReference3 , @RelatedAgent3, @RelatedResource3, @RelatedAmount3);

		SELECT @EntriesCount = max(EntryNumber) FROM dbo.[TransactionTemplates] WHERE [TransactionType] = @TransactionType
		DELETE FROM @Entries WHERE EntryNumber > @EntriesCount;

		-- Calculate the remaining fields based on the logic in line templates 	
		-- if the logic does not require bulk operation, do it in memory using EF core
		SET @EntryNumber = 1
		WHILE @EntryNumber <= @EntriesCount
		BEGIN
			SELECT @AccountCalculation = Account, @CustodyCalculation = Custody, @ResourceCalculation = Resource, @DirectionCalculation = Direction, @AmountCalculation = Amount, @ValueCalculation = Value, @NoteCalculation = Note,
				@RelatedReferenceCalculation = RelatedReference, @RelatedAgentCalculation = RelatedAgent, @RelatedResourceCalculation = RelatedResource, @RelatedAmountCalculation = RelatedAmount
			FROM dbo.LineTemplatesCalculationView WHERE [TransactionType] = @TransactionType AND EntryNumber = @EntryNumber;

			-- Account calculation may need to be done in bulk, as when receiving thousands of items in stocks, then each item type may end up with different inventory classification.
			SET @AccountCalculation = N'SELECT @Account = ' + @AccountCalculation; EXEC sp_executesql @AccountCalculation, N'@Account nvarchar(255) OUTPUT', @Account = @AccountId OUTPUT
			SET @CustodyCalculation = N'SELECT @Custody = ' + @CustodyCalculation; EXEC sp_executesql @CustodyCalculation, N'@Entries EntryList READONLY, @Custody int OUTPUT', @Entries = @Entries, @Custody = @CustodyId OUTPUT
			SET @ResourceCalculation = N'SELECT @Resource = ' + @ResourceCalculation; EXEC sp_executesql @ResourceCalculation,  N'@Entries EntryList READONLY, @Resource int OUTPUT', @Entries = @Entries, @Resource = @ResourceId OUTPUT
			SET @DirectionCalculation = N'SELECT @Direction = ' + @DirectionCalculation; EXEC sp_executesql @DirectionCalculation, N'@Direction smallint OUTPUT', @Direction = @Direction OUTPUT
			SET @AmountCalculation = N'SELECT @Amount = ' + @AmountCalculation; EXEC sp_executesql @AmountCalculation,  N'@Entries EntryList READONLY, @Amount money OUTPUT', @Entries = @Entries, @Amount = @Amount OUTPUT
			IF LEFT(@ValueCalculation, 6) <> N'@BULK:' 
			BEGIN
				SET @ValueCalculation = N'SELECT @Value = ' + @ValueCalculation; 
				EXEC sp_executesql @ValueCalculation,  N'@Entries EntryList READONLY, @Value money OUTPUT', @Entries = @Entries, @Value = @Value OUTPUT 
			END
			SET @NoteCalculation = N'SELECT @Note = ' + @NoteCalculation; EXEC sp_executesql @NoteCalculation, N'@Note nvarchar(255) OUTPUT', @Note = @NoteId OUTPUT			
			SET @RelatedReferenceCalculation = N'SELECT @RelatedReference = ' + @RelatedReferenceCalculation; EXEC sp_executesql @RelatedReferenceCalculation,  N'@Entries EntryList READONLY, @RelatedReference nvarchar(50) OUTPUT', @Entries = @Entries, @RelatedReference = @RelatedReference OUTPUT			
			SET @RelatedAgentCalculation = N'SELECT @RelatedAgent = ' + @RelatedAgentCalculation; EXEC sp_executesql @RelatedAgentCalculation, N'@Entries EntryList READONLY, @RelatedAgent int OUTPUT', @Entries = @Entries, @RelatedAgent = @RelatedAgentId OUTPUT
			SET @RelatedResourceCalculation = N'SELECT @RelatedResource = ' + @RelatedResourceCalculation; EXEC sp_executesql @RelatedResourceCalculation,  N'@Entries EntryList READONLY, @RelatedResource int OUTPUT', @Entries = @Entries, @RelatedResource = @RelatedResourceId OUTPUT
			SET @RelatedAmountCalculation = N'SELECT @RelatedAmount = ' + @RelatedAmountCalculation; EXEC sp_executesql @RelatedAmountCalculation,  N'@Entries EntryList READONLY, @RelatedAmount money OUTPUT', @Entries = @Entries, @RelatedAmount = @RelatedAmount OUTPUT

			UPDATE @Entries
			SET 
				AccountId = ISNULL(AccountId, @AccountId),
				CustodyId = ISNULL(CustodyId, @CustodyId),
				ResourceId = ISNULL(ResourceId, @ResourceId),
				Direction = ISNULL(Direction, @Direction),
				Amount = ISNULL(Amount, @Amount),
				Value = ISNULL(Value, @Value),
				NoteId = ISNULL(NoteId, @NoteId),
				RelatedReference = ISNULL(RelatedReference, @RelatedReference),
				RelatedAgentId = ISNULL(RelatedAgentId, @RelatedAgentId),
				RelatedResourceId = ISNULL(RelatedResourceId, @RelatedResourceId),
				RelatedAmount = ISNULL(RelatedAmount, @RelatedAmount)
			WHERE EntryNumber = @EntryNumber

			SELECT @AccountId = NULL, @CustodyId = NULL, @ResourceId = NULL, @Direction = NULL, @Amount = NULL, @Value = NULL, @NoteId = NULL, 
					@RelatedReference = NULL, @RelatedAgentId = NULL, @RelatedResourceId = NULL, @RelatedAmount = NULL,
					@EntryNumber = @EntryNumber + 1
		END
		-- second pass for values only
		SET @EntryNumber = 1
		WHILE @EntryNumber <= @EntriesCount
		BEGIN
			SELECT @ValueCalculation = Value
			FROM dbo.LineTemplatesCalculationView WHERE [TransactionType] = @TransactionType AND EntryNumber = @EntryNumber;
			
			IF LEFT(@ValueCalculation, 6) <> N'@BULK:' 
			BEGIN
				SET @ValueCalculation = N'SELECT @Value = ' + @ValueCalculation; 
				EXEC sp_executesql @ValueCalculation,  N'@Entries EntryList READONLY, @Value money OUTPUT', @Entries = @Entries, @Value = @Value OUTPUT 
			END
			
			UPDATE @Entries
			SET 
				Value = ISNULL(Value, @Value)
			WHERE EntryNumber = @EntryNumber

			SELECT @Value = NULL, @EntryNumber = @EntryNumber + 1
		END

		SELECT * FROM @Entries;
	END TRY

	BEGIN CATCH
	    SELECT   /*
        ERROR_NUMBER() AS ErrorNumber  
        ,ERROR_SEVERITY() AS ErrorSeverity  
        ,ERROR_STATE() AS ErrorState  
        , */ERROR_PROCEDURE() AS ErrorProcedure  
        ,ERROR_LINE() AS ErrorLine  
        ,ERROR_MESSAGE() AS ErrorMessage; 
		THROW;
	END CATCH
END
