CREATE PROCEDURE [dbo].[rpt_BankAccount__Statement]
-- EXEC [dbo].[rpt_BankAccount__Statement](104, '01.01.2015', '01.01.2020')
	@AccountId INT,
--	@AgentAccountId INT = NULL,
--	@ResourceId INT = NULL,
	@fromDate Datetime = '01.01.2000', 
	@toDate Datetime = '01.01.2100'
AS
	SELECT 	
		[Id],
		[DocumentId],
		[DocumentDate],
		[SerialNumber],
		[DocumentType],
		[IsSystem],
		[Direction],
--		[AccountId],
		[IfrsNoteId],
		[ResponsibilityCenterId],
		-- [OperationId],
		-- [ProductCategoryId],
		-- [GeographicRegionId],
		-- [CustomerSegmentId],
		-- [TaxSegmentId],
--		[AgentAccountId],
		[ResourceId],
		[Quantity],
--		[MoneyAmount],
		[Value],
		[ExpectedSettlingDate] As [DocumentExpiryDate],
		[Reference] As [CPV_CRV_Ref],
		[Memo],
		[RelatedReference] As [CheckRef],
		[RelatedResourceId] As [OtherPartyCurrency],
		[RelatedAgentAccountId] As [OtherParty],
		[RelatedMoneyAmount] As [OtherPartyAmount]
--		[RelatedValue]
	FROM [dbo].[fi_Journal](@fromDate, @toDate)
	WHERE [IfrsAccountId] = N'BalancesWithBanks'
	AND [AccountId] = @AccountId
	--AND (@AgentAccountId IS NULL OR	[AgentAccountId] = @AgentAccountId)
	--AND (@ResourceId IS NULL OR ResourceId = @ResourceId);