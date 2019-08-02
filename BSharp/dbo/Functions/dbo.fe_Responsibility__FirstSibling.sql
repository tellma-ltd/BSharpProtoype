CREATE FUNCTION [dbo].[fe_ResponsibilityCenter__FirstSibling] ( -- TODO: still needed?
	@OperationId UNIQUEIDENTIFIER
)
RETURNS UNIQUEIDENTIFIER
AS
BEGIN
	RETURN 
	CASE WHEN (
		SELECT ParentId 
		FROM dbo.[ResponsibilityCenters] 
		WHERE [Id] = @OperationId
	) IS NULL THEN (
		SELECT MIN([Id]) FROM dbo.[ResponsibilityCenters]
		WHERE ParentId IS NULL
	)
	ELSE (
		SELECT MIN([Id]) FROM dbo.[ResponsibilityCenters]
		WHERE ParentId = (
			SELECT ParentId 
			FROM dbo.[ResponsibilityCenters] 
			WHERE [Id] = @OperationId
		)
	) END;
END;