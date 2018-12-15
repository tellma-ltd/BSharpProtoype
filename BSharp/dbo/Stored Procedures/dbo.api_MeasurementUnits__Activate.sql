CREATE PROCEDURE [dbo].[api_MeasurementUnits__Activate]
	@IndexedIds [dbo].[IndexedIdList] READONLY,
	@ValidationErrorsJson NVARCHAR(MAX) = NULL OUTPUT,
	@ReturnEntities bit = 1,
	@EntitiesResultJson NVARCHAR(MAX) OUTPUT
AS
SET NOCOUNT ON;
DECLARE @Ids [dbo].[IntegerList];
	INSERT INTO @Ids([Id]) (SELECT [Id] FROM @IndexedIds);

	EXEC [dbo].[dal_MeasurementUnits__Activate] @Ids = @Ids, @IsActive = 1

	IF (@ReturnEntities = 1)
		EXEC [dbo].[dal_MeasurementUnits__Select] 
				@IndexedIds = @IndexedIds,
				@EntitiesResultJson = @EntitiesResultJson OUTPUT
