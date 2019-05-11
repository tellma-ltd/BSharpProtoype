CREATE FUNCTION [dbo].[fi_Agents] (
	@AgentRelationType NVARCHAR (255),
	@IsActive BIT = NULL
) RETURNS TABLE
AS
RETURN
	SELECT * FROM [dbo].[Agents]
	WHERE [Id] IN (
		SELECT [AgentId]
		FROM dbo.AgentAccounts
		WHERE (@AgentRelationType IS NULL OR [AgentRelationType] = @AgentRelationType)
		AND (@IsActive IS NULL OR [IsActive] = @IsActive)
	);