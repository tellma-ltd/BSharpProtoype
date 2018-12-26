DECLARE @TransactionSpecifications TABLE (
  [TransactionType]     NVARCHAR (50) NOT NULL,
  [EntryNumber]   TINYINT    NOT NULL,
  [Definition]    NVARCHAR (50) NOT NULL,
  [Operation]    NVARCHAR (255) NULL,
  [Account]     NVARCHAR (255) NULL,
  [Custody]     NVARCHAR (255) NULL,
  [Resource]     NVARCHAR (255) NULL,
  [Direction]    NVARCHAR (255) NULL,
  [Amount]      NVARCHAR (255) NULL,
  [Value]      NVARCHAR (255) NULL,
  [Note]       NVARCHAR (255) NULL,
  [RelatedReference] NVARCHAR (255) NULL,
  [RelatedAgent]   NVARCHAR (255) NULL,
  [RelatedResource] NVARCHAR (255) NULL,
  [RelatedAmount]  NVARCHAR (255) NULL,
  [RelatedUDLMember] NVARCHAR (255) NULL,
  PRIMARY KEY CLUSTERED ([TransactionType] ASC, [EntryNumber] ASC, [Definition] ASC)
);
INSERT @TransactionSpecifications ([TransactionType], [EntryNumber], [Definition], [Operation], [Account], [Custody], [Resource], [Direction], [Amount], [Value], [Note], [RelatedReference], [RelatedAgent], [RelatedResource], [RelatedAmount], [RelatedUDLMember]) VALUES
	(N'PaymentIssueToSupplier', 1, N'Calculation', NULL, N'''CurrentPayablesToTradeSuppliers''', NULL, N'[dbo].fn_FunctionalCurrency()', N'1', NULL, N'[dbo].Amount(1,@Entries)', NULL, NULL, NULL, NULL, NULL, NULL),
	(N'PaymentIssueToSupplier', 1, N'Label', NULL, NULL, N'Supplier', N'Currency', NULL, N'Amount', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(N'PaymentIssueToSupplier', 1, N'Validation', NULL, N'''PurchaseContracts''', NULL, NULL, N'1', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(N'PaymentIssueToSupplier', 2, N'Calculation', NULL, N'''CashOnHand''', NULL, N'[dbo].fn_FunctionalCurrency()', N'-1', N'[dbo].Amount(1,@Entries)', N'[dbo].Amount(2,@Entries)', N'''PaymentsToSuppliersForGoodsAndServices''', NULL, NULL, NULL, NULL, NULL),
	(N'PaymentIssueToSupplier', 2, N'Label', NULL, NULL, N'Cash Custody', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(N'PaymentIssueToSupplier', 2, N'Validation', NULL, N'''CashOnHand''', NULL, NULL, N'-1', NULL, NULL, N'''PaymentsToSuppliersForGoodsAndServices''', NULL, NULL, NULL, NULL, NULL),
	(N'PaymentReceiptFromCustomer', 1, N'Calculation', NULL, N'''CashOnHand''', NULL, N'[dbo].fn_FunctionalCurrency()', N'1', NULL, N'[dbo].Amount(1,@Entries)', N'''ReceiptsFromSalesOfGoodsAndRenderinfServices''', NULL, NULL, NULL, NULL, NULL),
	(N'PaymentReceiptFromCustomer', 1, N'Label', NULL, NULL, N'Cash Custody', NULL, NULL, N'Payment', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(N'PaymentReceiptFromCustomer', 2, N'Calculation', NULL, N'''SalesContracts''', NULL, N'[dbo].fn_FunctionalCurrency()', N'-1', N'[dbo].Amount(1,@Entries)', N'[dbo].Amount(2,@Entries)', NULL, NULL, NULL, NULL, NULL, NULL),
	(N'PaymentReceiptFromCustomer', 2, N'Label', NULL, NULL, N'Customer', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(N'EmployeeIncomeTax', 1, N'Calculation', NULL, N'''EmploymentContracts''', NULL, N'[dbo].fn_FunctionalCurrency()', N'1', NULL, N'[dbo].Amount(1,@Entries)', NULL, NULL, NULL, NULL, NULL, NULL),
	(N'EmployeeIncomeTax', 1, N'Label', NULL, NULL, N'Employee', N'Currency', NULL, N'Income Tax', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(N'EmployeeIncomeTax', 1, N'Validation', NULL, N'''CurrentPayablesToEmployees''', NULL, NULL, N'1', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(N'EmployeeIncomeTax', 2, N'Calculation', NULL, N'''CurrentEmployeeIncomeTaxPayable''', N'[dbo].fn_Settings(''TaxAuthority'')', N'[dbo].fn_FunctionalCurrency()', N'-1', N'[dbo].Amount(1,@Entries)', N'[dbo].Amount(2,@Entries)', NULL, NULL, N'[dbo].Custody(1,@Entries)', NULL, NULL, NULL),
	(N'EmployeeIncomeTax', 2, N'Label', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(N'EmployeeIncomeTax', 2, N'Validation', NULL, N'''CurrentEmployeeIncomeTaxPayable''', NULL, NULL, N'-1', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(N'Labor', 1, N'Calculation', NULL, N'''ShorttermEmployeeBenefitsAccruals''', NULL, N'[dbo].fn_Settings(''Labor'')', N'1', N'208', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(N'Labor', 1, N'Label', NULL, NULL, NULL, N'Employee', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(N'Labor', 1, N'Validation', NULL, N'''EmploymentContracts''', NULL, NULL, N'1', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(N'Labor', 2, N'Calculation', NULL, N'''EmploymentContracts''', N'[dbo].Custody(1,@Entries)', N'[dbo].fn_FunctionalCurrency()', N'-1', NULL, N'[dbo].Amount(2,@Entries)', NULL, N'''Basic''', NULL, NULL, NULL, NULL),
	(N'Labor', 2, N'Label', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(N'Labor', 2, N'Validation', NULL, N'''EmploymentContracts''', NULL, NULL, N'-1', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(N'Labor', 3, N'Calculation', NULL, N'''EmploymentContracts''', N'[dbo].Custody(1,@Entries)', N'[dbo].fn_FunctionalCurrency()', N'-1', NULL, N'[dbo].Amount(3,@Entries)', NULL, N'''Transportation''', NULL, NULL, NULL, NULL),
	(N'LaborReceiptFromEmployee', 1, N'Calculation', NULL, N'''AdministrativeExpense''', NULL, N'[dbo].fn_Settings(''Labor'')', N'1', NULL, NULL, N'''WagesAndSalaries''', NULL, NULL, NULL, NULL, NULL),
	(N'LaborReceiptFromEmployee', 1, N'Label', NULL, NULL, N'Employee', N'Salary Component', NULL, N'Quantity', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(N'LaborReceiptFromEmployee', 1, N'Validation', NULL, N'''AdministrativeExpense''', N'0', NULL, N'1', NULL, NULL, N'''WagesAndSalaries''', NULL, NULL, NULL, NULL, NULL),
	(N'LaborReceiptFromEmployee', 2, N'Calculation', NULL, N'''EmploymentContracts''', NULL, N'[dbo].Resource(1, @Entries)', N'-1', N'[dbo].Amount(1,@Entries)', N'@Bulk:@AccountId = N''EmploymentContracts'', @Direction = 1;', NULL, NULL, NULL, NULL, NULL, NULL),
	(N'LaborReceiptFromEmployee', 2, N'Label', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(N'LaborReceiptFromEmployee', 2, N'Validation', NULL, N'''EmploymentContracts''', NULL, NULL, N'-1', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(N'Purchase', 1, N'Calculation', NULL, N'''GoodsAndServicesReceivedFromSupplierButNotBilled''', NULL, NULL, N'1', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(N'Purchase', 1, N'Label', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(N'Purchase', 1, N'Validation', NULL, N'''CurrentValueAddedTaxReceivables''', N'[dbo].fn_Settings(''TaxAuthority'')', NULL, N'1', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(N'Purchase', 2, N'Calculation', NULL, N'''CurrentValueAddedTaxReceivables''', N'[dbo].fn_Settings(''TaxAuthority'')', N'[dbo].fn_FunctionalCurrency()', N'1', NULL, N'[dbo].Amount(2,@Entries)', NULL, NULL, N'[dbo].Custody(1,@Entries)', N'[dbo].Resource(1, @Entries)', N'[dbo].Value(1,@Entries)', NULL),
	(N'Purchase', 2, N'Label', NULL, NULL, NULL, N'Supplier', NULL, N'VAT', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(N'Purchase', 2, N'Validation', NULL, N'''PurchasesVAT''', NULL, NULL, N'-1', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(N'Purchase', 3, N'Calculation', NULL, N'''CurrentPayablesToTradeSuppliers''', N'[dbo].Custody(1,@Entries)', N'[dbo].fn_FunctionalCurrency()', N'-1', N'[dbo].Amount(2, @Entries)+[dbo].RelatedAmount(2, @Entries)', N'[dbo].Amount(3,@Entries)', NULL, NULL, NULL, NULL, NULL, NULL),
	(N'PurchaseWitholdingTax', 1, N'Calculation', NULL, N'''CurrentPayablesToTradeSuppliers''', NULL, N'[dbo].fn_FunctionalCurrency()', N'1', NULL, N'[dbo].Amount(1,@Entries)', NULL, NULL, NULL, NULL, NULL, NULL),
	(N'PurchaseWitholdingTax', 1, N'Label', NULL, NULL, NULL, N'Supplier', NULL, N'Tax Withtheld', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(N'PurchaseWitholdingTax', 1, N'Validation', NULL, N'''PurchaseContracts''', NULL, NULL, N'1', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(N'PurchaseWitholdingTax', 2, N'Calculation', NULL, N'''CurrentWithholdingTaxPayable''', N'[dbo].fn_Settings(''TaxAuthority'')', N'[dbo].fn_FunctionalCurrency()', N'-1', N'[dbo].Amount(1,@Entries)', N'[dbo].Amount(2,@Entries)', NULL, NULL, N'[dbo].Custody(1,@Entries)', NULL, NULL, NULL),
	(N'PurchaseWitholdingTax', 2, N'Label', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(N'PurchaseWitholdingTax', 2, N'Validation', NULL, N'''CurrentWithholdingTaxPayable''', N'[dbo].fn_Settings(''TaxAuthority'')', NULL, N'-1', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(N'Sale', 1, N'Calculation', NULL, N'''GoodsAndServicesDeliveredToCustomerButNotBilled''', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(N'StockReceiptFromSupplier', 1, N'Calculation', NULL, N'''OtherInventories''', NULL, NULL, N'1', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(N'StockReceiptFromSupplier', 1, N'Label', NULL, NULL, N'Store', N'Item', NULL, N'Quantity', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(N'StockReceiptFromSupplier', 1, N'Validation', NULL, N'''OtherInventories''', NULL, NULL, N'1', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(N'StockReceiptFromSupplier', 2, N'Calculation', NULL, N'''GoodsAndServicesReceivedFromSupplierButNotBilled''', NULL, N'[dbo].Resource(1, @Entries)', N'-1', N'[dbo].Amount(1,@Entries)', N'@Bulk:@AccountId = N''PurchaseContracts'', @Direction = 1;', NULL, NULL, NULL, NULL, NULL, NULL),
	(N'StockReceiptFromSupplier', 2, N'Label', NULL, NULL, N'Supplier', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(N'StockReceiptFromSupplier', 2, N'Validation', NULL, N'''PurchaseContracts''', NULL, NULL, N'-1', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
MERGE [dbo].TransactionSpecifications AS t
USING @TransactionSpecifications AS s
ON s.[TransactionType] = t.[TransactionType] 
AND t.[EntryNumber] = s.[EntryNumber] 
AND t.[Definition] = s.[Definition]	 -- AND s.tenantId = t.tenantId
WHEN MATCHED AND
(
  t.[Operation]			<>	s.[Operation]			OR
  t.[Account]				<>	s.[Account]				OR
  t.[Custody]				<>	s.[Custody]				OR
  t.[Resource]			<>	s.[Resource]			OR
  t.[Direction]			<>	s.[Direction]			OR
  t.[Amount]				<>	s.[Amount]				OR
  t.[Value]				<>	s.[Value]				OR
  t.[Note]				<>	s.[Note]				OR
  t.[RelatedReference]	<>	s.[RelatedReference]	OR
  t.[RelatedAgent]		<>	s.[RelatedAgent]		OR
  t.[RelatedResource]		<>	s.[RelatedResource]		OR
  t.[RelatedAmount]		<>	s.[RelatedAmount]		OR
  t.[RelatedUDLMember]	<>	s.[RelatedUDLMember]
) THEN
UPDATE SET
  t.[Operation]			=	s.[Operation]			,
  t.[Account]				=	s.[Account]				,
  t.[Custody]				=	s.[Custody]				,
  t.[Resource]			=	s.[Resource]			,
  t.[Direction]			=	s.[Direction]			,
  t.[Amount]				=	s.[Amount]				,
  t.[Value]				=	s.[Value]				,
  t.[Note]				=	s.[Note]				,
  t.[RelatedReference]	=	s.[RelatedReference]	,
  t.[RelatedAgent]		=	s.[RelatedAgent]		,
  t.[RelatedResource]		=	s.[RelatedResource]		,
  t.[RelatedAmount]		=	s.[RelatedAmount]		,
  t.[RelatedUDLMember]	=	s.[RelatedUDLMember]
WHEN NOT MATCHED BY SOURCE THEN
    DELETE
WHEN NOT MATCHED BY TARGET THEN
INSERT ([TransactionType], [EntryNumber], [Definition], [Operation], [Account], [Custody], [Resource], [Direction],
	[Amount], [Value], [Note], [RelatedReference], [RelatedAgent], [RelatedResource], [RelatedAmount], [RelatedUDLMember])
VALUES(	s.[TransactionType], s.[EntryNumber], s.[Definition], s.[Operation], s.[Account], s.[Custody], s.[Resource], s.[Direction], 
		s.[Amount], s.[Value], s.[Note], s.[RelatedReference], s.[RelatedAgent], s.[RelatedResource], s.[RelatedAmount], s.[RelatedUDLMember]);
--OUTPUT deleted.*, $action, inserted.*; -- Does not work with triggers
