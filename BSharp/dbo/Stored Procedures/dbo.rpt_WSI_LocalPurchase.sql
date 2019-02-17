CREATE PROCEDURE [dbo].[rpt_WSI_LocalPurchase]
/*
Assumptions:
1) Any inventory account is mapped to IFRS concepts: Inventories, NonCurrentinventories, or their descendants
2) All entries use a raw material resource. For balance migration, we need to add for every inventory account
	a resource called non-specified (for that account), and migrate balances to it.

*/
	@fromDate Datetime = '01.01.2020',
	@toDate Datetime = '01.01.2020'
AS
	WITH
	ExpenseJournal AS (
		SELECT J.OperationId, J.IFRSConceptId, O.[Name], O.[Name2],
			SUM(J.[Direction] * J.[Value]) AS [Expense]
		FROM [dbo].[fi_Journal](@fromDate, @toDate) J
		JOIN dbo.Operations O ON J.OperationId = O.Id
		WHERE J.IFRSConceptId IN (
		-- No IFRS? WHERE AccountType IN (
		-- We need to include only IndirectCostOfSales?
			N'CostOfSales', N'DistributionCosts', N'AdministrativeExpense', N'OtherExpenseByFunction'
		)
		GROUP BY J.OperationId, J.IFRSConceptId, O.[Name], O.[Name2]
	)
	SELECT * FROM ExpenseJournal
	PIVOT (
		SUM([Expense])
		FOR IFRSConceptId IN (
			[CostOfSales], [DistributionCosts], [AdministrativeExpense], [OtherExpenseByFunction]
		)
	) AS pvt;