CREATE PROCEDURE [dbo].[api_Roles__Activate]
	@Ids [dbo].[IntegerList] READONLY,
	@ValidationErrorsJson NVARCHAR(MAX) = NULL OUTPUT,
	@ReturnEntities bit = 1,
	@RolesResultJson NVARCHAR(MAX) OUTPUT,
	@PermissionsResultJson  NVARCHAR(MAX) OUTPUT
AS
SET NOCOUNT ON;
	EXEC [dbo].[dal_Roles__Activate] @Ids = @Ids, @IsActive = 1;

	IF (@ReturnEntities = 1)
		EXEC [dbo].[dal_Roles__Select] 
			@Ids = @Ids,
			@RolesResultJson = @RolesResultJson OUTPUT,
			@PermissionsResultJson = @PermissionsResultJson OUTPUT;