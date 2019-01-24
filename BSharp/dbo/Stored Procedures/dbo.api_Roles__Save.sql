CREATE PROCEDURE [dbo].[api_Roles__Save]
	@Roles [dbo].[RoleList] READONLY,
	@Permissions [dbo].[PermissionList] READONLY, 
	@ValidationErrorsJson NVARCHAR(MAX) OUTPUT,
	@ReturnEntities bit = 1,
	@RolesResultJson NVARCHAR(MAX) OUTPUT,
	@PermissionsResultJson NVARCHAR(MAX) OUTPUT
AS
BEGIN
DECLARE @IndexedIdsJson NVARCHAR(MAX), @Ids [dbo].[IntegerList];
DECLARE @RolesLocal [dbo].[RoleList] , @PermissionsLocal [dbo].[PermissionList];
DECLARE @RolesLocalResultJson NVARCHAR(MAX), @PermissionsLocalResultJson NVARCHAR(MAX);
	--Validate Domain rules
	EXEC [dbo].[bll_Roles_Validate__Save]
		@Roles = @Roles,
		@Permissions = @Permissions,
		@ValidationErrorsJson = @ValidationErrorsJson OUTPUT;

	IF @ValidationErrorsJson IS NOT NULL
		RETURN;

	-- Validate business rules (read from the table)

	EXEC [dbo].[dal_Roles__Save]
		@Roles = @Roles,
		@Permissions = @Permissions,
		@IndexedIdsJson = @IndexedIdsJson OUTPUT;

	IF (@ReturnEntities = 1)
	BEGIN
		INSERT INTO @Ids([Id])
		SELECT [Id] 
		FROM OpenJson(@IndexedIdsJson) WITH ([Index] INT, [Id] INT);

		EXEC [dbo].[dal_Roles__Select] 
			@Ids = @Ids, 
			@RolesResultJson = @RolesResultJson OUTPUT,
			@PermissionsResultJson = @PermissionsResultJson OUTPUT;
	END;
END;