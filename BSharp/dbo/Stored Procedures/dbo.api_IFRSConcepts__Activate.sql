CREATE PROCEDURE [dbo].[api_IFRSConcepts__Activate]
	@Ids [dbo].[StringList] READONLY,
	@ValidationErrorsJson NVARCHAR(MAX) = NULL OUTPUT,
	@ReturnEntities bit = 1,
	@ResultsJson NVARCHAR(MAX) OUTPUT
AS
SET NOCOUNT ON;
	EXEC [dbo].[dal_IFRSConcepts__Activate] @Ids = @Ids, @IsActive = 1;