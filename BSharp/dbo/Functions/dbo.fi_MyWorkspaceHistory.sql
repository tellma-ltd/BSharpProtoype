CREATE FUNCTION [dbo].[fi_MyWorkspaceHistory]()
RETURNS TABLE
AS
RETURN
	SELECT A.Comment, A.AssignedBy, A.[CreatedAt], D.[TransactionType], D.SerialNumber
	FROM [dbo].Documents D
	JOIN dbo.[DocumentAssignmentsHistory] A ON A.DocumentId = D.Id
	WHERE A.AssigneeId = CONVERT(INT, SESSION_CONTEXT(N'UserId'));