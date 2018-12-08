CREATE PROCEDURE [dbo].[api_MeasurementUnits__Activate]
	@ActivationList [ActivationList] READONLY,
	--@ValidationErrorsJson NVARCHAR(MAX) OUTPUT,
	@ReturnEntities bit = 1,
	@MeasurementUnitsResultJson  NVARCHAR(MAX) OUTPUT
AS
SET NOCOUNT ON;
DECLARE @IndexedIdsJson NVARCHAR(MAX);

	EXEC [dbo].[bll_MeasurementUnits__Activate]
		@ActivationList = @ActivationList,
		@IndexedIdsJson = @IndexedIdsJson OUTPUT

	IF (@ReturnEntities = 1)
	EXEC [dbo].[dal_MeasurementUnits__Select] 
			@IndexedIdsJson = @IndexedIdsJson, @MeasurementUnitsResultJson = @MeasurementUnitsResultJson OUTPUT
