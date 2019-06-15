CREATE PROCEDURE [dbo].[api_Documents__Sign]
	@Entities [dbo].[IndexedIdList] READONLY,
	@ValidationErrorsJson NVARCHAR(MAX) OUTPUT,
	@ReturnEntities bit = 1,
	@ResultJson NVARCHAR(MAX) OUTPUT
AS
BEGIN
	EXEC [dbo].[bll_Documents_Validate__Sign]
		@Entities = @Entities,
		@ValidationErrorsJson = @ValidationErrorsJson OUTPUT;
			
	IF @ValidationErrorsJson IS NOT NULL
		RETURN;

	EXEC [dbo].[dal_Documents__Sign] @Entities = @Entities;

	IF (@ReturnEntities = 1)
	BEGIN
		DECLARE @Ids [dbo].[IdList];
		
		INSERT INTO @Ids([Id])
		SELECT [Id] 
		FROM @Entities;

		EXEC [dbo].[dal_Documents__Select] @Ids = @Ids, @ResultJson = @ResultJson OUTPUT;
	END
END;