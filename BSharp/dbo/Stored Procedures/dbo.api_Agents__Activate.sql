CREATE PROCEDURE [dbo].[api_Agents__Activate]
	@Ids [dbo].[IntegerList] READONLY,
	@ValidationErrorsJson NVARCHAR(MAX) = NULL OUTPUT,
	@ReturnEntities bit = 1,
	@EntitiesResultJson NVARCHAR(MAX) OUTPUT
AS
SET NOCOUNT ON;
	EXEC [dbo].[dal_Custodies__Activate] @Ids = @Ids, @IsActive = 1;

	IF (@ReturnEntities = 1)
		EXEC [dbo].[dal_Agents__Select] 
			@Ids = @Ids,
			@EntitiesResultJson = @EntitiesResultJson OUTPUT;