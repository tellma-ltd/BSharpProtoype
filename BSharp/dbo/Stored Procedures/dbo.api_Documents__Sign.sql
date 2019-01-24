CREATE PROCEDURE [dbo].[api_Documents__Sign]
	@Documents [dbo].[IndexedIdList] READONLY,
	@ValidationErrorsJson NVARCHAR(MAX) OUTPUT,
	@ReturnEntities bit = 1,
	@ResultJson NVARCHAR(MAX) OUTPUT
AS
BEGIN
	EXEC [dbo].[bll_Documents_Validate__Sign]
		@Documents = @Documents,
		@ValidationErrorsJson = @ValidationErrorsJson OUTPUT;
			
	IF @ValidationErrorsJson IS NOT NULL
		RETURN;

	EXEC [dbo].[dal_Documents__Sign] @Documents = @Documents;

	IF (@ReturnEntities = 1)
	BEGIN
		DECLARE @Ids [dbo].[IntegerList];
		
		INSERT INTO @Ids([Id])
		SELECT [Id] 
		FROM @Documents;

		EXEC [dbo].[dal_Documents__Select] @Ids = @Ids, @ResultJson = @ResultJson OUTPUT;
	END
END;