CREATE PROCEDURE [dbo].[dal_Roles__Select]
	@Ids [dbo].[IntegerList] READONLY,
	@RolesResultJson NVARCHAR(MAX) OUTPUT,
	@PermissionsResultJson NVARCHAR(MAX) OUTPUT
AS
	SELECT @RolesResultJson = (
		SELECT *, N'Unchanged' As [EntityState]
		FROM [dbo].[Roles]
		WHERE [Id] IN (SELECT [Id] FROM @Ids)
		FOR JSON PATH
	);

	SELECT @PermissionsResultJson = (
		SELECT *, N'Unchanged' As [EntityState]
		FROM [dbo].[Permissions]
		WHERE [RoleId] IN (
			SELECT [Id]
			FROM @Ids
		)
		FOR JSON PATH
	);