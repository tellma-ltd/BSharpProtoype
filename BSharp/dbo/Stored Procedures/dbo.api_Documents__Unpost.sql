CREATE PROCEDURE [dbo].[api_Documents__Unpost]
	@Documents [dbo].[IndexedIdList] READONLY,
	@ValidationErrorsJson NVARCHAR(MAX) OUTPUT,
	@ReturnEntities bit = 1,
	@ResultJson NVARCHAR(MAX) = NULL OUTPUT
AS
BEGIN
	DECLARE @Ids [dbo].[IdList];
	-- if all documents are already posted, return
	IF NOT EXISTS(
		SELECT * FROM [dbo].[Documents]
		WHERE [Id] IN (SELECT [Id] FROM @Documents)
		AND [DocumentState] <> N'Draft'
	)
		RETURN;

	-- Validate, checking available signatures for transaction type
	EXEC [dbo].[bll_Transactions_Validate__Unpost]
		@Transactions = @Documents,
		@ValidationErrorsJson = @ValidationErrorsJson OUTPUT;
			
	IF @ValidationErrorsJson IS NOT NULL
		RETURN;

	EXEC [dbo].[dal_Documents_State__Update]	@Documents = @Documents, @State = N'Draft';

	IF (@ReturnEntities = 1)
	BEGIN
		INSERT INTO @Ids([Id])
		SELECT [Id] 
		FROM @Documents;

		EXEC [dbo].[dal_Documents__Select] @Ids = @Ids, @ResultJson = @ResultJson OUTPUT;
	END
END;