CREATE PROCEDURE [dbo].[api_Locations__Save]
	@Locations [LocationForSaveList] READONLY,
	@ValidationErrorsJson NVARCHAR(MAX) OUTPUT,
	@IndexedIdsJson NVARCHAR(MAX) OUTPUT
AS
BEGIN
SET NOCOUNT ON;
-- Validate
	EXEC [dbo].[bll_Locations__Validate]
		@Locations = @Locations,
		@ValidationErrorsJson = @ValidationErrorsJson OUTPUT

	IF @ValidationErrorsJson IS NOT NULL
		RETURN;

	EXEC [dbo].[dal_Locations__Save]
		@Locations = @Locations,
		@IndexedIdsJson = @IndexedIdsJson OUTPUT
END;