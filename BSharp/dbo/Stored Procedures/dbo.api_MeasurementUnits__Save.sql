CREATE PROCEDURE [dbo].[api_MeasurementUnits__Save]
	@MeasurementUnits [MeasurementUnitForSaveList] READONLY,
	@ValidationErrorsJson NVARCHAR(MAX) OUTPUT,
	@IndexedIdsJson NVARCHAR(MAX) OUTPUT
AS
BEGIN
SET NOCOUNT ON;
-- Validate
	EXEC [dbo].[bll_MeasurementUnits__Validate]
		@MeasurementUnits = @MeasurementUnits,
		@ValidationErrorsJson = @ValidationErrorsJson OUTPUT

	IF @ValidationErrorsJson IS NOT NULL
		RETURN;

	EXEC [dbo].[dal_MeasurementUnits__Save]
		@MeasurementUnits = @MeasurementUnits,
		@IndexedIdsJson = @IndexedIdsJson OUTPUT
END;