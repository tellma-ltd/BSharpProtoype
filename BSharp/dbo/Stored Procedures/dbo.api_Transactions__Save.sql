CREATE PROCEDURE [dbo].[api_Transactions__Save]
	@Transactions [dbo].[TransactionList] READONLY,
	@DocumentLineTypes [dbo].[DocumentLineTypeList] READONLY,
	@Lines [dbo].[TransactionLineList] READONLY, 
	@Entries [dbo].[TransactionEntryList] READONLY,
	@ValidationErrorsJson NVARCHAR(MAX) OUTPUT,
	@ReturnEntities bit = 1,
	@ResultJson NVARCHAR(MAX) = NULL OUTPUT
AS
BEGIN
	DECLARE @IndexedIdsJson NVARCHAR(MAX), @Ids [dbo].[IntegerList];
	DECLARE @TransactionsLocal [dbo].[TransactionList], @LinesLocal [dbo].[TransactionLineList], @EntriesLocal [dbo].[TransactionEntryList];

	/*TODO: Uncomment and debug
	EXEC [dbo].[bll_Documents__Fill] -- UI logic to fill missing fields
		@Transactions = @Transactions,
		@DocumentLineTypes = @DocumentLineTypes,
		@Lines = @Lines,
		@Entries = @Entries,
		@ResultJson = @ResultJson OUTPUT;
*/
		/* TODO: Uncomment and debug
	INSERT INTO @TransactionsLocal SELECT * FROM dbo.[fw_Documents__Json](@ResultJson);
	INSERT INTO @LinesLocal SELECT * FROM dbo.[fw_Lines__Json](@ResultJson);
	INSERT INTO @EntriesLocal SELECT * FROM dbo.[fw_Entries__Json](@ResultJson);
	*/
	--Validate Domain rules
	EXEC [dbo].[bll_Transactions_Validate__Save]
		@Transactions = @TransactionsLocal,
		@Lines = @LinesLocal,
		@Entries = @EntriesLocal,
		@ValidationErrorsJson = @ValidationErrorsJson OUTPUT;

	IF @ValidationErrorsJson IS NOT NULL
		RETURN;

	--SELECT * FROM @TransactionsLocal;
	--SELECT * FROM @LinesLocal;
	--SELECT * FROM @EntriesLocal;
	-- Validate business rules (read from the table)

	EXEC [dbo].[dal_Transactions__Save]
		@Transactions = @TransactionsLocal,
		@Lines = @LinesLocal,
		@Entries = @EntriesLocal,
		@IndexedIdsJson = @IndexedIdsJson OUTPUT;

	IF (@ReturnEntities = 1)
	BEGIN
		INSERT INTO @Ids([Id])
		SELECT [Id] 
		FROM OpenJson(@IndexedIdsJson) WITH ([Index] INT, [Id] INT);

		EXEC [dbo].[dal_Documents__Select] @Ids = @Ids, @ResultJson = @ResultJson OUTPUT;
	END;
END;