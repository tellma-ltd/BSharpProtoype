CREATE PROCEDURE [dbo].[api_IfrsConcepts__Deactivate]
	@Ids [dbo].[StringList] READONLY,
	@ValidationErrorsJson NVARCHAR(MAX) = NULL OUTPUT,
	@ReturnEntities bit = 1,
	@ResultsJson NVARCHAR(MAX) OUTPUT
AS
SET NOCOUNT ON;
	EXEC [dbo].[dal_IfrsConcepts__Activate] @Ids = @Ids, @IsActive = 0;
