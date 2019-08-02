CREATE FUNCTION [dbo].[fi_MyNotifications]()
RETURNS TABLE
AS
RETURN
	SELECT *
	FROM [dbo].Notifications
	WHERE RecipientId = (
		SELECT [AgentId]
		FROM dbo.LocalUsers 
		WHERE [Id] = CONVERT(UNIQUEIDENTIFIER, SESSION_CONTEXT(N'UserId'))
	);