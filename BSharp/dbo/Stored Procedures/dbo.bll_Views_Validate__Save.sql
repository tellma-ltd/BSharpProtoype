CREATE PROCEDURE [dbo].[bll_Views_Validate__Save]
	@Views [dbo].[ViewList] READONLY,
	@Permissions [dbo].[PermissionList] READONLY,
	@ValidationErrorsJson NVARCHAR(MAX) OUTPUT
AS
SET NOCOUNT ON;
	DECLARE @ValidationErrors [dbo].[ValidationErrorList];
	DECLARE @Now DATETIMEOFFSET(7) = SYSDATETIMEOFFSET();

    INSERT INTO @ValidationErrors([Key], [ErrorName], [Argument1])
    SELECT '[' + CAST([Index] AS NVARCHAR (255)) + '].Id' As [Key], N'Error_CannotModifyInactiveItem' As [ErrorName], NULL As [Argument1]
    FROM @Views
    WHERE Id NOT IN (SELECT Id from [dbo].[Views] WHERE IsActive = 1)
	OPTION(HASH JOIN);

	-- No inactive role
	INSERT INTO @ValidationErrors([Key], [ErrorName], [Argument1], [Argument2], [Argument3], [Argument4], [Argument5]) 
	SELECT '[' + CAST(P.[HeaderIndex] AS NVARCHAR (255)) + '].Permissions[' + 
				CAST(P.[Index] AS NVARCHAR (255)) + '].RoleId' As [Key], N'Error_TheRole0IsInactive' As [ErrorName],
				P.[RoleId] AS Argument1, NULL AS Argument2, NULL AS Argument3, NULL AS Argument4, NULL AS Argument5
	FROM @Permissions P
	WHERE P.RoleId IN (
		SELECT [Id] FROM dbo.[Roles] WHERE IsActive = 0
		)
	AND (P.[EntityState] IN (N'Inserted', N'Updated'));

	SELECT @ValidationErrorsJson = (SELECT * FROM @ValidationErrors	FOR JSON PATH);