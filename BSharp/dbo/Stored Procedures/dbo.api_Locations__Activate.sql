	CREATE PROCEDURE [dbo].[api_Locations__Activate]
	@IndexedIds [dbo].[IndexedIdList] READONLY,
	@ValidationErrorsJson NVARCHAR(MAX) = NULL OUTPUT,
	@ReturnEntities bit = 1,
	@LocationsResultJson NVARCHAR(MAX) OUTPUT
AS
SET NOCOUNT ON;
	EXEC [dbo].[dal_Custodies__Activate] @IndexedIds = @IndexedIds, @IsActive = 1;

	IF (@ReturnEntities = 1)
	EXEC [dbo].[dal_Locations__Select] 
		@IndexedIds = @IndexedIds, @LocationsResultJson = @LocationsResultJson OUTPUT;
