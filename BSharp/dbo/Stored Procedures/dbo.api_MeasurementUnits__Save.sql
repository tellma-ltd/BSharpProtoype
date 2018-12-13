CREATE PROCEDURE [dbo].[api_MeasurementUnits__Save]
	@MeasurementUnits [MeasurementUnitForSaveList] READONLY,
	@ValidationErrorsJson NVARCHAR(MAX) OUTPUT,
	@ReturnEntities bit = 1,
	@MeasurementUnitsResultJson NVARCHAR(MAX) OUTPUT
AS
BEGIN
SET NOCOUNT ON;
DECLARE @IndexedIdsJson NVARCHAR(MAX), @IndexedIds dbo.[IndexedIdList];
-- Validate
	EXEC [dbo].[bll_MeasurementUnits_Save__Validate]
		@MeasurementUnits = @MeasurementUnits,
		@ValidationErrorsJson = @ValidationErrorsJson OUTPUT

	IF @ValidationErrorsJson IS NOT NULL
		RETURN;

	EXEC [dbo].[dal_MeasurementUnits__Save]
		@MeasurementUnits = @MeasurementUnits,
		@IndexedIdsJson = @IndexedIdsJson OUTPUT;

	IF (@ReturnEntities = 1)
	BEGIN
		INSERT INTO @IndexedIds([Index], [Id])
		SELECT [Index], [Id] 
		FROM OpenJson(@IndexedIdsJson)
		WITH ([Index] INT '$.Index', [Id] INT '$.Id');

		EXEC [dbo].[dal_MeasurementUnits__Select] 
			@IndexedIds = @IndexedIds, @MeasurementUnitsResultJson = @MeasurementUnitsResultJson OUTPUT;
	END
END;