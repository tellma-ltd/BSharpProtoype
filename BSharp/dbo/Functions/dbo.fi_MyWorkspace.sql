CREATE FUNCTION [dbo].[fi_MyWorkspace] ()
RETURNS TABLE
AS
RETURN
	SELECT A.Comment, A.AssignedBy, A.AssignedAt, D.DocumentType, D.SerialNumber
	FROM [dbo].Documents D
	JOIN dbo.Assignments A ON A.DocumentId = D.Id
	WHERE A.AssigneeId = CONVERT(NVARCHAR(450), SESSION_CONTEXT(N'UserId'));