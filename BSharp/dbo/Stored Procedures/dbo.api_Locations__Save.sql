CREATE PROCEDURE [dbo].[api_Locations__Save]
	@Locations [LocationForSaveList] READONLY,
	@ValidationErrorsJson NVARCHAR(MAX) OUTPUT,
	@ReturnEntities bit = 1,
	@LocationsResultJson NVARCHAR(MAX) OUTPUT
AS
BEGIN
SET NOCOUNT ON;
DECLARE @IndexedIdsJson NVARCHAR(MAX), @IndexedIds dbo.[IndexedIdList];
-- Validate
	EXEC [dbo].[bll_Locations__Validate]
		@Locations = @Locations,
		@ValidationErrorsJson = @ValidationErrorsJson OUTPUT;

	IF @ValidationErrorsJson IS NOT NULL
		RETURN;

	EXEC [dbo].[dal_Locations__Save]
		@Locations = @Locations,
		@IndexedIdsJson = @IndexedIdsJson OUTPUT;

	IF (@ReturnEntities = 1)
	BEGIN
		INSERT INTO @IndexedIds([Index], [Id])
		SELECT [Index], [Id] 
		FROM OpenJson(@IndexedIdsJson)
		WITH ([Index] INT '$.Index', [Id] INT '$.Id');

		EXEC [dbo].[dal_Locations__Select] 
			@IndexedIds = @IndexedIds, @LocationsResultJson = @LocationsResultJson OUTPUT;
	END
END;