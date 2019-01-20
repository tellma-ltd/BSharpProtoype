CREATE FUNCTION [dbo].[fi_MyNotifications]()
RETURNS TABLE
AS
RETURN
	SELECT *
	FROM [dbo].Notifications
	WHERE RecipientId = (
			SELECT [AgentId]
			FROM dbo.Users 
			WHERE [Id] = CONVERT(NVARCHAR(450), SESSION_CONTEXT(N'UserId'))
		);