CREATE FUNCTION [dbo].[fi_Account__Statement] (-- SELECT * FROM [dbo].[ft_Account__Statement](N'CashOnHand', '01.01.2015', '01.01.2020')
	@AccountId INT,
	@OperationId INT = NULL,
	@AgentId INT = NULL,
	@AgentAccountId INT = NULL,
	@ResourceId INT = NULL,
	@fromDate Datetime = '01.01.2000', 
	@toDate Datetime = '01.01.2100'
) RETURNS TABLE
AS
RETURN
	SELECT 	
		[DocumentId],
		[DocumentType],
		[SerialNumber] As [Serial Number],
		[DocumentDateTime],
		[EntryId],
		[LineType],
		[Direction],
		[AccountId],
		[OperationId],
		[AgentId],
		[AgentAccountId],
		[ResourceId],
		[MoneyAmount],
		[Mass],
		[Volume],
		[Count],
		[ServiceTime],
		[ServiceCount],
		[ServiceDistance],
		[Value],
		[NoteId],
		[Reference],
		[Memo],
		[ExpectedClosingDate],
		[RelatedResourceId],
		[RelatedReference],
		[RelatedAgentId],
		[RelatedAmount]
	FROM [dbo].[fi_Journal](@fromDate, @toDate)
	WHERE [AccountId] = @AccountId
	AND (@OperationId IS NULL OR OperationId = @OperationId)
	AND (@AgentId IS NULL OR [AgentId] = @AgentId)
	AND (@AgentAccountId IS NULL OR	[AgentAccountId] = @AgentAccountId)
	AND (@ResourceId IS NULL OR ResourceId = @ResourceId);