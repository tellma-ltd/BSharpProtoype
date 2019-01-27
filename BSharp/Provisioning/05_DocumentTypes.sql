DECLARE @DocumentTypes TABLE([id] NVARCHAR(255) PRIMARY KEY, [Description] NVARCHAR(255), [Description2] NVARCHAR(255))
INSERT @DocumentTypes ([Id]) VALUES
	(N'manual-journals'),
	(N'capital-investments'),	--	(N'equity-issues'),
	(N'employees-overtime'),	--	(N'employees-overtime'),
	(N'employees-deductions'),	--	(N'employees-unpaid-absences'),(N'employees-penalties'), (N'employees-loans-dues');
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
	(N'equity-issues'),
	(N'employees-overtime'),
	(N'employees-unpaid-absences'),
	(N'employees-penalties'),
	(N'employees-leaves-hourly-paid'),
	(N'employees-leaves-daily-paid'),
	(N'employees-leaves-daily-semipaid'),
	(N'employees-leaves-daily-unpaid'),

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