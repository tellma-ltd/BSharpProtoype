CREATE PROCEDURE [dbo].[api_MeasurementUnits__Save]
	@MeasurementUnits [MeasurementUnitForSaveList] READONLY,
	@ValidationErrorsJson NVARCHAR(MAX) OUTPUT,
	@ReturnEntities bit = 1,
	@MeasurementUnitsResultJson  NVARCHAR(MAX) OUTPUT
AS
BEGIN
SET NOCOUNT ON;
DECLARE @IndexedIdsJson NVARCHAR(MAX);
-- Validate
	EXEC [dbo].[bll_MeasurementUnits__Validate]
		@MeasurementUnits = @MeasurementUnits,
		@ValidationErrorsJson = @ValidationErrorsJson OUTPUT

	IF @ValidationErrorsJson IS NOT NULL
		RETURN;

	EXEC [dbo].[dal_MeasurementUnits__Save]
		@MeasurementUnits = @MeasurementUnits,
		@IndexedIdsJson = @IndexedIdsJson OUTPUT

	IF (@ReturnEntities = 1)
		EXEC [dbo].[dal_MeasurementUnits__Select] 
			@IndexedIdsJson = @IndexedIdsJson, @MeasurementUnitsResultJson = @MeasurementUnitsResultJson OUTPUT
END;