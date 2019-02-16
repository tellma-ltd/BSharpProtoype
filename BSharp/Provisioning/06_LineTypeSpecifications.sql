DECLARE @LineTypeSpecifications TABLE (
	[LineType]					NVARCHAR (255),
	[AppendSql]					NVARCHAR (MAX),
-- For Account, It might be better to use normalized version: Transaction Type, Resource Type, etc, and conclude the IFRS accordingly.
	[Direction1]				SMALLINT,
	[OperationId1Label]			NVARCHAR (255),
	[OperationId1FillSql]		NVARCHAR (MAX),
	[AccountId1Label]			NVARCHAR (255),
	[AccountId1FillSql]			NVARCHAR (MAX),

	[CustodyId1Label]			NVARCHAR (255),
	[CustodyId1DefaultJs]		NVARCHAR (MAX), -- Default has two parts: columns affecting it, and value. 
	[
	[CustodyId1Filter]			NVARCHAR (MAX), -- The simplified user filter for the UI picker
	[CustodyId1ValidateSql]		NVARCHAR (MAX), -- The detailed data validation logic, verifid in the BE
	[CustodyId1FillSql]			NVARCHAR (MAX),
	
	[ResourceId1Label]			NVARCHAR (255),
	[ResourceId1FillSql]		NVARCHAR (MAX),
	[Amount1Label]				NVARCHAR (255),
	[Amount1FillSql]			NVARCHAR (MAX),
	[Value1Label]				NVARCHAR (255),
	[Value1FillSql]				NVARCHAR (MAX),
	[NoteId1Label]				NVARCHAR (255),
	[NoteId1FillSql]			NVARCHAR (MAX),
	[Reference1Label]			NVARCHAR (255),
	[Reference1FillSql]			NVARCHAR (MAX),
	[RelatedReference1Label]	NVARCHAR (255),
	[RelatedReference1FillSql]	NVARCHAR (MAX),
	[RelatedAgentId1Label]		NVARCHAR (255),
	[RelatedAgentId1FillSql]	NVARCHAR (MAX),
	[RelatedResourceId1Label]	NVARCHAR (255),
	[RelatedResourceId1FillSql]	NVARCHAR (MAX),
	[RelatedAmount1Label]		NVARCHAR (255),
	[RelatedAmount1FillSql]		NVARCHAR (MAX),
-- Entry 2
	[Direction2]				SMALLINT,
	[OperationId2Label]			NVARCHAR (255),
	[OperationId2FillSql]		NVARCHAR (MAX),
	[AccountId2Label]			NVARCHAR (255),
	[AccountId2FillSql]			NVARCHAR (MAX),
	[CustodyId2Label]			NVARCHAR (255),
	[CustodyId2FillSql]			NVARCHAR (MAX),
	[ResourceId2Label]			NVARCHAR (255),
	[ResourceId2FillSql]		NVARCHAR (MAX),
	[Amount2Label]				NVARCHAR (255),
	[Amount2FillSql]			NVARCHAR (MAX),
	[Value2Label]				NVARCHAR (255),
	[Value2FillSql]				NVARCHAR (MAX),
	[NoteId2Label]				NVARCHAR (255),
	[NoteId2FillSql]			NVARCHAR (MAX),
	[Reference2Label]			NVARCHAR (255),
	[Reference2FillSql]			NVARCHAR (MAX),
	[RelatedReference2Label]	NVARCHAR (255),
	[RelatedReference2FillSql]	NVARCHAR (MAX),
	[RelatedAgentId2Label]		NVARCHAR (255),
	[RelatedAgentId2FillSql]	NVARCHAR (MAX),
	[RelatedResourceId2Label]	NVARCHAR (255),
	[RelatedResourceId2FillSql]	NVARCHAR (MAX),
	[RelatedAmount2Label]		NVARCHAR (255),
	[RelatedAmount2FillSql]		NVARCHAR (MAX),
-- Entry 3
	[Direction3]				SMALLINT,
	[OperationId3Label]			NVARCHAR (255),
	[OperationId3FillSql]		NVARCHAR (MAX),
	[AccountId3Label]			NVARCHAR (255),
	[AccountId3FillSql]			NVARCHAR (MAX),
	[CustodyId3Label]			NVARCHAR (255),
	[CustodyId3FillSql]			NVARCHAR (MAX),
	[ResourceId3Label]			NVARCHAR (255),
	[ResourceId3FillSql]		NVARCHAR (MAX),
	[Amount3Label]				NVARCHAR (255),
	[Amount3FillSql]			NVARCHAR (MAX),
	[Value3Label]				NVARCHAR (255),
	[Value3FillSql]				NVARCHAR (MAX),
	[NoteId3Label]				NVARCHAR (255),
	[NoteId3FillSql]			NVARCHAR (MAX),
	[Reference3Label]			NVARCHAR (255),
	[Reference3FillSql]			NVARCHAR (MAX),
	[RelatedReference3Label]	NVARCHAR (255),
	[RelatedReference3FillSql]	NVARCHAR (MAX),
	[RelatedAgentId3Label]		NVARCHAR (255),
	[RelatedAgentId3FillSql]	NVARCHAR (MAX),
	[RelatedResourceId3Label]	NVARCHAR (255),
	[RelatedResourceId3FillSql]	NVARCHAR (MAX),
	[RelatedAmount3Label]		NVARCHAR (255),
	[RelatedAmount3FillSql]		NVARCHAR (MAX),
-- Entry 4
	[Direction4]				SMALLINT,
	[OperationId4Label]			NVARCHAR (255),
	[OperationId4FillSql]		NVARCHAR (MAX),
	[AccountId4Label]			NVARCHAR (255),
	[AccountId4FillSql]			NVARCHAR (MAX),
	[CustodyId4Label]			NVARCHAR (255),
	[CustodyId4FillSql]			NVARCHAR (MAX),
	[ResourceId4Label]			NVARCHAR (255),
	[ResourceId4FillSql]		NVARCHAR (MAX),
	[Amount4Label]				NVARCHAR (255),
	[Amount4FillSql]			NVARCHAR (MAX),
	[Value4Label]				NVARCHAR (255),
	[Value4FillSql]				NVARCHAR (MAX),
	[NoteId4Label]				NVARCHAR (255),
	[NoteId4FillSql]			NVARCHAR (MAX),
	[Reference4Label]			NVARCHAR (255),
	[Reference4FillSql]			NVARCHAR (MAX),
	[RelatedReference4Label]	NVARCHAR (255),
	[RelatedReference4FillSql]	NVARCHAR (MAX),
	[RelatedAgentId4Label]		NVARCHAR (255),
	[RelatedAgentId4FillSql]	NVARCHAR (MAX),
	[RelatedResourceId4Label]	NVARCHAR (255),
	[RelatedResourceId4FillSql]	NVARCHAR (MAX),
	[RelatedAmount4Label]		NVARCHAR (255),
	[RelatedAmount4FillSql]		NVARCHAR (MAX),

	PRIMARY KEY CLUSTERED ([LineType] ASC)
);
DECLARE @LineType NVARCHAR(255);
/* RULES
	FillSql should NOT be based on other calculated columns.
*/
SET @LineType = N'equity-issues-foreign';
INSERT @LineTypeSpecifications ([LineType]) VALUES(@LineType)
UPDATE @LineTypeSpecifications
SET
		[Direction1]		=	+1,
	--[OperationId1Label]		= 	N'Operation',
		[AccountId1FillSql]	= 		N'N''BalancesWithBanks''',
	--[CustodyId1Label]			=	N'DepositedInAccount', -- Allowed Custody Type: CashSafe or BankAccount
	--[ResourceId1Label]		=	N'AmountCurrency',
	--[Amount1Label]			=	N'AmountDeposited',
	--[Value1Label]			= 	N'EquivalentFunctional',
		[NoteId1FillSql]		=		N'N''ProceedsFromIssuingShares''',
	--[Reference1Label]		=	N'Reference #',

		[Direction2]		=	-1,
		[OperationId2FillSql] =		N'L.[OperationId1]',
		[AccountId2FillSql]	=		N'N''IssuedCapital''',
	--[CustodyId2Label]			=	N'Shareholder',
		[ResourceId2FillSql]	=		N'(SELECT Id FROM dbo.Resources WHERE [SystemCode] = N''CMNSTCK'')',
	--[Amount2Label]			=	N'NumberOfShares',
		[Value2FillSql]		=		N'L.[Value1]',
		[NoteId2FillSql]		=		N'N''IssueOfEquity'''
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
		[Direction1]		=	+1,
	--[OperationId1Label]		= N'Operation',
		[AccountId1FillSql]		= N'N''UnassignedLabor''',
	--[CustodyId1Label]			= N'Department',
		[ResourceId1FillSql]		= N'(SELECT [Id] FROM dbo.Resources WHERE [SystemCode] = N''LaborHourly'')',
	--[Amount1Label]			= N'NumberOfHours',
		[Value1FillSql]			= N'(
									SELECT L.[Amount1] * [UnitCost] FROM dbo.CustodiesResources
									WHERE CustodyId = L.[CustodyId2] AND ResourceId = L.[ResourceId2] And RelationType = N''Employee''
									)',
	--[Reference1Label]		= N'SalaryPeriod',
		[OperationId2FillSql]		= N'L.[OperationId1]',
		[AccountId2FillSql]		= N'N''ShorttermEmployeeBenefitsAccruals''',
	--[CustodyId2Label]			= N'Employee',
	--[ResourceId2Label]		 = N'OvertimeType', -- WHERE SystemCode IN (N''DayOvertime'', N''NightOvertime'', N''RestOvertime'', N''HolidayOvertime'')
		[Direction2]		=	-1,		
		[Amount2FillSql]		= N'L.[Amount1]',
		[Value2FillSql]			= N'(
									SELECT L.[Amount1] * [UnitCost] FROM dbo.CustodiesResources
									WHERE CustodyId = L.[CustodyId2] AND ResourceId = L.[ResourceId2] And RelationType = N''Employee''
									)',
		[Reference2FillSql]		= N'L.[Reference1]'
WHERE [LineType] = @LineType;
-- Document Type: employees-deductions, either absences or penalties

SET @LineType = N'et-employees-unpaid-absences'
/* Logic:
Dr. Accrual		Employee	Resource:Labor			500
Cr. Inventory	Dept		Resource:Labor, absent days., 500
*/
INSERT @LineTypeSpecifications ([LineType]) VALUES(@LineType)
UPDATE @LineTypeSpecifications
SET
		[Direction1]		=	+1,
	--[OperationId1Label]		= N'Operation',
		[AccountId1FillSql]		= N'N''ShorttermEmployeeBenefitsAccruals''',
	--[CustodyId1Label]			= N'Employee',
		[ResourceId1FillSql]		= N'(SELECT [Id] FROM dbo.Resources WHERE [SystemCode] = N''LaborDaily'')', -- WHERE SystemCode IN (N''DayOvertime'', N''NightOvertime'', N''RestOvertime'', N''HolidayOvertime'')
	--[Amount1Label]			= N'NumberOfDays',
		[Value1FillSql]			= N'(
									SELECT L.[Amount1] * [UnitCost] FROM dbo.CustodiesResources
									WHERE CustodyId = L.[CustodyId1] 
									AND ResourceId = (SELECT [Id] FROM dbo.Resources WHERE [SystemCode] = N''LaborDaily'')
									And RelationType = N''Employee''
									)',
	--[Reference1Label]		= N'SalaryPeriod',

		[Direction2]		=	-1,		
		[OperationId2FillSql]	= N'L.[OperationId1]',
		[AccountId2FillSql]		= N'N''UnassignedLabor''',
	--[CustodyId2Label]			= N'Department',
		[ResourceId2FillSql]		 = N'(SELECT [Id] FROM dbo.Resources WHERE [SystemCode] = N''LaborHourly'')',
		[Amount2FillSql]		= N'L.[Amount1] * 8',
		[Value2FillSql]			= N'(
									SELECT L.[Amount1] * [UnitCost] FROM dbo.CustodiesResources
									WHERE CustodyId = L.[CustodyId1] 
									AND ResourceId = (SELECT [Id] FROM dbo.Resources WHERE [SystemCode] = N''LaborDaily'')
									And RelationType = N''Employee''
									)',
		[Reference2FillSql]		= N'L.[Reference1]'
WHERE [LineType] = @LineType;
SET @LineType = N'et-employees-penalties'
/* Logic:
Dr. Payable		Employee	Resource:currency,	Amount		500
Cr. Wages		Dept		Resource:Currency, , 500
*/
INSERT @LineTypeSpecifications ([LineType]) VALUES(@LineType)
UPDATE @LineTypeSpecifications
SET
		[Direction1]		=	+1,
	--[OperationId1Label]		= N'Operation',
		[AccountId1FillSql]		= N'N''CurrentPayablesToEmployees''',
	--[CustodyId1Label]			= N'Employee',
	--[ResourceId1Label]		= N'Currency',
	--[Amount1Label]			= N'Amount Deducted',
	--[Value1Label]			= N'Equiv. Functional',
	--[Reference1Label]		= N'SalaryPeriod',

		[Direction2]		=	-1,		
		[OperationId2FillSql]		= N'L.[OperationId1]',
		[AccountId2FillSql]		= N'N''AdministrativeExpense''',
	--[CustodyId2Label]			= N'Department',
		[ResourceId2FillSql]		= N'L.[ResourceId1]',
		[Amount2FillSql]		= N'L.[Amount1]',
		[Value2FillSql]			= N'L.[Value1]',
		[NoteId2FillSql]			= N'N''WagesAndSalaries''',
		[Reference2FillSql]		= N'L.[Reference1]'
WHERE [LineType] = @LineType;

SET @LineType = N'et-employees-leaves-hourly-paid'
/* Logic:
Dr. AdminExpens	Employee	Resource:labor,	Amount: paid hours, value (from average cost?)
	Cr. Inventory	Dept		Resource:Labor,	
*/
INSERT @LineTypeSpecifications ([LineType]) VALUES(@LineType)
UPDATE @LineTypeSpecifications
SET
		[Direction1]		=	+1,
	--[OperationId1Label]		= N'Operation',
		[AccountId1FillSql]		= N'N''AdministrativeExpense''',
	--[CustodyId1Label]			= N'Employee',
		[ResourceId1FillSql]	= N'(SELECT [Id] FROM dbo.Resources WHERE [SystemCode] = N''LaborHourly'')',
	--[Amount1Label]			= N'Leave Hours',
		[Value1FillSql]			= N'(
									SELECT L.[Amount1] * [UnitCost]/8 FROM dbo.CustodiesResources
									WHERE CustodyId = L.[CustodyId1] 
									AND ResourceId = (SELECT [Id] FROM dbo.Resources WHERE [SystemCode] = N''LaborDaily'')
									And RelationType = N''Employee''
									)',
	--[Reference1Label]		= N'SalaryPeriod',
		[NoteId1FillSql]		= N'N''WagesAndSalaries''',

		[Direction2]		=	-1,		
		[OperationId2FillSql]	= N'L.[OperationId1]',
		[AccountId2FillSql]		= N'N''UnassignedLabor''',
	--[CustodyId2Label]		= N'Department', -- can be auto calculated.
		[ResourceId2FillSql]	= N'(SELECT [Id] FROM dbo.Resources WHERE [SystemCode] = N''LaborHourly'')',
		[Amount2FillSql]		= N'L.[Amount1]',
		[Value2FillSql]			= N'(
									SELECT L.[Amount1] * [UnitCost]/8 FROM dbo.CustodiesResources
									WHERE CustodyId = L.[CustodyId1] 
									AND ResourceId = (SELECT [Id] FROM dbo.Resources WHERE [SystemCode] = N''LaborDaily'')
									And RelationType = N''Employee''
									)',
		[Reference2FillSql]		= N'L.[Reference1]'
WHERE [LineType] = @LineType;

SET @LineType = N'et-employees-leaves-hourly-unpaid'
/* Logic:
Dr. Accrual		Employee	Resource:Labor.	Ref:YYYYMM
Cr. Inventory	Dept		Resource:Labor. 

*/
INSERT @LineTypeSpecifications ([LineType]) VALUES(@LineType)
UPDATE @LineTypeSpecifications
SET
		[Direction1]		=	+1,
	--[OperationId1Label]		= N'Operation',
		[AccountId1FillSql]		= N'N''ShorttermEmployeeBenefitsAccruals''',
	--[CustodyId1Label]			= N'Employee',
		[ResourceId1FillSql]	= N'(SELECT [Id] FROM dbo.Resources WHERE [SystemCode] = N''LaborHourly'')',
	--[Amount1Label]			= N'Leave Hours',
		[Value1FillSql]			= N'L.[Amount1]',
	--[Reference1Label]		= N'SalaryPeriod',

		[Direction2]		=	-1,	
		[OperationId2FillSql]	= N'L.[OperationId1]',
		[AccountId2FillSql]		= N'N''UnassignedLabor''',
	--[CustodyId2Label]		= N'Department', -- can be auto calculated.
		[ResourceId2FillSql]	= N'L.[ResourceId1]',
		[Amount2FillSql]		= N'L.[Amount1]',
		[Value2FillSql]			= N'L.[Amount1]',
		[Reference2FillSql]		= N'L.[Reference1]'
WHERE [LineType] = @LineType;

--
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
	t.[AppendSql]					= s.[AppendSql],
	t.[Direction1]					= s.[Direction1],
	t.[Operation1IsVisible]			= s.[OperationId1Label],
	t.[OperationId1FillSql]			= s.[OperationId1FillSql],
	t.[Account1IsVisible]				= s.[AccountId1Label],
	t.[AccountId1FillSql]				= s.[AccountId1FillSql],
	t.[Custody1IsVisible]				= s.[CustodyId1Label],
	t.[CustodyId1FillSql]				= s.[CustodyId1FillSql],
	t.[Resource1IsVisible]				= s.[ResourceId1Label],
	t.[ResourceId1FillSql]			= s.[ResourceId1FillSql],
	t.[Amount1IsVisible]				= s.[Amount1Label],
	t.[Amount1FillSql]				= s.[Amount1FillSql],
	t.[Value1IsVisible]					= s.[Value1Label],
	t.[Value1FillSql]				= s.[Value1FillSql],
	t.[Note1IsVisible]					= s.[NoteId1Label],
	t.[NoteId1FillSql]				= s.[NoteId1FillSql],
	t.[Reference1IsVisible]				= s.[Reference1Label],
	t.[Reference1FillSql]			= s.[Reference1FillSql],
	t.[RelatedReference1IsVisible]		= s.[RelatedReference1Label],
	t.[RelatedReference1FillSql]	= s.[RelatedReference1FillSql],
	t.[RelatedAgent1IsVisible]			= s.[RelatedAgentId1Label],
	t.[RelatedAgentId1FillSql]		= s.[RelatedAgentId1FillSql],
	t.[RelatedResource1IsVisible]		= s.[RelatedResourceId1Label],
	t.[RelatedResourceId1FillSql]		= s.[RelatedResourceId1FillSql],
	t.[RelatedAmount1IsVisible]			= s.[RelatedAmount1Label],
	t.[RelatedAmount1FillSql]		= s.[RelatedAmount1FillSql],

	t.[Direction2]					= s.[Direction2],
	t.[OperationId2Label]				= s.[OperationId2Label],
	t.[OperationId2FillSql]			= s.[OperationId2FillSql],
	t.[AccountId2Label]				= s.[AccountId2Label],
	t.[AccountId2FillSql]				= s.[AccountId2FillSql],
	t.[CustodyId2Label]				= s.[CustodyId2Label],
	t.[CustodyId2FillSql]				= s.[CustodyId2FillSql],
	t.[ResourceId2Label]				= s.[ResourceId2Label],
	t.[ResourceId2FillSql]			= s.[ResourceId2FillSql],
	t.[Amount2Label]				= s.[Amount2Label],
	t.[Amount2FillSql]				= s.[Amount2FillSql],
	t.[Value2Label]					= s.[Value2Label],
	t.[Value2FillSql]				= s.[Value2FillSql],
	t.[NoteId2Label]					= s.[NoteId2Label],
	t.[NoteId2FillSql]				= s.[NoteId2FillSql],
	t.[Reference2Label]				= s.[Reference2Label],
	t.[Reference2FillSql]			= s.[Reference2FillSql],
	t.[RelatedReference2Label]		= s.[RelatedReference2Label],
	t.[RelatedReference2FillSql]	= s.[RelatedReference2FillSql],
	t.[RelatedAgentId2Label]			= s.[RelatedAgentId2Label],
	t.[RelatedAgentId2FillSql]		= s.[RelatedAgentId2FillSql],
	t.[RelatedResourceId2Label]		= s.[RelatedResourceId2Label],
	t.[RelatedResourceId2FillSql]		= s.[RelatedResourceId2FillSql],
	t.[RelatedAmount2Label]			= s.[RelatedAmount2Label],
	t.[RelatedAmount2FillSql]		= s.[RelatedAmount2FillSql],

	t.[Direction3]					= s.[Direction3],
	t.[OperationId3Label]				= s.[OperationId3Label],
	t.[OperationId3FillSql]			= s.[OperationId3FillSql],
	t.[AccountId3Label]				= s.[AccountId3Label],
	t.[AccountId3FillSql]				= s.[AccountId3FillSql],
	t.[CustodyId3Label]				= s.[CustodyId3Label],
	t.[CustodyId3FillSql]				= s.[CustodyId3FillSql],
	t.[ResourceId3Label]				= s.[ResourceId3Label],
	t.[ResourceId3FillSql]			= s.[ResourceId3FillSql],
	t.[Amount3Label]				= s.[Amount3Label],
	t.[Amount3FillSql]				= s.[Amount3FillSql],
	t.[Value3Label]					= s.[Value3Label],
	t.[Value3FillSql]				= s.[Value3FillSql],
	t.[NoteId3Label]					= s.[NoteId3Label],
	t.[NoteId3FillSql]				= s.[NoteId3FillSql],
	t.[Reference3Label]				= s.[Reference3Label],
	t.[Reference3FillSql]			= s.[Reference3FillSql],
	t.[RelatedReference3Label]		= s.[RelatedReference3Label],
	t.[RelatedReference3FillSql]	= s.[RelatedReference3FillSql],
	t.[RelatedAgentId3Label]			= s.[RelatedAgentId3Label],
	t.[RelatedAgentId3FillSql]		= s.[RelatedAgentId3FillSql],
	t.[RelatedResourceId3Label]		= s.[RelatedResourceId3Label],
	t.[RelatedResourceId3FillSql]		= s.[RelatedResourceId3FillSql],
	t.[RelatedAmount3Label]			= s.[RelatedAmount3Label],
	t.[RelatedAmount3FillSql]		= s.[RelatedAmount3FillSql],

	t.[Direction4]					= s.[Direction4],
	t.[OperationId4Label]			= s.[OperationId4Label],
	t.[OperationId4FillSql]			= s.[OperationId4FillSql],
	t.[AccountId4Label]				= s.[AccountId4Label],
	t.[AccountId4FillSql]				= s.[AccountId4FillSql],
	t.[CustodyId4Label]				= s.[CustodyId4Label],
	t.[CustodyId4FillSql]				= s.[CustodyId4FillSql],
	t.[ResourceId4Label]				= s.[ResourceId4Label],
	t.[ResourceId4FillSql]			= s.[ResourceId4FillSql],
	t.[Amount4Label]				= s.[Amount4Label],
	t.[Amount4FillSql]				= s.[Amount4FillSql],
	t.[Value4Label]					= s.[Value4Label],
	t.[Value4FillSql]				= s.[Value4FillSql],
	t.[NoteId4Label]					= s.[NoteId4Label],
	t.[NoteId4FillSql]				= s.[NoteId4FillSql],
	t.[Reference4Label]				= s.[Reference4Label],
	t.[Reference4FillSql]			= s.[Reference4FillSql],
	t.[RelatedReference4Label]		= s.[RelatedReference4Label],
	t.[RelatedReference4FillSql]	= s.[RelatedReference4FillSql],
	t.[RelatedAgentId4Label]			= s.[RelatedAgentId4Label],
	t.[RelatedAgentId4FillSql]		= s.[RelatedAgentId4FillSql],
	t.[RelatedResourceId4Label]		= s.[RelatedResourceId4Label],
	t.[RelatedResourceId4FillSql]		= s.[RelatedResourceId4FillSql],
	t.[RelatedAmount4Label]			= s.[RelatedAmount4Label],
	t.[RelatedAmount4FillSql]		= s.[RelatedAmount4FillSql]
WHEN NOT MATCHED BY SOURCE THEN
    DELETE
WHEN NOT MATCHED BY TARGET THEN
INSERT ([TenantId], [LineType], [AppendSql],
	[Direction1], [Operation1IsVisible], [OperationId1FillSql], [Account1IsVisible], [AccountId1FillSql],
	[Custody1IsVisible], [CustodyId1FillSql], [Resource1IsVisible], [ResourceId1FillSql],
	[Amount1IsVisible], [Amount1FillSql], [Value1IsVisible], [Value1FillSql], [Note1IsVisible], [NoteId1FillSql],
	[Reference1IsVisible], [Reference1FillSql], [RelatedReference1IsVisible], [RelatedReference1FillSql],
	[RelatedAgent1IsVisible], [RelatedAgentId1FillSql], [RelatedResource1IsVisible], [RelatedResourceId1FillSql],
	[RelatedAmount1IsVisible], [RelatedAmount1FillSql],
	[Direction2], [OperationId2Label], [OperationId2FillSql], [AccountId2Label], [AccountId2FillSql], 
	[CustodyId2Label], [CustodyId2FillSql], [ResourceId2Label], [ResourceId2FillSql],
	[Amount2Label], [Amount2FillSql], [Value2Label], [Value2FillSql], [NoteId2Label], [NoteId2FillSql],
	[Reference2Label], [Reference2FillSql], [RelatedReference2Label], [RelatedReference2FillSql],
	[RelatedAgentId2Label], [RelatedAgentId2FillSql], [RelatedResourceId2Label], [RelatedResourceId2FillSql],
	[RelatedAmount2Label], [RelatedAmount2FillSql],
	[Direction3], [OperationId3Label], [OperationId3FillSql], [AccountId3Label], [AccountId3FillSql], 
	[CustodyId3Label], [CustodyId3FillSql], [ResourceId3Label], [ResourceId3FillSql],
	[Amount3Label], [Amount3FillSql], [Value3Label], [Value3FillSql], [NoteId3Label], [NoteId3FillSql],
	[Reference3Label], [Reference3FillSql], [RelatedReference3Label], [RelatedReference3FillSql],
	[RelatedAgentId3Label], [RelatedAgentId3FillSql], [RelatedResourceId3Label], [RelatedResourceId3FillSql],
	[RelatedAmount3Label], [RelatedAmount3FillSql],
	[Direction4], [OperationId4Label], [OperationId4FillSql], [AccountId4Label], [AccountId4FillSql], 
	[CustodyId4Label], [CustodyId4FillSql], [ResourceId4Label], [ResourceId4FillSql],
	[Amount4Label], [Amount4FillSql], [Value4Label], [Value4FillSql], [NoteId4Label], [NoteId4FillSql],
	[Reference4Label], [Reference4FillSql], [RelatedReference4Label], [RelatedReference4FillSql],
	[RelatedAgentId4Label], [RelatedAgentId4FillSql], [RelatedResourceId4Label], [RelatedResourceId4FillSql],
	[RelatedAmount4Label], [RelatedAmount4FillSql]
	)
VALUES(@TenantId, s.[LineType], s.[AppendSql],
	s.[Direction1], s.[OperationId1Label], s.[OperationId1FillSql], s.[AccountId1Label], s.[AccountId1FillSql],
	s.[CustodyId1Label], s.[CustodyId1FillSql], s.[ResourceId1Label], s.[ResourceId1FillSql],
	s.[Amount1Label], s.[Amount1FillSql], s.[Value1Label], s.[Value1FillSql], s.[NoteId1Label], s.[NoteId1FillSql],
	s.[Reference1Label], s.[Reference1FillSql], s.[RelatedReference1Label], s.[RelatedReference1FillSql],
	s.[RelatedAgentId1Label], s.[RelatedAgentId1FillSql], s.[RelatedResourceId1Label], s.[RelatedResourceId1FillSql],
	s.[RelatedAmount1Label], s.[RelatedAmount1FillSql],
	s.[Direction2], s.[OperationId2Label], s.[OperationId2FillSql], s.[AccountId2Label], s.[AccountId2FillSql],
	s.[CustodyId2Label], s.[CustodyId2FillSql], s.[ResourceId2Label], s.[ResourceId2FillSql],
	s.[Amount2Label], s.[Amount2FillSql], s.[Value2Label], s.[Value2FillSql], s.[NoteId2Label], s.[NoteId2FillSql],
	s.[Reference2Label], s.[Reference2FillSql], s.[RelatedReference2Label], s.[RelatedReference2FillSql],
	s.[RelatedAgentId2Label], s.[RelatedAgentId2FillSql], s.[RelatedResourceId2Label], s.[RelatedResourceId2FillSql],
	s.[RelatedAmount2Label], s.[RelatedAmount2FillSql],
	s.[Direction3], s.[OperationId3Label], s.[OperationId3FillSql], s.[AccountId3Label], s.[AccountId3FillSql],
	s.[CustodyId3Label], s.[CustodyId3FillSql], s.[ResourceId3Label], s.[ResourceId3FillSql],
	s.[Amount3Label], s.[Amount3FillSql], s.[Value3Label], s.[Value3FillSql], s.[NoteId3Label], s.[NoteId3FillSql],
	s.[Reference3Label], s.[Reference3FillSql], s.[RelatedReference3Label], s.[RelatedReference3FillSql],
	s.[RelatedAgentId3Label], s.[RelatedAgentId3FillSql], s.[RelatedResourceId3Label], s.[RelatedResourceId3FillSql],
	s.[RelatedAmount3Label], s.[RelatedAmount3FillSql],
	s.[Direction4], s.[OperationId4Label], s.[OperationId4FillSql], s.[AccountId4Label], s.[AccountId4FillSql],
	s.[CustodyId4Label], s.[CustodyId4FillSql], s.[ResourceId4Label], s.[ResourceId4FillSql],
	s.[Amount4Label], s.[Amount4FillSql], s.[Value4Label], s.[Value4FillSql], s.[NoteId4Label], s.[NoteId4FillSql],
	s.[Reference4Label], s.[Reference4FillSql], s.[RelatedReference4Label], s.[RelatedReference4FillSql],
	s.[RelatedAgentId4Label], s.[RelatedAgentId4FillSql], s.[RelatedResourceId4Label], s.[RelatedResourceId4FillSql],
	s.[RelatedAmount4Label], s.[RelatedAmount4FillSql]
);
--OUTPUT deleted.*, $action, inserted.*; -- Does not work with triggers