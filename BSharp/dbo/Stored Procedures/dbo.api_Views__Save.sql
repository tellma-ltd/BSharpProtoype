CREATE PROCEDURE [dbo].[api_Views__Save]
	@Views [dbo].[ViewList] READONLY,
	@Permissions [dbo].[PermissionList] READONLY, 
	@ValidationErrorsJson NVARCHAR(MAX) OUTPUT,
	@ReturnEntities bit = 1,
	@ViewsResultJson NVARCHAR(MAX) OUTPUT,
	@PermissionsResultJson NVARCHAR(MAX) OUTPUT
AS
BEGIN
DECLARE @ViewsLocal [dbo].[ViewList] , @PermissionsLocal [dbo].[PermissionList];
DECLARE @ViewsLocalResultJson NVARCHAR(MAX), @PermissionsLocalResultJson NVARCHAR(MAX);
	--Validate Domain rules
	EXEC [dbo].[bll_Views_Validate__Save]
		@Views = @Views,
		@Permissions = @Permissions,
		@ValidationErrorsJson = @ValidationErrorsJson OUTPUT;

	IF @ValidationErrorsJson IS NOT NULL
		RETURN;

	EXEC [dbo].[dal_Views__Save]
		@Views = @Views,
		@Permissions = @Permissions;

	IF (@ReturnEntities = 1)
		EXEC [dbo].[dal_Views__Select] 
			@Ids = @Views, 
			@ViewsResultJson = @ViewsResultJson OUTPUT,
			@PermissionsResultJson = @PermissionsResultJson OUTPUT;
END;