DECLARE @Translations TABLE
(
	[Key]			nvarchar(255) NOT NULL,
    [Language]		nchar (2) NOT NULL,
    [Country]       nchar(2)  NOT NULL DEFAULT N'',
	[Singular]		nvarchar(1024) NOT NULL,
	[Plural]		nvarchar(1024) NULL,
    PRIMARY KEY NONCLUSTERED ([Key] ASC, [Language] ASC, [Country] ASC)
);

:r .\PopulateAccounts.sql
:r .\PopulateNotes.sql
:r .\PopulateTransactionTypes.sql
:r .\PopulateTransactionSpecifications.sql
:r .\PopulateCustodyTypes.sql
:r .\PopulateOperationTypes.sql

EXEC dbo.adm_COA__Parents_Update;

-- We may be able to get rid of it, and construct the name key on the fly...
/*
INSERT [dbo].[DocumentTypes] ([TransactionType], [State], [NameKey]) VALUES
	(N'PaymentIssueToSupplier', N'Event', N'PaymentIssueToSupplierEvent'),
	(N'PaymentReceiptFromCustomer', N'Event', N'PaymentReceiptFromCustomerEvent'),
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
*/
--  We may be able to auto concatenate the table name to the string, or simply dismiss it, or use Module as a qualifier
-- instead of table

IF NOT Exists(SELECT * FROM [dbo].[AccountSpecifications])
INSERT [dbo].[AccountSpecifications] ([Id]) VALUES 
	(N'Agent'),
	(N'Basic'),
	(N'Capital'),
	(N'Forex'),
	(N'Inventory'),
	(N'PPE');

IF NOT Exists(SELECT * FROM [dbo].[Modes])
INSERT [dbo].[Modes] ([Id]) VALUES
	(N'Draft'),
	(N'Posted'),
	(N'Verified'),
	(N'Void');

IF NOT Exists(SELECT * FROM [dbo].[UnitsOfMeasure])
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
	
MERGE dbo.Translations AS t
USING @Translations AS s
ON s.[Key] = t.[Key] AND s.[Language] = t.[Language] AND s.[Country] = t.[Country] --AND s.tenantId = t.tenantId
WHEN MATCHED AND
(
    t.[Singular]	<>	s.[Singular]			OR
    t.[Plural]		<>	s.[Plural]
) THEN
UPDATE SET
    t.[Singular]	=	s.[Singular],
    t.[Plural]		=	s.[Plural]
WHEN NOT MATCHED BY SOURCE THEN
        DELETE
WHEN NOT MATCHED BY TARGET THEN
        INSERT ([Key], [Language], [Country], [Singular], [Plural])
        VALUES (s.[Key], s.[Language], s.[Country], s.[Singular], s.[Plural]);
--OUTPUT deleted.*, $action, inserted.*; -- Does not work with triggers