CREATE FUNCTION [dbo].[fi_MyWorkspaceHistory]()
RETURNS TABLE
AS
RETURN
	SELECT DAH.Comment, DAH.AssigneeId, DAH.[CreatedAt], D.[DocumentType], D.[TransactionType], D.SerialNumber
	FROM [dbo].Documents D
	JOIN dbo.[DocumentAssignmentsHistory] DAH ON DAH.DocumentId = D.Id
	WHERE DAH.AssigneeId = CONVERT(INT, SESSION_CONTEXT(N'UserId'));