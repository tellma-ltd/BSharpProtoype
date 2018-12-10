CREATE PROCEDURE [dbo].[api_Resources__Save]
	@Resources [ResourceForSaveList] READONLY,
	@ValidationErrorsJson NVARCHAR(MAX) OUTPUT,
	@ReturnEntities bit = 1,
	@ResourcesResultJson  NVARCHAR(MAX) OUTPUT
AS
BEGIN
SET NOCOUNT ON;
DECLARE @IndexedIdsJson NVARCHAR(MAX);
-- Validate
	EXEC [dbo].[bll_Resources__Validate]
		@Resources = @Resources,
		@ValidationErrorsJson = @ValidationErrorsJson OUTPUT

	IF @ValidationErrorsJson IS NOT NULL
		RETURN;

	EXEC [dbo].[dal_Resources__Save]
		@Resources = @Resources,
		@IndexedIdsJson = @IndexedIdsJson OUTPUT

	IF (@ReturnEntities = 1)
		EXEC [dbo].[dal_Resources__Select] 
			@IndexedIdsJson = @IndexedIdsJson, @ResourcesResultJson = @ResourcesResultJson OUTPUT
END