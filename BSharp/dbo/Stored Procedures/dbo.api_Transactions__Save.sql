CREATE PROCEDURE [dbo].[api_Transactions__Save]
	@Transactions [dbo].[TransactionList] READONLY,
	@WideLines [dbo].[TransactionWideLineList] READONLY, 
	@ValidationErrorsJson NVARCHAR(MAX) OUTPUT,
	@ReturnEntities bit = 1
AS
BEGIN
	DECLARE @IndexedIdsJson NVARCHAR(MAX), @Ids [dbo].[IdList];
	DECLARE @ResultJson NVARCHAR(MAX);
	DECLARE @Lines dbo.TransactionLineList;
	DECLARE @Entries dbo.TransactionEntryList;
	
	EXEC [dbo].[bll_TransactionWideLines__Unpivot] -- UI logic to fill missing fields, and unpivot
		@WideLines = @WideLines,
		@ResultJson = @ResultJson OUTPUT;

/* TODO: Needs to debug the two lines
	INSERT INTO @Lines SELECT * FROM dbo.[fw_TransactionLines__Json](@ResultJson);
	INSERT INTO @Entries SELECT * FROM dbo.[fw_TransactionEntries__Json](@ResultJson);
*/
	--Validate Domain rules
	EXEC [dbo].[bll_Transactions_Validate__Save]
		@Transactions = @Transactions,
		@Entries = @Entries,
		@ValidationErrorsJson = @ValidationErrorsJson OUTPUT;

	IF @ValidationErrorsJson IS NOT NULL
		RETURN;

	--SELECT * FROM @TransactionsLocal;
	--SELECT * FROM @WideLinesLocal;
	--SELECT * FROM @EntriesLocal;
	-- Validate business rules (read from the table)

	EXEC [dbo].[dal_Transactions__Save]
		@Transactions = @Transactions,
		@Lines = @Lines,
		@Entries = @Entries,
		@IndexedIdsJson = @IndexedIdsJson OUTPUT;

	IF (@ReturnEntities = 1)
	BEGIN
		INSERT INTO @Ids([Id])
		SELECT [Id] 
		FROM OpenJson(@IndexedIdsJson) WITH ([Index] INT, [Id] INT);

		EXEC [dbo].[dal_Documents__Select] @Ids = @Ids;
	END;
END;