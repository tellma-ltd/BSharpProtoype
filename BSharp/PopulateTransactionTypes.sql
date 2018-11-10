DECLARE @TransactionTypes TABLE([id] NVARCHAR(50) PRIMARY KEY, [IsInstant] bit)
INSERT @TransactionTypes ([Id], [IsInstant]) VALUES
	(N'PaymentIssueToSupplier',  1),
	(N'PaymentReceiptFromCustomer',  1),
	(N'EmployeeIncomeTax',  0),
	(N'InventoryTransfer',0),
	(N'Labor', 1),
	(N'LaborReceiptFromEmployee',  0),
	(N'LeaseIssueToCustomer', 0),
	(N'LeaseReceiptFromSupplier',  0),
	(N'ManualJournalVoucher',  1),
	(N'ManualJournalVoucherExtended',  0),
	(N'Purchase',  1),
	(N'PurchaseWitholdingTax',  1),
	(N'Sale',  1),
	(N'SaleWitholdingTax',  1),
	(N'StockIssueToCustomer',  1),
	(N'StockReceiptFromSupplier', 1);
INSERT INTO @Translations([Key], [Language], [Country], [Singular], [Plural]) VALUES
(N'PaymentIssueToSupplierEvent', N'EN', N'', N'Payment to Supplier', N'Payments to Suppliers'),
(N'PaymentIssueToSupplierEvent', N'AR', N'', N'دفعبة لمورد', N'دفعيات لموردين'),
(N'PaymentReceiptFromCustomerEvent', N'EN', N'', N'Payment from Customer', N'Payments from Customers'),
(N'PaymentReceiptFromCustomerEvent', N'AR', N'', N'دفعبة من زبون', N'دفعيات من زبائن');
MERGE dbo.TransactionTypes AS t
USING @TransactionTypes AS s
ON s.Id = t.Id --AND s.tenantId = t.tenantId
WHEN MATCHED AND s.IsInstant <> t.IsInstant THEN
UPDATE
	SET t.IsInstant = s.IsInstant
WHEN NOT MATCHED BY SOURCE THEN
        DELETE
WHEN NOT MATCHED BY TARGET THEN
        INSERT ([Id], [IsInstant])
        VALUES (s.[Id],s.[IsInstant]);

