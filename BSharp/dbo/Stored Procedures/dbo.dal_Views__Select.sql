CREATE PROCEDURE [dbo].[dal_Views__Select]
	@Ids [dbo].[ViewList] READONLY,
	@ViewsResultJson NVARCHAR(MAX) OUTPUT,
	@PermissionsResultJson NVARCHAR(MAX) OUTPUT
AS
	SELECT @ViewsResultJson = (
		SELECT *, N'Unchanged' As [EntityState]
		FROM [dbo].[Views]
		WHERE [Id] IN (SELECT [Id] FROM @Ids)
		FOR JSON PATH
	);

	SELECT @PermissionsResultJson = (
		SELECT *, N'Unchanged' As [EntityState]
		FROM [dbo].[Permissions]
		WHERE [ViewId] IN (
			SELECT [Id]
			FROM @Ids
		)
		FOR JSON PATH
	);