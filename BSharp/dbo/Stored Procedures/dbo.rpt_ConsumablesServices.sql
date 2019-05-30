CREATE PROCEDURE [dbo].[rpt_ConsumablesServices]
/*
Assumptions:
Can we assume that purchases are marked as expenses and the supplier is stored in the related agent column.
*/
	@fromDate Datetime = '01.01.2020',
	@toDate Datetime = '01.01.2020'
AS
	WITH
	ExpenseJournal AS (
		SELECT J.[ResponsibilityCenterId], J.[IfrsAccountId], O.[Name], O.[Name2], O.[Name3],
			SUM(J.[Direction] * J.[Value]) AS [Expense]
		FROM [dbo].[fi_Journal](@fromDate, @toDate) J
		JOIN dbo.[ResponsibilityCenters] O ON J.[ResponsibilityCenterId] = O.Id
--		JOIN dbo.Agents A ON J.RelatedAgentId = A.Id
		WHERE J.[IfrsAccountId] IN (
			N'CostOfSales', N'DistributionCosts', N'AdministrativeExpense', N'OtherExpenseByFunction'
		)
	--	AND A.RelationType = N'supplier'
		GROUP BY J.[ResponsibilityCenterId], J.[IfrsAccountId], O.[Name], O.[Name2], O.[Name3]
	)
	SELECT * FROM ExpenseJournal
	PIVOT (
		SUM([Expense])
		FOR [IfrsAccountId] IN (
			[CostOfSales], [DistributionCosts], [AdministrativeExpense], [OtherExpenseByFunction]
		)
	) AS pvt;