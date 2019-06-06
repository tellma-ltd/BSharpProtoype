CREATE PROCEDURE [dbo].[api_ProductCategories__Delete]
	@Entities [IntegerList] READONLY,
	@ValidationErrorsJson NVARCHAR(MAX) OUTPUT
AS
BEGIN
SET NOCOUNT ON;
DECLARE @Ids [dbo].[IntegerList];
-- Validate

	EXEC [dbo].[bll_ProductCategories_Validate__Delete]
		@Entities = @Entities,
		@ValidationErrorsJson = @ValidationErrorsJson OUTPUT;

	IF @ValidationErrorsJson IS NOT NULL
		RETURN;

	EXEC [dbo].[dal_ProductCategories__Delete]
		@Entities = @Entities;
END;