DECLARE @LineTypeSpecifications TABLE (
	[LineType]					NVARCHAR (255),
	[AppendSQL]					NVARCHAR (MAX) SPARSE,
-- For Account, It might be better to use normalized version: Transaction Type, Resource Type, etc, and conclude the IFRS accordingly.
	[Operation1Label]			NVARCHAR (255) SPARSE,
	[Operation1FillSQL]			NVARCHAR (MAX) SPARSE,
	[AccountId1Label]				NVARCHAR (255) SPARSE,
	[AccountId1FillSQL]			NVARCHAR (MAX) SPARSE,
	[CustodyId1Label]				NVARCHAR (255) SPARSE,
	[CustodyId1FillSQL]			NVARCHAR (MAX) SPARSE,
	[ResourceId1Label]			NVARCHAR (255) SPARSE,
	[ResourceId1FillSQL]			NVARCHAR (MAX) SPARSE,
	[Direction1Label]			NVARCHAR (255) SPARSE,
	[Direction1FillSQL]			NVARCHAR (MAX) SPARSE,
	[Amount1Label]				NVARCHAR (255) SPARSE,
	[Amount1FillSQL]			NVARCHAR (MAX) SPARSE,
	[Value1Label]				NVARCHAR (255) SPARSE,
	[Value1FillSQL]				NVARCHAR (MAX) SPARSE,
	[NoteId1Label]				NVARCHAR (255) SPARSE,
	[NoteId1FillSQL]				NVARCHAR (MAX) SPARSE,
	[Reference1Label]			NVARCHAR (255) SPARSE,
	[Reference1FillSQL]			NVARCHAR (MAX) SPARSE,
	[RelatedReference1Label]	NVARCHAR (255) SPARSE,
	[RelatedReference1FillSQL]	NVARCHAR (MAX) SPARSE,
	[RelatedAgentId1Label]		NVARCHAR (255) SPARSE,
	[RelatedAgentId1FillSQL]		NVARCHAR (MAX) SPARSE,
	[RelatedResourceId1Label]		NVARCHAR (255) SPARSE,
	[RelatedResourceId1FillSQL]	NVARCHAR (MAX) SPARSE,
	[RelatedAmount1Label]		NVARCHAR (255) SPARSE,
	[RelatedAmount1FillSQL]		NVARCHAR (MAX) SPARSE,
-- Entry 2
	[Operation2Label]			NVARCHAR (255) SPARSE,
	[Operation2FillSQL]			NVARCHAR (MAX) SPARSE,
	[AccountId2Label]				NVARCHAR (255) SPARSE,
	[AccountId2FillSQL]			NVARCHAR (MAX) SPARSE,
	[CustodyId2Label]				NVARCHAR (255) SPARSE,
	[CustodyId2FillSQL]			NVARCHAR (MAX) SPARSE,
	[ResourceId2Label]			NVARCHAR (255) SPARSE,
	[ResourceId2FillSQL]			NVARCHAR (MAX) SPARSE,
	[Direction2Label]			NVARCHAR (255) SPARSE,
	[Direction2FillSQL]			NVARCHAR (MAX) SPARSE,
	[Amount2Label]				NVARCHAR (255) SPARSE,
	[Amount2FillSQL]			NVARCHAR (MAX) SPARSE,
	[Value2Label]				NVARCHAR (255) SPARSE,
	[Value2FillSQL]				NVARCHAR (MAX) SPARSE,
	[NoteId2Label]				NVARCHAR (255) SPARSE,
	[NoteId2FillSQL]				NVARCHAR (MAX) SPARSE,
	[Reference2Label]			NVARCHAR (255) SPARSE,
	[Reference2FillSQL]			NVARCHAR (MAX) SPARSE,
	[RelatedReference2Label]	NVARCHAR (255) SPARSE,
	[RelatedReference2FillSQL]	NVARCHAR (MAX) SPARSE,
	[RelatedAgentId2Label]		NVARCHAR (255) SPARSE,
	[RelatedAgentId2FillSQL]		NVARCHAR (MAX) SPARSE,
	[RelatedResourceId2Label]		NVARCHAR (255) SPARSE,
	[RelatedResourceId2FillSQL]	NVARCHAR (MAX) SPARSE,
	[RelatedAmount2Label]		NVARCHAR (255) SPARSE,
	[RelatedAmount2FillSQL]		NVARCHAR (MAX) SPARSE,
-- Entry 3
	[Operation3Label]			NVARCHAR (255) SPARSE,
	[Operation3FillSQL]			NVARCHAR (MAX) SPARSE,
	[AccountId3Label]				NVARCHAR (255) SPARSE,
	[AccountId3FillSQL]			NVARCHAR (MAX) SPARSE,
	[CustodyId3Label]				NVARCHAR (255) SPARSE,
	[CustodyId3FillSQL]			NVARCHAR (MAX) SPARSE,
	[ResourceId3Label]			NVARCHAR (255) SPARSE,
	[ResourceId3FillSQL]			NVARCHAR (MAX) SPARSE,
	[Direction3Label]			NVARCHAR (255) SPARSE,
	[Direction3FillSQL]			NVARCHAR (MAX) SPARSE,
	[Amount3Label]				NVARCHAR (255) SPARSE,
	[Amount3FillSQL]			NVARCHAR (MAX) SPARSE,
	[Value3Label]				NVARCHAR (255) SPARSE,
	[Value3FillSQL]				NVARCHAR (MAX) SPARSE,
	[NoteId3Label]				NVARCHAR (255) SPARSE,
	[NoteId3FillSQL]				NVARCHAR (MAX) SPARSE,
	[Reference3Label]			NVARCHAR (255) SPARSE,
	[Reference3FillSQL]			NVARCHAR (MAX) SPARSE,
	[RelatedReference3Label]	NVARCHAR (255) SPARSE,
	[RelatedReference3FillSQL]	NVARCHAR (MAX) SPARSE,
	[RelatedAgentId3Label]		NVARCHAR (255) SPARSE,
	[RelatedAgentId3FillSQL]		NVARCHAR (MAX) SPARSE,
	[RelatedResourceId3Label]		NVARCHAR (255) SPARSE,
	[RelatedResourceId3FillSQL]	NVARCHAR (MAX) SPARSE,
	[RelatedAmount3Label]		NVARCHAR (255) SPARSE,
	[RelatedAmount3FillSQL]		NVARCHAR (MAX) SPARSE,
-- Entry 4
	[Operation4Label]			NVARCHAR (255) SPARSE,
	[Operation4FillSQL]			NVARCHAR (MAX) SPARSE,
	[AccountId4Label]				NVARCHAR (255) SPARSE,
	[AccountId4FillSQL]			NVARCHAR (MAX) SPARSE,
	[CustodyId4Label]				NVARCHAR (255) SPARSE,
	[CustodyId4FillSQL]			NVARCHAR (MAX) SPARSE,
	[ResourceId4Label]			NVARCHAR (255) SPARSE,
	[ResourceId4FillSQL]			NVARCHAR (MAX) SPARSE,
	[Direction4Label]			NVARCHAR (255) SPARSE,
	[Direction4FillSQL]			NVARCHAR (MAX) SPARSE,
	[Amount4Label]				NVARCHAR (255) SPARSE,
	[Amount4FillSQL]			NVARCHAR (MAX) SPARSE,
	[Value4Label]				NVARCHAR (255) SPARSE,
	[Value4FillSQL]				NVARCHAR (MAX) SPARSE,
	[NoteId4Label]				NVARCHAR (255) SPARSE,
	[NoteId4FillSQL]				NVARCHAR (MAX) SPARSE,
	[Reference4Label]			NVARCHAR (255) SPARSE,
	[Reference4FillSQL]			NVARCHAR (MAX) SPARSE,
	[RelatedReference4Label]	NVARCHAR (255) SPARSE,
	[RelatedReference4FillSQL]	NVARCHAR (MAX) SPARSE,
	[RelatedAgentId4Label]		NVARCHAR (255) SPARSE,
	[RelatedAgentId4FillSQL]		NVARCHAR (MAX) SPARSE,
	[RelatedResourceId4Label]		NVARCHAR (255) SPARSE,
	[RelatedResourceId4FillSQL]	NVARCHAR (MAX) SPARSE,
	[RelatedAmount4Label]		NVARCHAR (255) SPARSE,
	[RelatedAmount4FillSQL]		NVARCHAR (MAX) SPARSE,
	PRIMARY KEY CLUSTERED ([LineType] ASC)
);
DECLARE @LineType NVARCHAR(255);
/* RULES
	FillSQL should NOT be based on other calculated columns.
*/
SET @LineType = N'equity-issues';
INSERT @LineTypeSpecifications ([LineType]) VALUES(@LineType)
UPDATE @LineTypeSpecifications
SET
	[Operation1Label]		= 	N'Operation',
		[AccountId1FillSQL]	= 		N'N''BalancesWithBanks''',
	[CustodyId1Label]			=	N'DepositedInAccount', -- Allowed Custody Type: CashSafe or BankAccount
	[ResourceId1Label]		=	N'AmountCurrency',
		[Direction1FillSQL] =		 N'+1',
	[Amount1Label]			=	N'AmountDeposited',
	[Value1Label]			= 	N'EquivalentFunctional',
		[NoteId1FillSQL]		=		N'N''ProceedsFromIssuingShares''',
	[Reference1Label]		=	N'Reference #',
		[Operation2FillSQL] =		N'L.[OperationId1]',
		[AccountId2FillSQL]	=		N'N''IssuedCapital''',
	[CustodyId2Label]			=	N'Shareholder',
		[ResourceId2FillSQL]	=		N'(SELECT Id FROM dbo.Resources WHERE [SystemCode] = N''CMNSTCK'')',
		[Direction2FillSQL] =		N'-1', 
	[Amount2Label]			=	N'NumberOfShares',
		[Value2FillSQL]		=		N'L.[Value1]',
		[NoteId2FillSQL]		=		N'N''IssueOfEquity'''
WHERE [LineType] = @LineType;

SET @LineType = N'employees-overtime';
/* Logic: We assume overtime agreement is in functional currency.
Receipt
Dr. Inventory	Dept		Resource:Labor. 
Cr. Accrual		Employee	Resource:Overtime.	Ref:YYYYMM
Invoice -- end of month, part of Payroll
Dr. Accrual 	Employee	Resource:Overtime..	Ref:YYYYMM
Cr. A/P			Employee	Money				Ref:YYYYMM
Payment
Dr. A/P			Employee	Resource:Invoice currency
Cr. Cash		Bank account Resource:Currency
*/
INSERT @LineTypeSpecifications ([LineType]) VALUES(@LineType)
UPDATE @LineTypeSpecifications
SET
	[Operation1Label]		= N'Operation',
		[AccountId1FillSQL]		= N'N''UnassignedLabor''',
	[CustodyId1Label]			= N'Department',
		[ResourceId1FillSQL]		= N'(SELECT [Id] FROM dbo.Resources WHERE [SystemCode] = N''LaborHourly'')',
		[Direction1FillSQL]		= N'+1',
	[Amount1Label]			= N'NumberOfHours',
		[Value1FillSQL]			= N'(
									SELECT L.[Amount1] * [UnitCost] FROM dbo.CustodiesResources
									WHERE CustodyId = L.[CustodyId2] AND ResourceId = L.[ResourceId2] And RelationType = N''Employee''
									)',
	[Reference1Label]		= N'SalaryPeriod',
		[Operation2FillSQL]		= N'L.[OperationId1]',
		[AccountId2FillSQL]		= N'N''ShorttermEmployeeBenefitsAccruals''',
	[CustodyId2Label]			= N'Employee',
	[ResourceId2Label]		 = N'OvertimeType', -- WHERE SystemCode IN (N''DayOvertime'', N''NightOvertime'', N''RestOvertime'', N''HolidayOvertime'')
		[Direction2FillSQL]		= N'-1',
		[Amount2FillSQL]		= N'L.[Amount1]',
		[Value2FillSQL]			= N'(
									SELECT L.[Amount1] * [UnitCost] FROM dbo.CustodiesResources
									WHERE CustodyId = L.[CustodyId2] AND ResourceId = L.[ResourceId2] And RelationType = N''Employee''
									)',
		[Reference2FillSQL]		= N'L.[Reference1]'
WHERE [LineType] = @LineType;
-- Document Type: employees-deductions, either absences or penalties

SET @LineType = N'employees-unpaid-absences'
/* Logic:
Dr. Accrual		Employee	Resource:Labor			500
Cr. Inventory	Dept		Resource:Labor, absent days., 500
*/
INSERT @LineTypeSpecifications ([LineType]) VALUES(@LineType)
UPDATE @LineTypeSpecifications
SET
	[Operation1Label]		= N'Operation',
		[AccountId1FillSQL]		= N'N''ShorttermEmployeeBenefitsAccruals''',
	[CustodyId1Label]			= N'Employee',
		[ResourceId1FillSQL]		= N'(SELECT [Id] FROM dbo.Resources WHERE [SystemCode] = N''LaborDaily'')', -- WHERE SystemCode IN (N''DayOvertime'', N''NightOvertime'', N''RestOvertime'', N''HolidayOvertime'')
		[Direction1FillSQL]		= N'+1',
	[Amount1Label]			= N'NumberOfDays',
		[Value1FillSQL]			= N'(
									SELECT L.[Amount1] * [UnitCost] FROM dbo.CustodiesResources
									WHERE CustodyId = L.[CustodyId1] 
									AND ResourceId = (SELECT [Id] FROM dbo.Resources WHERE [SystemCode] = N''LaborDaily'')
									And RelationType = N''Employee''
									)',
	[Reference1Label]		= N'SalaryPeriod',
		[Operation2FillSQL]		= N'L.[OperationId1]',
		[AccountId2FillSQL]		= N'N''UnassignedLabor''',
	[CustodyId2Label]			= N'Department',
		[ResourceId2FillSQL]		 = N'(SELECT [Id] FROM dbo.Resources WHERE [SystemCode] = N''LaborHourly'')',
		[Direction2FillSQL]		= N'-1',
		[Amount2FillSQL]		= N'L.[Amount1] * 8',
		[Value2FillSQL]			= N'(
									SELECT L.[Amount1] * [UnitCost] FROM dbo.CustodiesResources
									WHERE CustodyId = L.[CustodyId1] 
									AND ResourceId = (SELECT [Id] FROM dbo.Resources WHERE [SystemCode] = N''LaborDaily'')
									And RelationType = N''Employee''
									)',
		[Reference2FillSQL]		= N'L.[Reference1]'
WHERE [LineType] = @LineType;
SET @LineType = N'employees-penalties'
/* Logic:
Dr. Payable		Employee	Resource:currency,	Amount		500
Cr. Wages		Dept		Resource:Currency, , 500
*/
INSERT @LineTypeSpecifications ([LineType]) VALUES(@LineType)
UPDATE @LineTypeSpecifications
SET
	[Operation1Label]		= N'Operation',
		[AccountId1FillSQL]		= N'N''CurrentPayablesToEmployees''',
	[CustodyId1Label]			= N'Employee',
	[ResourceId1Label]		= N'Currency',
		[Direction1FillSQL]		= N'+1',
	[Amount1Label]			= N'Amount Deducted',
	[Value1Label]			= N'Equiv. Functional',
	[Reference1Label]		= N'SalaryPeriod',
		[Operation2FillSQL]		= N'L.[OperationId1]',
		[AccountId2FillSQL]		= N'N''AdministrativeExpense''',
	[CustodyId2Label]			= N'Department',
		[ResourceId2FillSQL]		= N'L.[ResourceId1]',
		[Direction2FillSQL]		= N'-1',
		[Amount2FillSQL]		= N'L.[Amount1]',
		[Value2FillSQL]			= N'L.[Value1]',
		[NoteId2FillSQL]			= N'N''WagesAndSalaries''',
		[Reference2FillSQL]		= N'L.[Reference1]'
WHERE [LineType] = @LineType;
-- Document Type: Unpaid Leave, Paid Leave
/*
Dr. Employee Payable
Cr. Wages (or revenues?)

Invoice -- end of month, part of Payroll
Dr. Accrual 	Employee	Resource:Overtime..	Ref:YYYYMM
Cr. A/P			Employee	Money				Ref:YYYYMM
Payment
Dr. A/P			Employee	Resource:Invoice currency
Cr. Cash		Bank account Resource:Currency
*/

SET @LineType = N'Payroll'; -- sort of invoice, for overtime and 
INSERT @LineTypeSpecifications ([LineType], --N'PaymentIssueToSupplier',
	[Operation1Label],
		[AccountId1FillSQL],
	[CustodyId1Label],
	[ResourceId1Label],
		[Direction1FillSQL],
	[Amount1Label],
	[Value1Label],
	[Reference1Label],
-- Entry 2
		[Operation2FillSQL],
		[AccountId2FillSQL],
		[CustodyId2FillSQL],
		[ResourceId2FillSQL],
		[Direction2FillSQL],
	[Amount2Label],
		[Value2FillSQL],
	[Reference2Label],
		[RelatedReference2FillSQL],
		[RelatedAgentId2FillSQL],
		[RelatedAmount2FillSQL],
-- Entry 3
		[Operation3FillSQL],
		[AccountId3FillSQL],
	[CustodyId3Label],
		[ResourceId3FillSQL],
		[Direction3FillSQL],
	[Amount3Label],
	[Value3Label],
	[Reference3Label],
		[NoteId3FillSQL],
		[RelatedAgentId3FillSQL]
)
/*
There are some flaws in the design below. Each WT should correspond to a given invoice.
In the [Invoice] tab, we can add VAT.
In the [WT] tab, we can refer to WT-subject invoices
In the [payment] tab, we show supplier only, because the check can be against several invoices
However, we are using this as a proof of concept of many SQL tricks
*/
VALUES( N'PaymentIssueToSupplier',
-- Entry 1
	N'Operation',
		N'CurrentPayablesToTradeSuppliers',
	N'Supplier',
	N'InvoiceCurrency',
		N'+1',
	N'AmountPaid',
	N'EquivalentFunctional',
	N'InvoiceNumber',
-- Entry 2
		N'Operation1',
		N'CurrentWithholdingTaxPayable',
		N'(SELECT Id FROM dbo.Custodies WHERE [Name] = N''ERCA'')',
		N'SELECT [Id] FROM dbo.Resources WHERE [Code] = (SELECT [Value] FROM dbo.Settings WHERE [Key] = ''FunctionalCurrencyCode'' )',
		N'-1',	
	N'WithheldAmount',
		N'Amount2',
	N'WithholdingReceiptNumber',
		N'Reference1',
		N'CustodyId1',
		N'Amount1',
-- Entry 3
		N'Operation1',
		N'(
		SELECT CASE (SELECT PlaceType FROM dbo.Custodies WHERE [Id] = [CustodyId3])
					WHEN N''BankAccount'' THEN N''BalancesWithBanks''
					WHEN N''CashSafe'' THEN N''CasnOnHand''			
		)',
	N'PaidFromAccount',
		N'(SELECT ResourceId FROM dbo.Custodies WHERE Id = [CustodyId3]',
		N'-1',
	N'AmountPaid',
	N'EquivalentFunctional',
	N'CheckNumberReceiptNumber',
		N'PaymentsToSuppliersForGoodsAndServices',
		N'Agent1'
)



	/*
INSERT @LineTypeSpecifications (
	[LineType], [EntryNumber], [Definition], [Operation], [Account], [Custody], [ResourceExpression], [Direction], [Amount], [Value], [Note], [RelatedReference], [RelatedAgent], [RelatedResource], [RelatedAmount]) VALUES	
	(N'PaymentReceiptFromCustomer', 1, N'Calculation', NULL, N'''CashOnHand''', NULL, N'[dbo].fn_FunctionalCurrency()', N'1', NULL, N'[dbo].Amount(1,@Entries)', N'''ReceiptsFromSalesOfGoodsAndRenderinfServices''', NULL, NULL, NULL, NULL),
	(N'PaymentReceiptFromCustomer', 1, N'Label', NULL, NULL, N'Cash Custody', NULL, NULL, N'Payment', NULL, NULL, NULL, NULL, NULL, NULL),
	(N'PaymentReceiptFromCustomer', 2, N'Calculation', NULL, N'''SalesContracts''', NULL, N'[dbo].fn_FunctionalCurrency()', N'-1', N'[dbo].Amount(1,@Entries)', N'[dbo].Amount(2,@Entries)', NULL, NULL, NULL, NULL, NULL),
	(N'PaymentReceiptFromCustomer', 2, N'Label', NULL, NULL, N'Customer', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(N'EmployeeIncomeTax', 1, N'Calculation', NULL, N'''EmploymentContracts''', NULL, N'[dbo].fn_FunctionalCurrency()', N'1', NULL, N'[dbo].Amount(1,@Entries)', NULL, NULL, NULL, NULL, NULL),
	(N'EmployeeIncomeTax', 1, N'Label', NULL, NULL, N'Employee', N'Currency', NULL, N'Income Tax', NULL, NULL, NULL, NULL, NULL, NULL),
	(N'EmployeeIncomeTax', 1, N'Validation', NULL, N'''CurrentPayablesToEmployees''', NULL, NULL, N'1', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(N'EmployeeIncomeTax', 2, N'Calculation', NULL, N'''CurrentEmployeeIncomeTaxPayable''', N'[dbo].fn_Settings(''TaxAuthority'')', N'[dbo].fn_FunctionalCurrency()', N'-1', N'[dbo].Amount(1,@Entries)', N'[dbo].Amount(2,@Entries)', NULL, NULL, N'[dbo].Custody(1,@Entries)', NULL, NULL),
	(N'EmployeeIncomeTax', 2, N'Label', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(N'EmployeeIncomeTax', 2, N'Validation', NULL, N'''CurrentEmployeeIncomeTaxPayable''', NULL, NULL, N'-1', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(N'Labor', 1, N'Calculation', NULL, N'''ShorttermEmployeeBenefitsAccruals''', NULL, N'[dbo].fn_Settings(''Labor'')', N'1', N'208', NULL, NULL, NULL, NULL, NULL, NULL),
	(N'Labor', 1, N'Label', NULL, NULL, NULL, N'Employee', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(N'Labor', 1, N'Validation', NULL, N'''EmploymentContracts''', NULL, NULL, N'1', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(N'Labor', 2, N'Calculation', NULL, N'''EmploymentContracts''', N'[dbo].Custody(1,@Entries)', N'[dbo].fn_FunctionalCurrency()', N'-1', NULL, N'[dbo].Amount(2,@Entries)', NULL, N'''Basic''', NULL, NULL, NULL),
	(N'Labor', 2, N'Label', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(N'Labor', 2, N'Validation', NULL, N'''EmploymentContracts''', NULL, NULL, N'-1', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(N'Labor', 3, N'Calculation', NULL, N'''EmploymentContracts''', N'[dbo].Custody(1,@Entries)', N'[dbo].fn_FunctionalCurrency()', N'-1', NULL, N'[dbo].Amount(3,@Entries)', NULL, N'''Transportation''', NULL, NULL, NULL),
	(N'LaborReceiptFromEmployee', 1, N'Calculation', NULL, N'''AdministrativeExpense''', NULL, N'[dbo].fn_Settings(''Labor'')', N'1', NULL, NULL, N'''WagesAndSalaries''', NULL, NULL, NULL, NULL),
	(N'LaborReceiptFromEmployee', 1, N'Label', NULL, NULL, N'Employee', N'Salary Component', NULL, N'Quantity', NULL, NULL, NULL, NULL, NULL, NULL),
	(N'LaborReceiptFromEmployee', 1, N'Validation', NULL, N'''AdministrativeExpense''', N'0', NULL, N'1', NULL, NULL, N'''WagesAndSalaries''', NULL, NULL, NULL, NULL),
	(N'LaborReceiptFromEmployee', 2, N'Calculation', NULL, N'''EmploymentContracts''', NULL, N'[dbo].Resource(1, @Entries)', N'-1', N'[dbo].Amount(1,@Entries)', N'@Bulk:@AccountId = N''EmploymentContracts'', @Direction = 1;', NULL, NULL, NULL, NULL, NULL),
	(N'LaborReceiptFromEmployee', 2, N'Label', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(N'LaborReceiptFromEmployee', 2, N'Validation', NULL, N'''EmploymentContracts''', NULL, NULL, N'-1', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(N'Purchase', 1, N'Calculation', NULL, N'''GoodsAndServicesReceivedFromSupplierButNotBilled''', NULL, NULL, N'1', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(N'Purchase', 1, N'Label', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(N'Purchase', 1, N'Validation', NULL, N'''CurrentValueAddedTaxReceivables''', N'[dbo].fn_Settings(''TaxAuthority'')', NULL, N'1', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(N'Purchase', 2, N'Calculation', NULL, N'''CurrentValueAddedTaxReceivables''', N'[dbo].fn_Settings(''TaxAuthority'')', N'[dbo].fn_FunctionalCurrency()', N'1', NULL, N'[dbo].Amount(2,@Entries)', NULL, NULL, N'[dbo].Custody(1,@Entries)', N'[dbo].Resource(1, @Entries)', N'[dbo].Value(1,@Entries)'),
	(N'Purchase', 2, N'Label', NULL, NULL, NULL, N'Supplier', NULL, N'VAT', NULL, NULL, NULL, NULL, NULL, NULL),
	(N'Purchase', 2, N'Validation', NULL, N'''PurchasesVAT''', NULL, NULL, N'-1', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(N'Purchase', 3, N'Calculation', NULL, N'''CurrentPayablesToTradeSuppliers''', N'[dbo].Custody(1,@Entries)', N'[dbo].fn_FunctionalCurrency()', N'-1', N'[dbo].Amount(2, @Entries)+[dbo].RelatedAmount(2, @Entries)', N'[dbo].Amount(3,@Entries)', NULL, NULL, NULL, NULL, NULL),
	(N'PurchaseWitholdingTax', 1, N'Calculation', NULL, N'''CurrentPayablesToTradeSuppliers''', NULL, N'[dbo].fn_FunctionalCurrency()', N'1', NULL, N'[dbo].Amount(1,@Entries)', NULL, NULL, NULL, NULL, NULL),
	(N'PurchaseWitholdingTax', 1, N'Label', NULL, NULL, NULL, N'Supplier', NULL, N'Tax Withtheld', NULL, NULL, NULL, NULL, NULL, NULL),
	(N'PurchaseWitholdingTax', 1, N'Validation', NULL, N'''PurchaseContracts''', NULL, NULL, N'1', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(N'PurchaseWitholdingTax', 2, N'Calculation', NULL, N'''CurrentWithholdingTaxPayable''', N'[dbo].fn_Settings(''TaxAuthority'')', N'[dbo].fn_FunctionalCurrency()', N'-1', N'[dbo].Amount(1,@Entries)', N'[dbo].Amount(2,@Entries)', NULL, NULL, N'[dbo].Custody(1,@Entries)', NULL, NULL),
	(N'PurchaseWitholdingTax', 2, N'Label', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(N'PurchaseWitholdingTax', 2, N'Validation', NULL, N'''CurrentWithholdingTaxPayable''', N'[dbo].fn_Settings(''TaxAuthority'')', NULL, N'-1', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(N'Sale', 1, N'Calculation', NULL, N'''GoodsAndServicesDeliveredToCustomerButNotBilled''', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(N'StockReceiptFromSupplier', 1, N'Calculation', NULL, N'''OtherInventories''', NULL, NULL, N'1', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(N'StockReceiptFromSupplier', 1, N'Label', NULL, NULL, N'Store', N'Item', NULL, N'Quantity', NULL, NULL, NULL, NULL, NULL, NULL),
	(N'StockReceiptFromSupplier', 1, N'Validation', NULL, N'''OtherInventories''', NULL, NULL, N'1', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(N'StockReceiptFromSupplier', 2, N'Calculation', NULL, N'''GoodsAndServicesReceivedFromSupplierButNotBilled''', NULL, N'[dbo].Resource(1, @Entries)', N'-1', N'[dbo].Amount(1,@Entries)', N'@Bulk:@AccountId = N''PurchaseContracts'', @Direction = 1;', NULL, NULL, NULL, NULL, NULL),
	(N'StockReceiptFromSupplier', 2, N'Label', NULL, NULL, N'Supplier', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(N'StockReceiptFromSupplier', 2, N'Validation', NULL, N'''PurchaseContracts''', NULL, NULL, N'-1', NULL, NULL, NULL, NULL, NULL, NULL, NULL);*/
--select * FROM @LineTypeSpecifications;

MERGE [dbo].[LineTypeSpecifications] AS t
USING @LineTypeSpecifications AS s
ON s.[LineType] = t.[LineType] 
WHEN MATCHED THEN
UPDATE SET
	t.[AppendSQL]					= s.[AppendSQL],
	t.[OperationId1Label]				= s.[Operation1Label],
	t.[OperationId1FillSQL]			= s.[Operation1FillSQL],
	t.[AccountId1Label]				= s.[AccountId1Label],
	t.[AccountId1FillSQL]				= s.[AccountId1FillSQL],
	t.[CustodyId1Label]				= s.[CustodyId1Label],
	t.[CustodyId1FillSQL]				= s.[CustodyId1FillSQL],
	t.[ResourceId1Label]				= s.[ResourceId1Label],
	t.[ResourceId1FillSQL]			= s.[ResourceId1FillSQL],
	t.[Direction1Label]				= s.[Direction1Label],
	t.[Direction1FillSQL]			= s.[Direction1FillSQL],
	t.[Amount1Label]				= s.[Amount1Label],
	t.[Amount1FillSQL]				= s.[Amount1FillSQL],
	t.[Value1Label]					= s.[Value1Label],
	t.[Value1FillSQL]				= s.[Value1FillSQL],
	t.[NoteId1Label]					= s.[NoteId1Label],
	t.[NoteId1FillSQL]				= s.[NoteId1FillSQL],
	t.[Reference1Label]				= s.[Reference1Label],
	t.[Reference1FillSQL]			= s.[Reference1FillSQL],
	t.[RelatedReference1Label]		= s.[RelatedReference1Label],
	t.[RelatedReference1FillSQL]	= s.[RelatedReference1FillSQL],
	t.[RelatedAgentId1Label]			= s.[RelatedAgentId1Label],
	t.[RelatedAgentId1FillSQL]		= s.[RelatedAgentId1FillSQL],
	t.[RelatedResourceId1Label]		= s.[RelatedResourceId1Label],
	t.[RelatedResourceId1FillSQL]		= s.[RelatedResourceId1FillSQL],
	t.[RelatedAmount1Label]			= s.[RelatedAmount1Label],
	t.[RelatedAmount1FillSQL]		= s.[RelatedAmount1FillSQL],

	t.[Operation2Label]				= s.[Operation2Label],
	t.[Operation2FillSQL]			= s.[Operation2FillSQL],
	t.[AccountId2Label]				= s.[AccountId2Label],
	t.[AccountId2FillSQL]				= s.[AccountId2FillSQL],
	t.[CustodyId2Label]				= s.[CustodyId2Label],
	t.[CustodyId2FillSQL]				= s.[CustodyId2FillSQL],
	t.[ResourceId2Label]				= s.[ResourceId2Label],
	t.[ResourceId2FillSQL]			= s.[ResourceId2FillSQL],
	t.[Direction2Label]				= s.[Direction2Label],
	t.[Direction2FillSQL]			= s.[Direction2FillSQL],
	t.[Amount2Label]				= s.[Amount2Label],
	t.[Amount2FillSQL]				= s.[Amount2FillSQL],
	t.[Value2Label]					= s.[Value2Label],
	t.[Value2FillSQL]				= s.[Value2FillSQL],
	t.[NoteId2Label]					= s.[NoteId2Label],
	t.[NoteId2FillSQL]				= s.[NoteId2FillSQL],
	t.[Reference2Label]				= s.[Reference2Label],
	t.[Reference2FillSQL]			= s.[Reference2FillSQL],
	t.[RelatedReference2Label]		= s.[RelatedReference2Label],
	t.[RelatedReference2FillSQL]	= s.[RelatedReference2FillSQL],
	t.[RelatedAgentId2Label]			= s.[RelatedAgentId2Label],
	t.[RelatedAgentId2FillSQL]		= s.[RelatedAgentId2FillSQL],
	t.[RelatedResourceId2Label]		= s.[RelatedResourceId2Label],
	t.[RelatedResourceId2FillSQL]		= s.[RelatedResourceId2FillSQL],
	t.[RelatedAmount2Label]			= s.[RelatedAmount2Label],
	t.[RelatedAmount2FillSQL]		= s.[RelatedAmount2FillSQL],

	t.[Operation3Label]				= s.[Operation3Label],
	t.[Operation3FillSQL]			= s.[Operation3FillSQL],
	t.[AccountId3Label]				= s.[AccountId3Label],
	t.[AccountId3FillSQL]				= s.[AccountId3FillSQL],
	t.[CustodyId3Label]				= s.[CustodyId3Label],
	t.[CustodyId3FillSQL]				= s.[CustodyId3FillSQL],
	t.[ResourceId3Label]				= s.[ResourceId3Label],
	t.[ResourceId3FillSQL]			= s.[ResourceId3FillSQL],
	t.[Direction3Label]				= s.[Direction3Label],
	t.[Direction3FillSQL]			= s.[Direction3FillSQL],
	t.[Amount3Label]				= s.[Amount3Label],
	t.[Amount3FillSQL]				= s.[Amount3FillSQL],
	t.[Value3Label]					= s.[Value3Label],
	t.[Value3FillSQL]				= s.[Value3FillSQL],
	t.[NoteId3Label]					= s.[NoteId3Label],
	t.[NoteId3FillSQL]				= s.[NoteId3FillSQL],
	t.[Reference3Label]				= s.[Reference3Label],
	t.[Reference3FillSQL]			= s.[Reference3FillSQL],
	t.[RelatedReference3Label]		= s.[RelatedReference3Label],
	t.[RelatedReference3FillSQL]	= s.[RelatedReference3FillSQL],
	t.[RelatedAgentId3Label]			= s.[RelatedAgentId3Label],
	t.[RelatedAgentId3FillSQL]		= s.[RelatedAgentId3FillSQL],
	t.[RelatedResourceId3Label]		= s.[RelatedResourceId3Label],
	t.[RelatedResourceId3FillSQL]		= s.[RelatedResourceId3FillSQL],
	t.[RelatedAmount3Label]			= s.[RelatedAmount3Label],
	t.[RelatedAmount3FillSQL]		= s.[RelatedAmount3FillSQL],

	t.[Operation4Label]				= s.[Operation4Label],
	t.[Operation4FillSQL]			= s.[Operation4FillSQL],
	t.[AccountId4Label]				= s.[AccountId4Label],
	t.[AccountId4FillSQL]				= s.[AccountId4FillSQL],
	t.[CustodyId4Label]				= s.[CustodyId4Label],
	t.[CustodyId4FillSQL]				= s.[CustodyId4FillSQL],
	t.[ResourceId4Label]				= s.[ResourceId4Label],
	t.[ResourceId4FillSQL]			= s.[ResourceId4FillSQL],
	t.[Direction4Label]				= s.[Direction4Label],
	t.[Direction4FillSQL]			= s.[Direction4FillSQL],
	t.[Amount4Label]				= s.[Amount4Label],
	t.[Amount4FillSQL]				= s.[Amount4FillSQL],
	t.[Value4Label]					= s.[Value4Label],
	t.[Value4FillSQL]				= s.[Value4FillSQL],
	t.[NoteId4Label]					= s.[NoteId4Label],
	t.[NoteId4FillSQL]				= s.[NoteId4FillSQL],
	t.[Reference4Label]				= s.[Reference4Label],
	t.[Reference4FillSQL]			= s.[Reference4FillSQL],
	t.[RelatedReference4Label]		= s.[RelatedReference4Label],
	t.[RelatedReference4FillSQL]	= s.[RelatedReference4FillSQL],
	t.[RelatedAgentId4Label]			= s.[RelatedAgentId4Label],
	t.[RelatedAgentId4FillSQL]		= s.[RelatedAgentId4FillSQL],
	t.[RelatedResourceId4Label]		= s.[RelatedResourceId4Label],
	t.[RelatedResourceId4FillSQL]		= s.[RelatedResourceId4FillSQL],
	t.[RelatedAmount4Label]			= s.[RelatedAmount4Label],
	t.[RelatedAmount4FillSQL]		= s.[RelatedAmount4FillSQL]
WHEN NOT MATCHED BY SOURCE THEN
    DELETE
WHEN NOT MATCHED BY TARGET THEN
INSERT ([TenantId], [LineType], [AppendSQL],
	[OperationId1Label], [OperationId1FillSQL], [AccountId1Label], [AccountId1FillSQL], [CustodyId1Label],
	[CustodyId1FillSQL], [ResourceId1Label], [ResourceId1FillSQL], [Direction1Label], [Direction1FillSQL],
	[Amount1Label], [Amount1FillSQL], [Value1Label], [Value1FillSQL], [NoteId1Label], [NoteId1FillSQL],
	[Reference1Label], [Reference1FillSQL], [RelatedReference1Label], [RelatedReference1FillSQL],
	[RelatedAgentId1Label], [RelatedAgentId1FillSQL], [RelatedResourceId1Label], [RelatedResourceId1FillSQL],
	[RelatedAmount1Label], [RelatedAmount1FillSQL],
	[Operation2Label], [Operation2FillSQL], [AccountId2Label], [AccountId2FillSQL], [CustodyId2Label],
	[CustodyId2FillSQL], [ResourceId2Label], [ResourceId2FillSQL], [Direction2Label], [Direction2FillSQL],
	[Amount2Label], [Amount2FillSQL], [Value2Label], [Value2FillSQL], [NoteId2Label], [NoteId2FillSQL],
	[Reference2Label], [Reference2FillSQL], [RelatedReference2Label], [RelatedReference2FillSQL],
	[RelatedAgentId2Label], [RelatedAgentId2FillSQL], [RelatedResourceId2Label], [RelatedResourceId2FillSQL],
	[RelatedAmount2Label], [RelatedAmount2FillSQL],
	[Operation3Label], [Operation3FillSQL], [AccountId3Label], [AccountId3FillSQL], [CustodyId3Label],
	[CustodyId3FillSQL], [ResourceId3Label], [ResourceId3FillSQL], [Direction3Label], [Direction3FillSQL],
	[Amount3Label], [Amount3FillSQL], [Value3Label], [Value3FillSQL], [NoteId3Label], [NoteId3FillSQL],
	[Reference3Label], [Reference3FillSQL], [RelatedReference3Label], [RelatedReference3FillSQL],
	[RelatedAgentId3Label], [RelatedAgentId3FillSQL], [RelatedResourceId3Label], [RelatedResourceId3FillSQL],
	[RelatedAmount3Label], [RelatedAmount3FillSQL],
	[Operation4Label], [Operation4FillSQL], [AccountId4Label], [AccountId4FillSQL], [CustodyId4Label],
	[CustodyId4FillSQL], [ResourceId4Label], [ResourceId4FillSQL], [Direction4Label], [Direction4FillSQL],
	[Amount4Label], [Amount4FillSQL], [Value4Label], [Value4FillSQL], [NoteId4Label], [NoteId4FillSQL],
	[Reference4Label], [Reference4FillSQL], [RelatedReference4Label], [RelatedReference4FillSQL],
	[RelatedAgentId4Label], [RelatedAgentId4FillSQL], [RelatedResourceId4Label], [RelatedResourceId4FillSQL],
	[RelatedAmount4Label], [RelatedAmount4FillSQL]
	)
VALUES(@TenantId, s.[LineType], s.[AppendSQL],
	s.[Operation1Label], s.[Operation1FillSQL], s.[AccountId1Label], s.[AccountId1FillSQL], s.[CustodyId1Label],
	s.[CustodyId1FillSQL], s.[ResourceId1Label], s.[ResourceId1FillSQL], s.[Direction1Label], s.[Direction1FillSQL],
	s.[Amount1Label], s.[Amount1FillSQL], s.[Value1Label], s.[Value1FillSQL], s.[NoteId1Label], s.[NoteId1FillSQL],
	s.[Reference1Label], s.[Reference1FillSQL], s.[RelatedReference1Label], s.[RelatedReference1FillSQL],
	s.[RelatedAgentId1Label], s.[RelatedAgentId1FillSQL], s.[RelatedResourceId1Label], s.[RelatedResourceId1FillSQL],
	s.[RelatedAmount1Label], s.[RelatedAmount1FillSQL],
	s.[Operation2Label], s.[Operation2FillSQL], s.[AccountId2Label], s.[AccountId2FillSQL], s.[CustodyId2Label],
	s.[CustodyId2FillSQL], s.[ResourceId2Label], s.[ResourceId2FillSQL], s.[Direction2Label], s.[Direction2FillSQL],
	s.[Amount2Label], s.[Amount2FillSQL], s.[Value2Label], s.[Value2FillSQL], s.[NoteId2Label], s.[NoteId2FillSQL],
	s.[Reference2Label], s.[Reference2FillSQL], s.[RelatedReference2Label], s.[RelatedReference2FillSQL],
	s.[RelatedAgentId2Label], s.[RelatedAgentId2FillSQL], s.[RelatedResourceId2Label], s.[RelatedResourceId2FillSQL],
	s.[RelatedAmount2Label], s.[RelatedAmount2FillSQL],
	s.[Operation3Label], s.[Operation3FillSQL], s.[AccountId3Label], s.[AccountId3FillSQL], s.[CustodyId3Label],
	s.[CustodyId3FillSQL], s.[ResourceId3Label], s.[ResourceId3FillSQL], s.[Direction3Label], s.[Direction3FillSQL],
	s.[Amount3Label], s.[Amount3FillSQL], s.[Value3Label], s.[Value3FillSQL], s.[NoteId3Label], s.[NoteId3FillSQL],
	s.[Reference3Label], s.[Reference3FillSQL], s.[RelatedReference3Label], s.[RelatedReference3FillSQL],
	s.[RelatedAgentId3Label], s.[RelatedAgentId3FillSQL], s.[RelatedResourceId3Label], s.[RelatedResourceId3FillSQL],
	s.[RelatedAmount3Label], s.[RelatedAmount3FillSQL],
	s.[Operation4Label], s.[Operation4FillSQL], s.[AccountId4Label], s.[AccountId4FillSQL], s.[CustodyId4Label],
	s.[CustodyId4FillSQL], s.[ResourceId4Label], s.[ResourceId4FillSQL], s.[Direction4Label], s.[Direction4FillSQL],
	s.[Amount4Label], s.[Amount4FillSQL], s.[Value4Label], s.[Value4FillSQL], s.[NoteId4Label], s.[NoteId4FillSQL],
	s.[Reference4Label], s.[Reference4FillSQL], s.[RelatedReference4Label], s.[RelatedReference4FillSQL],
	s.[RelatedAgentId4Label], s.[RelatedAgentId4FillSQL], s.[RelatedResourceId4Label], s.[RelatedResourceId4FillSQL],
	s.[RelatedAmount4Label], s.[RelatedAmount4FillSQL]
);
--OUTPUT deleted.*, $action, inserted.*; -- Does not work with triggers