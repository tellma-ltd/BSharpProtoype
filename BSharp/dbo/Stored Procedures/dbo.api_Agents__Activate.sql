CREATE PROCEDURE [dbo].[api_Agents__Activate]
	@ActivationList [ActivationList] READONLY,
	--@ValidationErrorsJson NVARCHAR(MAX) OUTPUT,
	@ReturnEntities bit = 1,
	@AgentsResultJson  NVARCHAR(MAX) OUTPUT
AS
SET NOCOUNT ON;
DECLARE @IndexedIdsJson NVARCHAR(MAX);

	EXEC [dbo].[dal_Custodies__Activate]
		@ActivationList = @ActivationList,
		@IndexedIdsJson = @IndexedIdsJson OUTPUT

	IF (@ReturnEntities = 1)
	EXEC [dbo].[dal_Agents__Select] 
			@IndexedIdsJson = @IndexedIdsJson, @AgentsResultJson = @AgentsResultJson OUTPUT
