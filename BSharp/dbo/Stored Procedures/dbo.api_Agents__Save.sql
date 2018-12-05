CREATE PROCEDURE [dbo].[api_Agents__Save]
	@Agents [AgentForSaveList] READONLY,
	@ValidationErrorsJson NVARCHAR(MAX) OUTPUT,
	@IndexedIdsJson NVARCHAR(MAX) OUTPUT
AS
BEGIN
SET NOCOUNT ON;
-- Validate
	EXEC [dbo].[bll_Agents__Validate]
		@Agents = @Agents,
		@ValidationErrorsJson = @ValidationErrorsJson OUTPUT

	IF @ValidationErrorsJson IS NOT NULL
		RETURN;

	EXEC [dbo].[dal_Agents__Save]
		@Agents = @Agents,
		@IndexedIdsJson = @IndexedIdsJson OUTPUT
END;