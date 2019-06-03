CREATE PROCEDURE [dbo].[rpt_Account__Statement]
-- EXEC [dbo].[rpt_Account__Statement](104, '01.01.2015', '01.01.2020')
	@AccountId INT,
	@ResponsibilityCenterId INT = NULL,
	@AgentAccountId INT = NULL,
	@ResourceId INT = NULL,
	@fromDate Datetime = '01.01.2000', 
	@toDate Datetime = '01.01.2100'
AS
	SELECT 	
		[Id],
		[DocumentId],
		DocumentDate,
		[SerialNumber],
		[DocumentType],
		[IsSystem],
		[Direction],
		[AccountId],
		[IfrsAccountId],
		[IfrsNoteId],
		[ResponsibilityCenterId],
		-- [OperationId],
		-- [ProductCategoryId],
		-- [GeographicRegionId],
		-- [CustomerSegmentId],
		-- [TaxSegmentId],
		[AgentAccountId],
		[ResourceId],
		[Quantity],
		[MoneyAmount],
		[Mass],
		-- NormalizedMass,
		[Volume], 
		-- NormalizedVolume,
		[Count],
		-- NormalizedCount,
		[Time],
		[Value],
		[ExpectedSettlingDate],
		[Reference],
		[Memo],
		[RelatedReference],
		[RelatedResourceId],
		[RelatedAgentAccountId],
		[RelatedResponsibilityCenterId],
		[RelatedQuantity],
		[RelatedMoneyAmount],
		[RelatedMass],
		[RelatedVolume],
		[RelatedCount],
		[RelatedTime],
		[RelatedValue]
	FROM [dbo].[fi_Journal](@fromDate, @toDate)
	WHERE [AccountId] = @AccountId
	AND (@ResponsibilityCenterId IS NULL OR [ResponsibilityCenterId] = @ResponsibilityCenterId)
	AND (@AgentAccountId IS NULL OR	[AgentAccountId] = @AgentAccountId)
	AND (@ResourceId IS NULL OR ResourceId = @ResourceId);