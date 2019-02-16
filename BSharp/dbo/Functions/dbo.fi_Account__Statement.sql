CREATE FUNCTION [dbo].[fi_Account__Statement] (-- SELECT * FROM [dbo].[ft_Account__Statement](N'CashOnHand', '01.01.2015', '01.01.2020')
	@AccountId INT,
	@OperationId INT = NULL,
	@CustodyId INT = NULL,
	@ResourceId INT = NULL,
	@fromDate Datetime = '01.01.2000', 
	@toDate Datetime = '01.01.2100'
) RETURNS TABLE
AS
RETURN
	SELECT 	
		Id,
		[DocumentType],
		SerialNumber As [Serial Number],
		StartDateTime,
		EndDateTime,
		EntryId,
		LineType,
		Direction,
		AccountId,
		OperationId,
		[AgentId],
		ResourceId,
		[Mass],
		[Volume],
		[Count],
		[Usage],
		[FCY],
		[Value],
		(CASE WHEN Direction > 0 THEN [Value] ELSE 0 END) AS Debit,
		(CASE WHEN Direction < 0 THEN [Value] ELSE 0 END) AS Credit,
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
	AND (@CustodyId IS NULL OR [AgentId] = @CustodyId)
	AND (@ResourceId IS NULL OR ResourceId = @ResourceId);