CREATE PROCEDURE [dbo].[api_Views__Activate]
	@Ids [dbo].[ViewList] READONLY,
	@ValidationErrorsJson NVARCHAR(MAX) = NULL OUTPUT,
	@ReturnEntities bit = 1,
	@ViewsResultJson NVARCHAR(MAX) OUTPUT,
	@PermissionsResultJson  NVARCHAR(MAX) OUTPUT
AS
SET NOCOUNT ON;
	EXEC [dbo].[dal_Views__Activate] @Ids = @Ids, @IsActive = 1;

	IF (@ReturnEntities = 1)
		EXEC [dbo].[dal_Views__Select] 
			@Ids = @Ids,
			@ViewsResultJson = @ViewsResultJson OUTPUT,
			@PermissionsResultJson = @PermissionsResultJson OUTPUT;