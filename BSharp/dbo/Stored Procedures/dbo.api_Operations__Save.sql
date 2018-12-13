CREATE PROCEDURE [dbo].[api_Operations__Save]
	@Operations [OperationForSaveList] READONLY,
	@ValidationErrorsJson NVARCHAR(MAX) OUTPUT,
	@ReturnEntities bit = 1,
	@OperationsResultJson NVARCHAR(MAX) OUTPUT
AS
BEGIN
SET NOCOUNT ON;
DECLARE @IndexedIdsJson NVARCHAR(MAX), @IndexedIds dbo.[IndexedIdList];
-- Validate
	EXEC [dbo].[bll_Operations__Validate]
		@Operations = @Operations,
		@ValidationErrorsJson = @ValidationErrorsJson OUTPUT;

	IF @ValidationErrorsJson IS NOT NULL
		RETURN;

	EXEC [dbo].[dal_Operations__Save]
		@Operations = @Operations,
		@IndexedIdsJson = @IndexedIdsJson OUTPUT;

	IF (@ReturnEntities = 1)
	BEGIN
		INSERT INTO @IndexedIds([Index], [Id])
		SELECT [Index], [Id] 
		FROM OpenJson(@IndexedIdsJson)
		WITH ([Index] INT '$.Index', [Id] INT '$.Id');

		EXEC [dbo].[dal_Operations__Select] 
			@IndexedIds = @IndexedIds, @OperationsResultJson = @OperationsResultJson OUTPUT;
	END
END;