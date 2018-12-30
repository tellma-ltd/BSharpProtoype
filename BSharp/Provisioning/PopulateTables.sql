EXEC sp_set_session_context 'Tenantid', 106;
DECLARE @TenantId int = CONVERT(INT, SESSION_CONTEXT(N'TenantId'));
--:r .\PopulateMeasurementUnits.sql -- WRONG. To provision, use the code in Testing instead
--:r .\PopulateAccounts.sql
--:r .\PopulateNotes.sql
--EXEC [dbo].[adm_Accounts_Notes__Update];
--:r .\PopulateAccountsNotes.sql

:r .\PopulateDocumentTypes.sql
:r .\PopulateLineTypeSpecifications.sql



-- We may be able to get rid of it, and construct the [Name] key on the fly...
/*
INSERT [dbo].[DocumentTypes] ([DocumentType], [State], [NameKey]) VALUES
	(N'PaymentIssueToSupplier', N'Voucher', N'PaymentIssueToSupplierEvent'),
	(N'PaymentReceiptFromCustomer', N'Voucher', N'PaymentReceiptFromCustomerEvent'),
	(N'EmployeeIncomeTax', N'Voucher', N'Employee Income Tax'),
	(N'InventoryTransfer', N'Voucher', N'Inventory Transfer'),
	(N'InventoryTransfer', N'Order', N'Inventory transfer Order'),
	(N'Labor', N'Voucher', N'Salary'),
	(N'LaborReceiptFromEmployee', N'Voucher', N'Labor'),
	(N'ManualJournal', N'Voucher', N'Journal Entry'),
	(N'Purchase', N'Voucher', N'Purchase Invoice'),
	(N'PurchaseWitholdingTax', N'Voucher', N'Withholding Tax'),
	(N'Sale', N'Voucher', N'Cash Sale'),
	(N'SaleWitholdingTax', N'Voucher', N'Withholding Tax'),
	(N'StockIssueToCustomer', N'Voucher', N'Issues'),
	(N'StockReceiptFromSupplier', N'Voucher', N'Receipts')
*/
-- We may be able to auto concatenate the table [Name] to the string, or simply dismiss it, or use Module as a qualifier
-- instead of table