CREATE PROCEDURE [dbo].[api_Agents__Save]
	@Agents [AgentForSaveList] READONLY,
	@ValidationErrorsJson NVARCHAR(MAX) OUTPUT,
	@ReturnEntities bit = 1,
	@AgentsResultJson  NVARCHAR(MAX) OUTPUT
AS
BEGIN
SET NOCOUNT ON;
DECLARE @IndexedIdsJson NVARCHAR(MAX);

-- Validate
	EXEC [dbo].[bll_Agents__Validate]
		@Agents = @Agents,
		@ValidationErrorsJson = @ValidationErrorsJson OUTPUT

	IF @ValidationErrorsJson IS NOT NULL
		RETURN;

	EXEC [dbo].[dal_Agents__Save]
		@Agents = @Agents,
		@IndexedIdsJson = @IndexedIdsJson OUTPUT
	
	IF (@ReturnEntities = 1)
		EXEC [dbo].[dal_Agents__Select] 
			@IndexedIdsJson = @IndexedIdsJson, @AgentsResultJson = @AgentsResultJson OUTPUT
END

	
