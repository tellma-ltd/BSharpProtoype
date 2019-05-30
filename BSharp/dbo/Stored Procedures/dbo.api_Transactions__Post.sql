CREATE PROCEDURE [dbo].[api_Transactions__Post]
	@Entities [dbo].[IndexedIdList] READONLY,
	@ValidationErrorsJson NVARCHAR(MAX) OUTPUT,
	@ReturnEntities bit = 1,
	@ResultJson NVARCHAR(MAX) = NULL OUTPUT
AS
BEGIN
	DECLARE @Ids [dbo].[IntegerList];
	-- if all documents are already posted, return
	IF NOT EXISTS(
		SELECT * FROM [dbo].[Documents]
		WHERE [Id] IN (SELECT [Id] FROM @Entities)
		AND [DocumentState] <> N'Posted'
	)
		RETURN;

	-- Sign the document before posting it
	EXEC [dbo].[bll_Documents_Validate__Sign]
		@Documents = @Entities,
		@ValidationErrorsJson = @ValidationErrorsJson OUTPUT;
			
	IF @ValidationErrorsJson IS NOT NULL
		RETURN;

	EXEC [dbo].[dal_Documents__Sign] @Documents = @Entities;

	-- Validate, checking available signatures for transaction type
	EXEC [dbo].[bll_Transactions_Validate__Post]
		@Transactions = @Entities,
		@ValidationErrorsJson = @ValidationErrorsJson OUTPUT;
			
	IF @ValidationErrorsJson IS NOT NULL
		RETURN;

	EXEC [dbo].[dal_Documents_State__Update]	@Documents = @Entities, @State = N'Posted';

	IF (@ReturnEntities = 1)
	BEGIN
		INSERT INTO @Ids([Id])
		SELECT [Id] 
		FROM @Entities;

		EXEC [dbo].[dal_Documents__Select] @Ids = @Ids, @ResultJson = @ResultJson OUTPUT;
	END
END;