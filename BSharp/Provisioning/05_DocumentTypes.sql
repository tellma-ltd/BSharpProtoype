DECLARE @DocumentTypes TABLE([id] NVARCHAR (255) PRIMARY KEY, [Description] NVARCHAR (255), [Description2] NVARCHAR (255))
INSERT @DocumentTypes ([Id]) VALUES
	(N'manual-journals'),
	(N'equity-issues'),	--	(N'equity-issues-foreign'),
	(N'employees-overtime'),	--	(N'employees-overtime'),
	(N'employees-deductions'),	--	(N'et-employees-unpaid-absences'),(N'et-employees-penalties'), (N'employees-loans-dues');
	(N'employees-leaves-hourly'),
	(N'employees-leaves-daily'),
	(N'salaries'),				--	(N'salaries')
	(N'payroll-payments'),		--	(N'employees'), (N'employees-income-tax') 
	(N'purchasing-domestic'), --
	(N'purchasing-international'), -- 

	(N'sales-prepaid'),
	(N'sales-postpaid'),
	(N'sales-direct'),

	(N'PaymentIssueToSupplier'),
	(N'PaymentReceiptFromCustomer'),
	(N'InventoryTransfer'),
	(N'LeaseIssueToCustomer'),
	(N'Purchase'),

	(N'Sale'),
	(N'SaleWitholdingTax'),
	(N'StockIssueToCustomer');

DECLARE @LineTypes TABLE([id] NVARCHAR (255) PRIMARY KEY, [Description] NVARCHAR (255), [Description2] NVARCHAR (255))
INSERT @LineTypes ([Id]) VALUES
	(N'manual-journals'),							-- Needed
	(N'equity-issues-foreign'),
	(N'equity-issues-local'),
	(N'employees-overtime'),						-- Needed
	(N'et-employees-unpaid-absences'),				-- Needed
	(N'et-employees-penalties'),					-- Needed
	(N'et-employees-leaves-hourly-paid'),			-- Needed
	(N'et-employees-leaves-hourly-unpaid'),			-- Needed
	(N'et-employees-leaves-daily-paid'),			-- Needed
	(N'et-employees-leaves-daily-semipaid'),		-- Needed
	(N'et-employees-leaves-daily-unpaid'),			-- Needed

	(N'et-customers-cash-receipt-local'),			-- customer, item, qty, warehouse, invoice, price
	(N'et-customers-invoice'),
	(N'et-customers-issue-inventory-from-warehouse'),-- supplier, item, qty, warehouse, invoice, price
	(N'et-customers-tax-withholding'),				-- Goes to finance?

	(N'et-suppliers-receipt-inventory-in-transit'),	-- supplier, item, qty, warehouse, invoice, price
	(N'et-suppliers-receipt-inventory-in-warehouse'),
	(N'et-suppliers-receipt-inventory-in-production'),

	(N'et-suppliers-cash-issue-local'),
	(N'et-suppliers-check-issue-local'),
	(N'et-suppliers-cpo-issue-local'),
	(N'et-suppliers-letter-of-credit-issue-foreign'),

	(N'et-suppliers-invoice'),
	(N'et-suppliers-tax-withholding'),



	(N'PaymentIssueToSupplier'),
	(N'Labor'),
	(N'LaborReceiptFromEmployee'),
	(N'EmployeeIncomeTax'),	
	(N'LeaseReceiptFromSupplier'),	
	(N'StockReceiptFromSupplier');	

MERGE [dbo].[DocumentTypeSpecifications] AS t
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