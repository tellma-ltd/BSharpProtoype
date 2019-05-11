CREATE FUNCTION [dbo].[fn_Operation__FirstSibling] ( -- TODO: still needed?
	@OperationId int
)
RETURNS INT
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