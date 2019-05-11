CREATE FUNCTION [dbo].[fi_Account__Statement] (
-- SELECT * FROM [dbo].[ft_Account__Statement](104, '01.01.2015', '01.01.2020')
	@AccountId INT,
	@ResponsibilityCenterId INT = NULL,
	@AgentAccountId INT = NULL,
	@ResourceId INT = NULL,
	@fromDate Datetime = '01.01.2000', 
	@toDate Datetime = '01.01.2100'
) RETURNS TABLE
AS
RETURN
	SELECT 	
		[DocumentId],
		[TransactionType],
		[SerialNumber] As [Serial Number],
		[DocumentDate],
		[EntryId],
		[Direction],
		[AccountId],
		[ResponsibilityCenterId],
		[AgentAccountId],
		[ResourceId],
		[MoneyAmount],
		[Mass],
		[Volume],
		[Count],
		[Time],
		[Value],
		[IFRSNoteId],
		[Reference],
		[Memo],
		[ExpectedSettlingDate],
		[RelatedResourceId],
		[RelatedReference],
		[RelatedAgentAccountId],
		[RelatedMoneyAmount]
	FROM [dbo].[fi_Journal](@fromDate, @toDate)
	WHERE [AccountId] = @AccountId
	AND (@ResponsibilityCenterId IS NULL OR [ResponsibilityCenterId] = @ResponsibilityCenterId)
	AND (@AgentAccountId IS NULL OR	[AgentAccountId] = @AgentAccountId)
	AND (@ResourceId IS NULL OR ResourceId = @ResourceId);