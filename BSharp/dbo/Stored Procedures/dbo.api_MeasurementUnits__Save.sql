CREATE PROCEDURE [dbo].[api_MeasurementUnits__Save]
	@Entities [MeasurementUnitForSaveList] READONLY,
	@ValidationErrorsJson NVARCHAR(MAX) OUTPUT,
	@ReturnEntities bit = 1,
	@EntitiesResultJson NVARCHAR(MAX) OUTPUT
AS
BEGIN
SET NOCOUNT ON;
DECLARE @IndexedIdsJson NVARCHAR(MAX), @Ids [dbo].[IntegerList];
-- Validate
	EXEC [dbo].[bll_MeasurementUnits_Save__Validate]
		@Entities = @Entities,
		@ValidationErrorsJson = @ValidationErrorsJson OUTPUT

	IF @ValidationErrorsJson IS NOT NULL
		RETURN;

	EXEC [dbo].[dal_MeasurementUnits__Save]
		@Entities = @Entities,
		@IndexedIdsJson = @IndexedIdsJson OUTPUT;

	IF (@ReturnEntities = 1)
	BEGIN
		INSERT INTO @Ids([Id])
		SELECT [Id] 
		FROM OpenJson(@IndexedIdsJson)
		WITH ([Index] INT '$.Index', [Id] INT '$.Id');

		EXEC [dbo].[dal_MeasurementUnits__Select] 
			@Ids = @Ids, @EntitiesResultJson = @EntitiesResultJson OUTPUT;
	END
END;