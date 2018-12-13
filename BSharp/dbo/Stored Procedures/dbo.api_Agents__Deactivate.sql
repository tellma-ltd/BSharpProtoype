CREATE PROCEDURE [dbo].[api_Agents__Deactivate]
	@IndexedIds [dbo].[IndexedIdList] READONLY,
	@ValidationErrorsJson NVARCHAR(MAX) = NULL OUTPUT,
	@ReturnEntities bit = 1,
	@AgentsResultJson NVARCHAR(MAX) OUTPUT
AS
SET NOCOUNT ON;
	EXEC [dbo].[dal_Custodies__Activate] @IndexedIds = @IndexedIds, @IsActive = 0;

	IF (@ReturnEntities = 1)
	EXEC [dbo].[dal_Agents__Select] 
			@IndexedIds = @IndexedIds, @AgentsResultJson = @AgentsResultJson OUTPUT;
