DECLARE @DocumentTypes TABLE (
	[id] NVARCHAR (255)			PRIMARY KEY,
	[DocumentCategory]			NVARCHAR(255) DEFAULT(N'Transaction'),
	[Description]				NVARCHAR(1024), 
	[Description2]				NVARCHAR(1024),
	[Description3]				NVARCHAR(1024),
	[CustomerLabel]				NVARCHAR(255),
	[CustomerLabel]				NVARCHAR(255),
	[SupplierLabel]				NVARCHAR(255),
	[EmployeeLabel]				NVARCHAR(255),
	[FromCustodyAccountLabel]	NVARCHAR(255),
	[ToCustodyAccountLabel]		NVARCHAR(255)
);
INSERT @DocumentTypes ([Id]) VALUES
	-- The list includes the following transaction types, and their variant flavours depending on country and industry:
	-- lease-in agreement, lease-in receipt, lease-in invoice
	-- cash sale w/invoice, sales agreement (w/invoice, w/collection, w/issue), cash collection (w/invoice), G/S issue (w/invoice), sales invoice
	-- lease-out agreement, lease out issue, lease-out invoice
	-- Inventory transfer, stock issue to consumption, inventory adjustment 
	-- production, maintenance
	-- payroll, paysheet (w/loan deduction), loan issue, penalty, overtime, paid leave, unpaid leave
	-- manual journal, depreciation,  
	(N'manual-journals'), -- (N'ManualLine'), 
	(N'et-sales-witholding-tax-vouchers'), -- (N'et-customers-tax-withholdings'), (N'receivable-credit'), (N'cash-issue')

	(N'cash-payment-vouchers'), -- (N'cash-issue'), (N'manual-line')
	(N'cash-receipt-vouchers'), -- (N'cash-receipt')


	-- posts if customer account balance stays >= 0, if changes or refund, use negative
	(N'sales-cash'), -- (N'customers-issue-goods-with-invoice'), (N'customers-issue-services-with-invoice'), (N'cash-receipt')
	-- posts if customer account balance stays >= customer account credit line
	(N'sales-credit'), 
	
	(N'goods-received-notes'), -- Header: Supplier account, Lines: goods received (warehouse)
	(N'goods-received-issued-vouchers'), -- Header: Supplier account, Lines: goods & responsibility center
	(N'raw-materials-issue-vouchers'), -- Header: RM Warehouse account, Lines: Materials & destination warehouse
	(N'finished-products-receipt-notes'), -- Header: Supplier account, Lines: goods received & warehouse

	(N'equity-issues'),	--	(N'equity-issues-foreign'),
	(N'employees-overtime'),	--	(N'employee-overtime'),
	(N'employees-deductions'),	--	(N'et-employees-unpaid-absences'),(N'et-employees-penalties'), (N'employees-loans-dues');
	(N'employees-leaves-hourly'),
	(N'employees-leaves-daily'),
	(N'salaries'),				--	(N'salaries')
	(N'payroll-payments'),		--	(N'employees'), (N'employees-income-tax') 
	
	(N'purchasing-domestic'), --
	(N'purchasing-international'), -- 
	
	(N'production-events');

-- A transaction line does not have to result in balanced set of entries. It is up to the designer to 
-- choose a balanced set of lines, or compensate using a JV debit/credit line.
DECLARE @TransactionLineTypes TABLE(
	[id] NVARCHAR (255) PRIMARY KEY,
	[Description] NVARCHAR (255),
	[Description2] NVARCHAR (255),
	[Description3] NVARCHAR (255),
	[AgentAccount1Label] NVARCHAR (255)
)
INSERT @TransactionLineTypes ([Id]) VALUES
	(N'ManualLine'),						-- Account, Direction, amount, Resource, Agent Account, ...

	-- cash payments and receipts are assumed to be in the transaction currency
	-- any currency conversions, bank fees, are to be added by a manual JV tab
	(N'CashReceipt'),						-- [received from:RelatedAgentAccount], [currency], amount, received in:AgentAccount, details:RelatedResource, memo
	(N'CashIssue'),							-- [paid to:RelatedAgentAccount], [currency], amount, paid from:AgentAccount, details:RelatedResource, memo
	(N'CashTransfer'),						-- [FromCashAccount],[ToCashAccount], [currency], amount, resource details

	(N'EquityIssue'),						-- [investor], [currency], sharetype, qty, unit price, {total price}

	-- scheduling of receivables and payables
	(N'ReceivableDebit'),					-- [currency], amount, [debit a/c:AgentAccount], memo, settled by:
	(N'PayablesCredit'),					-- [currency], amount, [credit a/c:AgentAccount], memo, settled by:

	-- settling of receivables and payables. due date to be selected from available options
	(N'ReceivableCredit'),					-- [currency], amount, account:AgentAccount, memo, due date
	(N'PayableDebit'),						-- [currency], amount, account:AgentAccount, memo, due date
	
	-- withholding are assumed to be in the transaction currency
	-- any currency conversions is to be added by a manual JV tab
	(N'CustomerTaxWithholding'),			-- [customer], [currency], [invoice], taxable amount, percent withheld, {amount withheld}

	(N'GoodIssueWithInvoice'),				-- [customer], [currency], [warehouse], [invoice], [machine], item, qty, unit price, {total price}, percent VAT, {VAT}, {line total}
	(N'ServiceIssueWithInvoice'),			-- [customer], [currency], [invoice], [machine], item, qty, unit price, {total price}, percent VAT, {VAT}, {line total}
	(N'LeaseOutIssueWithInvoice'),			-- [customer], [currency], [invoice], [machine], lease starts, ppe, qty, {lease ends}, unit price, {total price}, percent VAT, {VAT}, {line total}
	(N'GoodServiceInvoiceWithoutIssue'),	-- [customer], [currency], [invoice], [machine], item, qty, unit price, {total price}, percent VAT, {VAT}, {line total}
	(N'LeaseOutInvoiceWithoutIssue'),		-- [customer], [currency], [invoice], [machine], lease starts, ppe, qty, {lease ends}, unit price, {total price}, percent VAT, {VAT}, {line total}
	(N'LeaseOutIssueWithoutInvoice'),		-- [customer], [currency], lease starts, ppe, qty, {lease ends}, unit price, {total price}	
	(N'GoodIssueWithoutInvoice'),			-- [customer], [currency], [warehouse], [machine], item, qty, unit price, {total price}
	(N'ServiceIssueWithoutInvoice'),		-- [customer], [currency], item, qty, unit price, {total price}
	
	-- withholding are assumed to be in the transaction currency
	-- any currency conversions is to be added by a manual JV tab
	(N'SupplierTaxWithholding'),			-- [supplier], [currency], [invoice], taxable amount, percent withheld, {amount withheld}

	(N'GoodReceiptInTransitWithInvoice'),	-- [supplier], [currency], [Transit Company], [LC], item, qty, unit price, {total price}, percent VAT, {VAT}, {line total}
	(N'GoodReceiptWithInvoice'),			-- [supplier], [currency], [warehouse], [invoice], [machine], item, qty, unit price, {total price}, percent VAT, {VAT}, {line total}
	(N'GoodReceiptIssueWithInvoice'),		-- [supplier], [currency], [responsibility center], [IFRSNote], [invoice], [machine], item, qty, unit price, {total price}, percent VAT, {VAT}, {line total}
	(N'ServiceReceiptWithInvoice'),			-- [supplier], [currency], [invoice], [machine], item, qty, unit price, {total price}, percent VAT, {VAT}, {line total}
	(N'LeaseInReceiptWithInvoice'),			-- [supplier], [currency], [invoice], [machine], lease starts, ppe, qty, {lease ends}, unit price, {total price}, percent VAT, {VAT}, {line total}
	(N'LeaseInReceiptWithoutInvoice'),		-- [supplier], [currency], lease starts, ppe, qty, {lease ends}, unit price, {total price}	
	(N'LeaseInInvoiceWithoutReceipt'),		-- [supplier], [currency], [invoice], [machine], lease starts, ppe, qty, {lease ends}, unit price, {total price}, percent VAT, {VAT}, {line total}

	-- Leaves, overtimes, and penalties must be posted during the payroll period [period starts] - [period ends] (= start + month - 1)
	(N'LaborOvertime'),						-- [employee], date/time starts, overtime hours, {overtime type lk}, {equiv. hours}
	(N'LaborUnpaidAbsences'),				-- employee, date start, absence days, absence type lk, description
	(N'LaborPenalty'),						-- employee, penalty, reason lk, description
	(N'LaborHourlyLeave'),					-- employee, leave date, from time, to time, paid/unpaid, reason
	(N'LaborDailyLeave'),					-- employee, from Date, to Date, leave type lk, {paid/semipaid/unpaid}, reason

	-- several items might be mapped to the same account, such as basic salary and allowances
	(N'EmployeePayslip'),					-- [currency], [period starts], employee, {basic salary}, {transportation}, {hardship}, {overtimes}, {penalties}, {social sec tax}, {social sec contribution}, {income tax withheld}, {net salary}, {loands deductions}, {net pay}
	(N'FixedAssetDepreciation'),			-- [period starts], [period ends], ppe, usage {life}, {responsibility center}, {depreciated value}
	(N'FixedAssetDisposal'),				-- [currency], [customer], ppe, sales value
	
	-- cash payments and receipts are assumed to be in the transaction currency
	-- any currency conversions, bank fees, are to be added by a manual JV tab
	(N'GoodReceipt'),						-- [received from:RelatedAgentAccount], item, Qty, received in:[ToCustodianAccount:AgentAccount], Batch:RelatedResource, memo
	(N'GoodIssue'),							-- [issued to:RelatedAgentAccount], item, Qty, issued from:[FromCustodianAccount:AgentAccount], Batch:RelatedResource, memo
	(N'GoodConsumption'),					-- [responsibility center], item, qty, [consumed by:AgentAccount]
	(N'GoodTransfer'),						-- [FromCustodyAccount],[ToCustodyAccount], item, qty, batch details
	(N'LaborReceipt'),						-- [received from:RelatedAgentAccount], item, Qty, received in:[ToCustodianAccount:AgentAccount], Batch:RelatedResource, memo
	(N'LaborIssue'),						-- [issued to:RelatedAgentAccount], item, Qty, issued from:[FromCustodianAccount:AgentAccount], Batch:RelatedResource, memo
	(N'LaborConsumption')					-- [responsibility center], item, qty, [consumed by:AgentAccount]
	;

DECLARE @DocumentTypesLineTypes TABLE(
	[DocumentTypeid]		NVARCHAR (255) PRIMARY KEY, 
	[LineTypeId]			NVARCHAR (255), 
	[IsVisibleByDefault]	BIT
);

INSERT @DocumentTypesLineTypes ([Id]) VALUES
	(N'manual-journals', N'ManualLine', 1),

	(N'et-sales-witholding-tax-vouchers', N'ET.CustomerTaxWithholding', 1),
	(N'et-sales-witholding-tax-vouchers', N'ReceivableCredit', 1), 
	(N'et-sales-witholding-tax-vouchers', N'CashIssue', 0),
	
	(N'cash-payment-vouchers', N'CashIssue', 1),
	(N'cash-payment-vouchers', N'ServiceReceiptWithInvoice', 1),
	(N'cash-payment-vouchers', N'PayableDebit', 0), -- pay dues
	(N'cash-payment-vouchers', N'ReceivableDebit', 0), -- lend
	(N'cash-payment-vouchers', N'GoodReceiptWithInvoice', 0),
	(N'cash-payment-vouchers', N'ManualLine', 0),
	(N'cash-payment-vouchers', N'CashReceipt', 0),
	(N'cash-payment-vouchers', N'LeaseInInvoiceWithoutReceipt', 0),

	(N'sales-cash', N'CashReceipt', 1),
	(N'sales-cash', N'GoodIssueWithInvoice', 1),
	(N'sales-cash', N'ServiceIssueWithInvoice', 0),
	(N'sales-cash', N'CustomerTaxWithholding', 0),	
	(N'sales-cash', N'GoodServiceInvoiceWithoutIssue', 0),
	(N'sales-cash', N'LeaseOutInvoiceWithoutIssue', 0),

	(N'production-events', N'GoodIssue', 1), -- input to production
	(N'production-events', N'LaborIssue', 0), -- input to production
	(N'production-events', N'GoodReceipt', 1) -- output from production
;

MERGE [dbo].[DocumentTypes] AS t
USING @DocumentTypes AS s
ON s.Id = t.Id
WHEN NOT MATCHED BY SOURCE THEN
    DELETE
WHEN NOT MATCHED BY TARGET THEN
    INSERT ([TenantId], [Id], [Description], [Description2], [Description3])
    VALUES (@TenantId, s.[Id], s.[Description], s.[Description2], a.[Description3]);

MERGE [dbo].LineTypes AS t
USING @TransactionLineTypes AS s
ON s.Id = t.Id
WHEN NOT MATCHED BY SOURCE THEN
    DELETE
WHEN NOT MATCHED BY TARGET THEN
    INSERT ([TenantId], [Id], [Description], [Description2], [Description3])
    VALUES (@TenantId, s.[Id], s.[Description], s.[Description2], s.[Description3]);