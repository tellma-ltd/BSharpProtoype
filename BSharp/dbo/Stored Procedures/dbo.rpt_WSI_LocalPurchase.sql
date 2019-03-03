CREATE PROCEDURE [dbo].[rpt_WSI_LocalPurchase]
/*
Assumptions:
Can we assume that purchases are marked as expenses and the supplier is stored in the related agent column.
*/
	@fromDate Datetime = '01.01.2020',
	@toDate Datetime = '01.01.2020'
AS
	WITH
	ExpenseJournal AS (
		SELECT J.[ResponsibilityCenterId], J.[IFRSAccountConcept], O.[Name], O.[Name2],
			SUM(J.[Direction] * J.[Value]) AS [Expense]
		FROM [dbo].[fi_Journal](@fromDate, @toDate) J
		JOIN dbo.[ResponsibilityCenters] O ON J.[ResponsibilityCenterId] = O.Id
--		JOIN dbo.Agents A ON J.RelatedAgentId = A.Id
		WHERE J.[IFRSAccountConcept] IN (
		-- No IFRS? WHERE AccountType IN (
		-- We need to include only IndirectCostOfSales?
			N'CostOfSales', N'DistributionCosts', N'AdministrativeExpense', N'OtherExpenseByFunction'
		)
	--	AND A.RelationType = N'supplier'
		GROUP BY J.[ResponsibilityCenterId], J.[IFRSAccountConcept], O.[Name], O.[Name2]
	)
	SELECT * FROM ExpenseJournal
	PIVOT (
		SUM([Expense])
		FOR [IFRSAccountConcept] IN (
			[CostOfSales], [DistributionCosts], [AdministrativeExpense], [OtherExpenseByFunction]
		)
	) AS pvt;