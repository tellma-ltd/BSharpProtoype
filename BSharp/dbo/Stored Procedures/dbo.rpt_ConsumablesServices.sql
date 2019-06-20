CREATE PROCEDURE [dbo].[rpt_ConsumablesServices]
	@fromDate Datetime = '01.01.2020',
	@toDate Datetime = '01.01.2020'
AS
	WITH
	ExpenseJournal AS (
		SELECT J.[ResponsibilityCenterId], J.[IfrsNoteId], O.[Name], O.[Name2], O.[Name3],
			SUM(J.[Direction] * J.[Value]) AS [Expense]
		FROM [dbo].[fi_JournalDetails](@fromDate, @toDate) J
		JOIN dbo.[ResponsibilityCenters] O ON J.[ResponsibilityCenterId] = O.Id
		WHERE J.[IfrsNoteId] IN (
			N'CostOfSales',
			N'DistributionCosts',
			N'AdministrativeExpense',
			N'OtherExpenseByFunction'
		)
		GROUP BY J.[ResponsibilityCenterId], J.[IfrsNoteId], O.[Name], O.[Name2], O.[Name3]
	)
	SELECT * FROM ExpenseJournal
	PIVOT (
		SUM([Expense])
		FOR [IfrsNoteId] IN (
			[CostOfSales], [DistributionCosts], [AdministrativeExpense], [OtherExpenseByFunction]
		)
	) AS pvt;