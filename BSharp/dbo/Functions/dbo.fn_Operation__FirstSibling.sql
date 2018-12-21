CREATE FUNCTION [dbo].[fn_Operation__FirstSibling]
(
	@OperationId int
)
RETURNS INT
AS
BEGIN
	RETURN 
	CASE WHEN (
		SELECT ParentId 
		FROM dbo.Operations 
		WHERE [Id] = @OperationId
	) IS NULL THEN (
		SELECT MIN([Id]) FROM dbo.Operations
		WHERE ParentId IS NULL
	)
	ELSE (
		SELECT MIN([Id]) FROM dbo.Operations
		WHERE ParentId = (
			SELECT ParentId 
			FROM dbo.Operations 
			WHERE [Id] = @OperationId
		)
	) END;
END
