DECLARE @TransactionTypes TABLE([id] NVARCHAR(255) PRIMARY KEY)
INSERT @TransactionTypes ([Id]) VALUES
	(N'CapitalInvestment'),
	(N'PaymentIssueToSupplier'),
	(N'PaymentReceiptFromCustomer'),
	(N'EmployeeIncomeTax'),
	(N'InventoryTransfer'),
	(N'Labor'),
	(N'LaborReceiptFromEmployee'),
	(N'LeaseIssueToCustomer'),
	(N'LeaseReceiptFromSupplier'),
	(N'ManualJournalVoucher'),
	(N'Purchase'),
	(N'PurchaseWitholdingTax'),
	(N'Sale'),
	(N'SaleWitholdingTax'),
	(N'StockIssueToCustomer'),
	(N'StockReceiptFromSupplier');

MERGE [dbo].TransactionTypes AS t
USING @TransactionTypes AS s
ON s.Id = t.Id
WHEN NOT MATCHED BY SOURCE THEN
    DELETE
WHEN NOT MATCHED BY TARGET THEN
    INSERT ([Id])
    VALUES (s.[Id]);

