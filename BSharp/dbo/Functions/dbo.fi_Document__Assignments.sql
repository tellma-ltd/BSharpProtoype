CREATE FUNCTION [dbo].[fi_Document__Assignments] (
	@DocumentId INT
)
RETURNS TABLE
AS
RETURN
	SELECT 	[AssigneeId], [Comment], [AssignedBy], [AssignedAt], [OpenedAt]
	FROM [dbo].Assignments
	WHERE DocumentId = @DocumentId;