CREATE PROCEDURE [dbo].[rpt_NegativeInventories]
	@AsOfDate Datetime = '01.01.2020'
AS
WITH IFRSInventoryAccounts
AS
(
	SELECT Id FROM dbo.[IFRSAccounts]
	WHERE [Node].IsDescendantOf(
		(SELECT [Node] FROM dbo.IFRSAccounts WHERE Id = N'Inventories')
	) = 1
)
	SELECT
			[AccountId],
			[IFRSAccountId],
			[ResponsibilityCenterId],
			-- [OperationId],
			-- [ProductCategoryId],
			-- [GeographicRegionId],
			-- [CustomerSegmentId],
			-- [TaxSegmentId],
			[AgentAccountId],
			[ResourceId],
			SUM([Mass]) AS [Mass],
			SUM([Volume]) As [Volume],
			SUM([Count]) AS [Count],
			SUM([Value]) As [Value]
	FROM dbo.fi_Journal(NULL, @AsOfDate) J
	WHERE IFRSAccountId IN (SELECT Id FROM IFRSInventoryAccounts)
	GROUP BY
			[AccountId],
			[IFRSAccountId],
			[ResponsibilityCenterId],
			-- [OperationId],
			-- [ProductCategoryId],
			-- [GeographicRegionId],
			-- [CustomerSegmentId],
			-- [TaxSegmentId],
			[AgentAccountId],
			[ResourceId]
	HAVING
			SUM([Mass]) < 0 OR SUM([Volume]) < 0 OR SUM([Count]) < 0
	;