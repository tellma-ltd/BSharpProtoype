DECLARE @DocumentTypes TABLE([id] NVARCHAR(255) PRIMARY KEY, [Description] NVARCHAR(255), [Description2] NVARCHAR(255))
INSERT @DocumentTypes ([Id]) VALUES
	(N'manual-journals'),
	(N'equity-issues'),	--	(N'equity-issues-foreign'),
	(N'employees-overtime'),	--	(N'employees-overtime'),
	(N'employees-deductions'),	--	(N'et-employees-unpaid-absences'),(N'et-employees-penalties'), (N'employees-loans-dues');
	(N'employees-leaves-hourly'),
	(N'employees-leaves-daily'),
	(N'salaries'),				--	(N'salaries')
	(N'payroll-payments'),		--	(N'employees'), (N'employees-income-tax')  

	(N'PaymentIssueToSupplier'),
	(N'PaymentReceiptFromCustomer'),
	(N'InventoryTransfer'),
	(N'LeaseIssueToCustomer'),
	(N'Purchase'),

	(N'Sale'),
	(N'SaleWitholdingTax'),
	(N'StockIssueToCustomer');

DECLARE @LineTypes TABLE([id] NVARCHAR(255) PRIMARY KEY, [Description] NVARCHAR(255), [Description2] NVARCHAR(255))
INSERT @LineTypes ([Id]) VALUES
	(N'manual-journals'),
	(N'equity-issues-foreign'),
	(N'equity-issues-local'),
	(N'employees-overtime'),
	(N'et-employees-unpaid-absences'),
	(N'et-employees-penalties'),
	(N'et-employees-leaves-hourly-paid'),
	(N'et-employees-leaves-hourly-unpaid'),
	(N'et-employees-leaves-daily-paid'),
	(N'et-employees-leaves-daily-semipaid'),
	(N'et-employees-leaves-daily-unpaid'),

	(N'PaymentIssueToSupplier'),
	(N'PurchaseWitholdingTax'),
	(N'Labor'),
	(N'LaborReceiptFromEmployee'),
	(N'EmployeeIncomeTax'),	
	(N'LeaseReceiptFromSupplier'),	
	(N'StockReceiptFromSupplier');	

MERGE [dbo].DocumentTypes AS t
USING @DocumentTypes AS s
ON s.Id = t.Id
WHEN NOT MATCHED BY SOURCE THEN
    DELETE
WHEN NOT MATCHED BY TARGET THEN
    INSERT ([TenantId], [Id], [Description], [Description2])
    VALUES (@TenantId, s.[Id], s.[Description], s.[Description2]);

MERGE [dbo].LineTypes AS t
USING @LineTypes AS s
ON s.Id = t.Id
WHEN NOT MATCHED BY SOURCE THEN
    DELETE
WHEN NOT MATCHED BY TARGET THEN
    INSERT ([TenantId], [Id], [Description], [Description2])
    VALUES (@TenantId, s.[Id], s.[Description], s.[Description2]);