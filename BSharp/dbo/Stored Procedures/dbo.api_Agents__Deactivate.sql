CREATE PROCEDURE [dbo].[api_Agents__Deactivate]
	@Ids [dbo].[IntegerList] READONLY,
	@ValidationErrorsJson NVARCHAR(MAX) = NULL OUTPUT,
	@ReturnEntities bit = 1,
	@ResultsJson NVARCHAR(MAX) OUTPUT
AS
SET NOCOUNT ON;
	EXEC [dbo].[dal_Agents__Activate] @Ids = @Ids, @IsActive = 0;

	IF (@ReturnEntities = 1)
		EXEC [dbo].[dal_Agents__Select] 
			@Ids = @Ids,
			@ResultsJson = @ResultsJson OUTPUT;