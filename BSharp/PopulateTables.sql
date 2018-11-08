/*
Post-Deployment Script Template							
--------------------------------------------------------------------------------------
 This file contains SQL statements that will be appended to the build script.		
 Use SQLCMD syntax to include a file in the post-deployment script.			
 Example:      :r .\myfile.sql								
 Use SQLCMD syntax to reference a variable in the post-deployment script.		
 Example:      :setvar TableName MyTable							
               SELECT * FROM [$(TableName)]					
--------------------------------------------------------------------------------------
*/
-- DELETE FROM dbo.Accounts; Replaced with MERGE
DELETE FROM dbo.[TransactionSpecifications];
DELETE FROM dbo.EventTypes;
DELETE FROM dbo.[TransactionTypes];
DELETE FROM dbo.[AccountSpecifications];
DELETE FROM dbo.AccountTypes;
DELETE FROM dbo.AgentTypes;
DELETE FROM dbo.CustodyTypes;
DELETE FROM dbo.LocationTypes;
DELETE FROM dbo.Modes;
DELETE FROM dbo.OperationTypes;
DELETE FROM dbo.UnitsOfMeasure;
DELETE FROM dbo.Notes;
DELETE FROM dbo.States;

:r .\PopulateAccounts.sql

:r .\PopulateNotes.sql

EXEC dbo.adm_COA__Parents_Update;

INSERT [dbo].[States] ([Id], [Name]) VALUES 
	(N'Event', N'Event'), 
	(N'Order', N'Order'),
	(N'Plan', N'Plan'),
	(N'Request', N'Request'),
	(N'Template', N'Template');

INSERT [dbo].[TransactionTypes] ([Id], [IsInstant]) VALUES
	(N'CashIssueToSupplier',  1),
	(N'CashReceiptFromCustomer',  1),
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

:R .\PopulateTransactionSpecifications.sql

INSERT [dbo].[EventTypes] ([TransactionType], [State], [Name]) VALUES
	(N'CashIssueToSupplier', N'Event', N'Suppliers Payments'),
	(N'CashReceiptFromCustomer', N'Event', N'Customers Payments'),
	(N'EmployeeIncomeTax', N'Event', N'Employee Income Tax'),
	(N'InventoryTransfer', N'Event', N'Inventory Transfer'),
	(N'InventoryTransfer', N'Order', N'Inventory transfer Order'),
	(N'Labor', N'Event', N'Salary'),
	(N'LaborReceiptFromEmployee', N'Event', N'Labor'),
	(N'ManualJournalVoucher', N'Event', N'Journal Entry'),
	(N'Purchase', N'Event', N'Purchase Invoice'),
	(N'PurchaseWitholdingTax', N'Event', N'Withholding Tax'),
	(N'Sale', N'Event', N'Cash Sale'),
	(N'SaleWitholdingTax', N'Event', N'Withholding Tax'),
	(N'StockIssueToCustomer', N'Event', N'Issues'),
	(N'StockReceiptFromSupplier', N'Event', N'Receipts')

INSERT [dbo].[AccountSpecifications] ([Id]) VALUES 
	(N'Agent'),
	(N'Basic'),
	(N'Capital'),
	(N'Forex'),
	(N'Inventory'),
	(N'PPE');

INSERT [dbo].[AccountTypes] ([Id], [Name]) VALUES
	(N'Correction', N'Correction'),
	(N'Custom', N'Custom'),
	(N'Extension', N'Extension'),
	(N'Regulatory', N'Regulatory');

INSERT [dbo].[AgentTypes] ([Id], [Name]) VALUES 
	(N'Individual', N'Individual'),
	(N'Organization', N'Organization'),
	(N'OrganizationUnit', N'Organization Unit');

INSERT [dbo].[LocationTypes] ([Id], [Name]) VALUES
	(N'Address', N'Address'),
	(N'BankAccount', N'Bank Account'),
	(N'Farm', N'Farm'),
	(N'ProductionPoint', N'Production Point'),
	(N'Warehouse', N'Warehouse');

INSERT [dbo].[CustodyTypes] ([Id], [Name]) VALUES
	(N'Address', N'Address'),
	(N'Agent', N'Agent'),
	(N'BankAccount', N'Bank Account'),
	(N'Individual', N'Individual'),
	(N'Organization', N'Organization'),
	(N'OrganizationUnit', N'Organization Unit'),
	(N'ProductionPoint', N'Production Point'),
	(N'Warehouse', N'Warehouse');
	   
INSERT [dbo].[Modes] ([Id], [Name]) VALUES
	(N'Draft', N'Draft'),
	(N'Posted', N'Posted'),
	(N'Verified', N'Verified'),
	(N'Void', N'Void');

INSERT [dbo].[OperationTypes] ([Id], [Name]) VALUES
	(N'BusinessEntity', N'Global'),
	(N'Investment', N'Investment'),
	(N'OperatingSegment', N'Operating Segment'),
	(N'Project', N'Project');

INSERT [dbo].[UnitsOfMeasure] ([Id], [UnitType], [Name], [UnitAmount], [BaseAmount], [IsActive], [AsOfDateTime]) VALUES
	(N'AED', N'Money', N'AE Dirhams', 3.67, 1, 0, CAST(N'01.01.2000' AS DateTimeOffset)),
	(N'd', N'Time', N'Day', 1, 86400, 1, CAST(N'01.01.2000' AS DateTimeOffset)),
	(N'dozen', N'count', N'Dozen', 1, 12, 1, CAST(N'01.01.2000' AS DateTimeOffset)),
	(N'ea', N'Pure', N'Each', 1, 1, 1, CAST(N'01.01.2000' AS DateTimeOffset)),
	(N'ETB', N'Money', N'ET Birr', 27.8, 1, 1, CAST(N'01.01.2000' AS DateTimeOffset)),
	(N'g', N'Mass', N'Gram', 1, 1, 0, CAST(N'01.01.2000' AS DateTimeOffset)),
	(N'hr', N'Time', N'Hour', 1, 3600, 1, CAST(N'01.01.2000' AS DateTimeOffset)),
	(N'in', N'Distance', N'inch', 1, 2.541, 0, CAST(N'01.01.2000' AS DateTimeOffset)),
	(N'kg', N'Mass', N'Kilogram', 1, 1000, 1, CAST(N'01.01.2000' AS DateTimeOffset)),
	(N'ltr', N'volume', N'Liter', 1, 1, 1, CAST(N'01.01.2000' AS DateTimeOffset)),
	(N'm', N'Distance', N'meter', 1, 1, 1, CAST(N'01.01.2000' AS DateTimeOffset)),
	(N'min', N'Time', N'minute', 1, 60, 0, CAST(N'01.01.2000' AS DateTimeOffset)),
	(N'mo', N'Time', N'Month', 1, 2592000, 1, CAST(N'01.01.2000' AS DateTimeOffset)),
	(N'mt', N'Mass', N'Metric ton', 1, 1000000, 1, CAST(N'01.01.2000' AS DateTimeOffset)),
	(N'pcs', N'count', N'Pieces', 1, 1, 1, CAST(N'01.01.2000' AS DateTimeOffset)),
	(N's', N'Time', N'second', 1, 1, 0, CAST(N'01.01.2000' AS DateTimeOffset)),
	(N'share', N'Pure', N'Shares', 1, 1, 1, CAST(N'01.01.2000' AS DateTimeOffset)),
	(N'USD', N'Money', N'US Dollars', 1, 1, 1, CAST(N'01.01.2000' AS DateTimeOffset)),
	(N'usg', N'Volume', N'US Gallon', 1, 3.785411784, 0, CAST(N'01.01.2000' AS DateTimeOffset)),
	(N'wd', N'Time', N'work day', 1, 8, 1, CAST(N'01.01.2000' AS DateTimeOffset)),
	(N'wk', N'Time', N'week', 1, 604800, 0, CAST(N'01.01.2000' AS DateTimeOffset)),
	(N'wmo', N'Time', N'work month', 1, 1248, 1, CAST(N'01.01.2000' AS DateTimeOffset)),
	(N'wwk', N'Time', N'work week', 1, 48, 1, CAST(N'01.01.2000' AS DateTimeOffset)),
	(N'wyr', N'Time', N'work year', 1, 14976, 1, CAST(N'01.01.2000' AS DateTimeOffset)),
	(N'yr', N'Time', N'Year', 1, 31104000, 0, CAST(N'01.01.2000' AS DateTimeOffset));
