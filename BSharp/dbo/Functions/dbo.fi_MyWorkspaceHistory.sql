CREATE FUNCTION [dbo].[fi_MyWorkspaceHistory]()
RETURNS TABLE
AS
RETURN
	SELECT A.Comment, A.AssignedBy, A.AssignedAt, D.DocumentType, D.SerialNumber
	FROM [dbo].Documents D
	JOIN dbo.AssignmentsHistory A ON A.DocumentId = D.Id
	WHERE A.AssigneeId = CONVERT(INT, SESSION_CONTEXT(N'UserId'));