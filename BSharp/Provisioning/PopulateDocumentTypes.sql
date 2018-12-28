DECLARE @DocumentTypes TABLE([id] NVARCHAR(255) PRIMARY KEY)
INSERT @DocumentTypes ([Id]) VALUES
	(N'ManualJournal'),
	(N'CapitalInvestment'),
	(N'PaymentIssueToSupplier'),
	(N'PaymentReceiptFromCustomer'),
	(N'EmployeeIncomeTax'),
	(N'InventoryTransfer'),
	(N'Labor'),
	(N'LaborReceiptFromEmployee'),
	(N'LeaseIssueToCustomer'),
	(N'LeaseReceiptFromSupplier'),
	(N'Purchase'),
	(N'PurchaseWitholdingTax'),
	(N'Sale'),
	(N'SaleWitholdingTax'),
	(N'StockIssueToCustomer'),
	(N'StockReceiptFromSupplier');

DECLARE @LineTypes TABLE([id] NVARCHAR(255) PRIMARY KEY)
INSERT @LineTypes ([Id]) VALUES
	(N'ManualJournalLine');

MERGE [dbo].DocumentTypes AS t
USING @DocumentTypes AS s
ON s.Id = t.Id
WHEN NOT MATCHED BY SOURCE THEN
    DELETE
WHEN NOT MATCHED BY TARGET THEN
    INSERT ([TenantId], [Id])
    VALUES (@TenantId, s.[Id]);

MERGE [dbo].LineTypes AS t
USING @LineTypes AS s
ON s.Id = t.Id
WHEN NOT MATCHED BY SOURCE THEN
    DELETE
WHEN NOT MATCHED BY TARGET THEN
    INSERT ([TenantId], [Id])
    VALUES (@TenantId, s.[Id]);