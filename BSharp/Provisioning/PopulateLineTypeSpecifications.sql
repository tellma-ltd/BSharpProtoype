DECLARE @LineTypeSpecifications TABLE (
	[LineType]							NVARCHAR (255)	NOT NULL,
	[EntryNumber]						TINYINT			NOT NULL,
	[Definition]						NVARCHAR (255)	NOT NULL DEFAULT(N'Calculation'),
	[OperationCalculationBase]			NVARCHAR (255)	DEFAULT(N'Input'),
	[OperationExpression]				NVARCHAR (MAX),
	[AccountCalculationBase]			NVARCHAR (255)	DEFAULT(N'Input'),
	[AccountExpression]					NVARCHAR (MAX),
	[CustodyCalculationBase]			NVARCHAR (255)	DEFAULT(N'Input'),
	[CustodyExpression]					NVARCHAR (MAX),
	[ResourceCalculationBase]			NVARCHAR (255)	DEFAULT(N'Input'),
	[ResourceExpression]				NVARCHAR (MAX),
	[DirectionCalculationBase]			NVARCHAR (255)	DEFAULT(N'Input'),
	[DirectionExpression]				NVARCHAR (MAX),
	[AmountCalculationBase]				NVARCHAR (255)	DEFAULT(N'Input'),
	[AmountExpression]					NVARCHAR (MAX),
	[ValueCalculationBase]				NVARCHAR (255)	DEFAULT(N'Input'),
	[ValueExpression]					NVARCHAR (MAX),
	[NoteCalculationBase]				NVARCHAR (255)	DEFAULT(N'Input'),
	[NoteExpression]					NVARCHAR (MAX),
	[ReferenceCalculationBase]			NVARCHAR (255)	DEFAULT(N'Input'),
	[ReferenceExpression]				NVARCHAR (MAX),
	[RelatedReferenceCalculationBase]	NVARCHAR (255)	DEFAULT(N'Input'),
	[RelatedReferenceExpression]		NVARCHAR (MAX),
	[RelatedAgentCalculationBase]		NVARCHAR (255)	DEFAULT(N'Input'),
	[RelatedAgentExpression]			NVARCHAR (MAX),
	[RelatedResourceCalculationBase]	NVARCHAR (255)	DEFAULT(N'Input'),
	[RelatedResourceExpression]			NVARCHAR (MAX),
	[RelatedAmountCalculationBase]		NVARCHAR (255)	DEFAULT(N'Input'),
	[RelatedAmountExpression]			NVARCHAR (MAX),
	PRIMARY KEY CLUSTERED ([LineType] ASC, [EntryNumber] ASC, [Definition] ASC)
);
INSERT @LineTypeSpecifications (
	[LineType],		[EntryNumber], [AccountCalculationBase], [AccountExpression], [ResourceCalculationBase], [ResourceExpression], [DirectionCalculationBase], [DirectionExpression], [NoteCalculationBase], [NoteExpression]) VALUES
	(N'IssueOfEquity', 1,			N'Equal',				N'BalancesWithBanks',	N'Input',					NULL,				N'Equal',					N'+1',					N'Equal',			N'ProceedsFromIssuingShares'),
	(N'IssueOfEquity', 2,			N'Equal',				N'IssuedCapital',		N'FromCode',				N'CMNSTCK',			N'Equal',					N'-1',					N'Equal',			N'IssueOfEquity');

INSERT @LineTypeSpecifications (
	[LineType],		[EntryNumber], [AccountCalculationBase], [AccountExpression], [ResourceCalculationBase], [ResourceExpression], [DirectionCalculationBase], [DirectionExpression],  [AmountCalculationBase], [AmountExpression], [NoteCalculationBase], [NoteExpression]) VALUES
	(N'PaymentIssueToSupplier', 1,  N'Equal', N'CurrentPayablesToTradeSuppliers',	N'FromSQL', N'[dbo].fn_FunctionalCurrency()',	N'Equal',					N'+1',					N'Input',				NULL,				N'Equal',			NULL),
	(N'PaymentIssueToSupplier', 2,	N'Equal',				N'BalancesWithBanks',	N'FromSQL', N'[dbo].fn_FunctionalCurrency()',	N'Equal',					N'-1',					N'FromEntry',			N'1',				N'Equal',			N'PaymentsToSuppliersForGoodsAndServices');
	/*
INSERT @LineTypeSpecifications (
	[LineType], [EntryNumber], [Definition], [Operation], [Account], [Custody], [ResourceExpression], [Direction], [Amount], [Value], [Note], [RelatedReference], [RelatedAgent], [RelatedResource], [RelatedAmount]) VALUES	
	(N'IssueOfEquity', 1, N'Label', NULL, NULL, N'Bank Account', NULL, NULL, N'Payment', NULL, NULL, NULL, NULL, NULL, NULL),
	(N'IssueOfEquity', 2, N'Label', NULL, NULL, N'Customer',	NULL, NULL,		NULL, NULL, NULL, NULL, NULL, NULL, NULL);
	(N'PaymentIssueToSupplier', 1, N'Label', NULL, NULL, N'Supplier', N'Currency', NULL, N'Amount', NULL, NULL, NULL, NULL, NULL, NULL),
	(N'PaymentIssueToSupplier', 1, N'Validation', NULL, N'''PurchaseContracts''', NULL, NULL, N'1', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(N'PaymentIssueToSupplier', 2, N'Label', NULL, NULL, N'Cash Custody', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(N'PaymentIssueToSupplier', 2, N'Validation', NULL, N'''CashOnHand''', NULL, NULL, N'-1', NULL, NULL, N'''PaymentsToSuppliersForGoodsAndServices''', NULL, NULL, NULL, NULL),
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
AND t.[EntryNumber] = s.[EntryNumber] 
AND t.[Definition] = s.[Definition]
WHEN MATCHED AND
(
	t.[OperationCalculationBase]				<>	s.[OperationCalculationBase]				OR
	ISNULL(t.[OperationExpression], -1)			<>	ISNULL(s.[OperationExpression], -1)			OR
	t.[AccountCalculationBase]					<>	s.[AccountCalculationBase]					OR
	ISNULL(t.[AccountExpression], -1)			<>	ISNULL(s.[AccountExpression], -1)			OR
	t.[CustodyCalculationBase]					<>	s.[CustodyCalculationBase]					OR
	ISNULL(t.[CustodyExpression], -1)			<>	ISNULL(s.[CustodyExpression], -1)			OR
	t.[ResourceCalculationBase]					<>	s.[ResourceCalculationBase]					OR
	ISNULL(t.[ResourceExpression], -1)			<>	ISNULL(s.[ResourceExpression], -1)			OR
	t.[DirectionCalculationBase]				<>	s.[DirectionCalculationBase]				OR
	ISNULL(t.[DirectionExpression], -1)			<>	ISNULL(s.[DirectionExpression], -1)			OR
	t.[AmountCalculationBase]					<>	s.[AmountCalculationBase]					OR
	ISNULL(t.[AmountExpression], -1)			<>	ISNULL(s.[AmountExpression], -1)			OR
	t.[ValueCalculationBase]					<>	s.[ValueCalculationBase]					OR
	ISNULL(t.[ValueExpression], -1)				<>	ISNULL(s.[ValueExpression], -1)				OR
	t.[NoteCalculationBase]						<>	s.[NoteCalculationBase]						OR
	ISNULL(t.[NoteExpression], -1)				<>	ISNULL(s.[NoteExpression], -1)				OR
	t.[RelatedReferenceCalculationBase]			<>	s.[RelatedReferenceCalculationBase]			OR
	ISNULL(t.[RelatedReferenceExpression], -1)	<>	ISNULL(s.[RelatedReferenceExpression], -1)	OR
	t.[RelatedAgentCalculationBase]				<>	s.[RelatedAgentCalculationBase]				OR
	ISNULL(t.[RelatedAgentExpression], -1)		<>	ISNULL(s.[RelatedAgentExpression], -1)		OR
	t.[RelatedResourceCalculationBase]			<>	s.[RelatedResourceCalculationBase]			OR
    ISNULL(t.[RelatedResourceExpression], -1)	<>	ISNULL(s.[RelatedResourceExpression], -1)	OR
	t.[RelatedAmountCalculationBase]			<>	s.[RelatedAmountCalculationBase]			OR
	ISNULL(t.[RelatedAmountExpression], -1)		<>	ISNULL(s.[RelatedAmountExpression], -1)
) THEN
UPDATE SET
  t.[OperationExpression]				=	s.[OperationExpression],
  t.[AccountExpression]					=	s.[AccountExpression],
  t.[CustodyExpression]					=	s.[CustodyExpression],
  t.[ResourceExpression]				=	s.[ResourceExpression],
  t.[DirectionExpression]				=	s.[DirectionExpression],
  t.[AmountExpression]					=	s.[AmountExpression],
  t.[ValueExpression]					=	s.[ValueExpression],
  t.[NoteExpression]					=	s.[NoteExpression],
  t.[RelatedReferenceExpression]		=	s.[RelatedReferenceExpression],
  t.[RelatedAgentExpression]			=	s.[RelatedAgentExpression],
  t.[RelatedResourceExpression]			=	s.[RelatedResourceExpression],
  t.[RelatedAmountExpression]			=	s.[RelatedAmountExpression],

  t.[OperationCalculationBase]			=	s.[OperationCalculationBase],
  t.[AccountCalculationBase]			=	s.[AccountCalculationBase],
  t.[CustodyCalculationBase]			=	s.[CustodyCalculationBase],
  t.[ResourceCalculationBase]			=	s.[ResourceCalculationBase],
  t.[DirectionCalculationBase]			=	s.[DirectionCalculationBase],
  t.[AmountCalculationBase]				=	s.[AmountCalculationBase],
  t.[ValueCalculationBase]				=	s.[ValueCalculationBase],
  t.[NoteCalculationBase]				=	s.[NoteCalculationBase],
  t.[RelatedReferenceCalculationBase]	=	s.[RelatedReferenceCalculationBase],
  t.[RelatedAgentCalculationBase]		=	s.[RelatedAgentCalculationBase],
  t.[RelatedResourceCalculationBase]	=	s.[RelatedResourceCalculationBase],
  t.[RelatedAmountCalculationBase]		=	s.[RelatedAmountCalculationBase]
WHEN NOT MATCHED BY SOURCE THEN
    DELETE
WHEN NOT MATCHED BY TARGET THEN
INSERT ([TenantId], [LineType], [EntryNumber], [Definition],
	[OperationExpression], [AccountExpression], [CustodyExpression], [ResourceExpression], 
	[DirectionExpression], [AmountExpression], [ValueExpression], [NoteExpression], [RelatedReferenceExpression], 
	[RelatedAgentExpression], [RelatedResourceExpression], [RelatedAmountExpression],
	[OperationCalculationBase], [AccountCalculationBase], [CustodyCalculationBase], [ResourceCalculationBase], 
	[DirectionCalculationBase], [AmountCalculationBase],  [ValueCalculationBase],	 [NoteCalculationBase], [RelatedReferenceCalculationBase], 
	[RelatedAgentCalculationBase], [RelatedResourceCalculationBase], [RelatedAmountCalculationBase]
	)
VALUES(@TenantId, s.[LineType], s.[EntryNumber], s.[Definition],
	s.[OperationExpression], s.[AccountExpression], s.[CustodyExpression], s.[ResourceExpression], 
	s.[DirectionExpression], s.[AmountExpression],  s.[ValueExpression], s.[NoteExpression], s.[RelatedReferenceExpression], 
	s.[RelatedAgentExpression], s.[RelatedResourceExpression], s.[RelatedAmountExpression],
	s.[OperationCalculationBase], s.[AccountCalculationBase], s.[CustodyCalculationBase], s.[ResourceCalculationBase], 
	s.[DirectionCalculationBase], s.[AmountCalculationBase],  s.[ValueCalculationBase],	 s.[NoteCalculationBase], s.[RelatedReferenceCalculationBase], 
	s.[RelatedAgentCalculationBase], s.[RelatedResourceCalculationBase], s.[RelatedAmountCalculationBase]
	);
--OUTPUT deleted.*, $action, inserted.*; -- Does not work with triggers
