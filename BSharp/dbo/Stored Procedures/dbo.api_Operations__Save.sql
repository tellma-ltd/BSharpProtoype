CREATE PROCEDURE [dbo].[api_Operations__Save]
	@Operations [OperationForSaveList] READONLY,
	@ValidationErrorsJson NVARCHAR(MAX) OUTPUT,
	@ReturnEntities bit = 1,
	@OperationsResultJson  NVARCHAR(MAX) OUTPUT
AS
BEGIN
SET NOCOUNT ON;
DECLARE @IndexedIdsJson NVARCHAR(MAX);
-- Validate
	EXEC [dbo].[bll_Operations__Validate]
		@Operations = @Operations,
		@ValidationErrorsJson = @ValidationErrorsJson OUTPUT

	IF @ValidationErrorsJson IS NOT NULL
		RETURN;

	EXEC [dbo].[dal_Operations__Save]
		@Operations = @Operations,
		@IndexedIdsJson = @IndexedIdsJson OUTPUT

	IF (@ReturnEntities = 1)
		EXEC [dbo].[dal_Operations__Select] 
			@IndexedIdsJson = @IndexedIdsJson, @OperationsResultJson = @OperationsResultJson OUTPUT
END;