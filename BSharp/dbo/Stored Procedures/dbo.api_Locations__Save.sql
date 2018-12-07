CREATE PROCEDURE [dbo].[api_Locations__Save]
	@Locations [LocationForSaveList] READONLY,
	@ValidationErrorsJson NVARCHAR(MAX) OUTPUT,
	@ReturnResults bit = 1,
	@LocationsResultJson NVARCHAR(MAX) OUTPUT
AS
BEGIN
SET NOCOUNT ON;
DECLARE @IndexedIdsJson NVARCHAR(MAX);
-- Validate
	EXEC [dbo].[bll_Locations__Validate]
		@Locations = @Locations,
		@ValidationErrorsJson = @ValidationErrorsJson OUTPUT

	IF @ValidationErrorsJson IS NOT NULL
		RETURN;

	EXEC [dbo].[dal_Locations__Save]
		@Locations = @Locations,
		@IndexedIdsJson = @IndexedIdsJson OUTPUT

	IF (@ReturnResults = 1)
		EXEC [dbo].[dal_Locations__Select] 
			@IndexedIdsJson = @IndexedIdsJson, @LocationsResultJson = @LocationsResultJson OUTPUT
END;