CREATE PROCEDURE [dbo].[api_MeasurementUnits__Activate]
	@IndexedIds [dbo].[IndexedIdList] READONLY,
	@ValidationErrorsJson NVARCHAR(MAX) = NULL OUTPUT,
	@ReturnEntities bit = 1,
	@MeasurementUnitsResultJson  NVARCHAR(MAX) OUTPUT
AS
SET NOCOUNT ON;
DECLARE @IndexedIdsJson NVARCHAR(MAX);

	EXEC [dbo].[dal_MeasurementUnits__Activate] @IndexedIds = @IndexedIds, @IsActive = 1

	IF (@ReturnEntities = 1)
	EXEC [dbo].[dal_MeasurementUnits__Select] 
			@IndexedIds = @IndexedIds, @MeasurementUnitsResultJson = @MeasurementUnitsResultJson OUTPUT
