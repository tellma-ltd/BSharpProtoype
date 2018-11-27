BEGIN -- Cleanup
	SET NOCOUNT ON;
	DELETE FROM dbo.Entries;
	DELETE FROM dbo.Lines;
	DELETE FROM dbo.Documents;
	DELETE FROM dbo.Custodies;
	DELETE FROM dbo.Users;
	DELETE FROM dbo.Operations;
	DELETE FROM dbo.Resources;	

	DBCC CHECKIDENT ('dbo.Operations', RESEED, 0) WITH NO_INFOMSGS;
	DBCC CHECKIDENT ('dbo.Custodies', RESEED, 0) WITH NO_INFOMSGS;
	DBCC CHECKIDENT ('dbo.Resources', RESEED, 0) WITH NO_INFOMSGS;;

	Truncate Table dbo.Settings;

	DECLARE @DocumentId int = 0, @State nvarchar(50), @TransactionType nvarchar(50), @SerialNumber int, @Mode nvarchar(10), @ResponsibleAgent int;
	DECLARE @LineNumber int = 0, @DocumentOffset int = 0;
	DECLARE @EntryNumber int = 0, @Operation int, @Memo nvarchar(255), @Reference nvarchar(50), @Account nvarchar(255), @Custody int,  @Resource int, @Direction smallint, @Amount money, @Value money, @Note nvarchar(255);
	DECLARE @Documents DocumentList, @Lines LineList, @Entries EntryList, @WideLines WideLineList, @ValidationMessage nvarchar(1024);
	
	-- List of Concepts
	DECLARE @EventDateTime datetimeoffset(7), @Supplier int, @Customer int, @Employee int, @Shareholder int, @Investment int, @Debtor int, @Creditor int;
	DECLARE @ReceivingWarehouse int, @IssuingWarehouse int, @ReceivingCashier int, @IssuingCashier int;

	DECLARE @item int, @Quantity money, @PriceVATExclusive money, @VAT money, @LineTotal money, @CashReceiptNumber nvarchar(50);
	DECLARE @Payment money, @AmountWithheld money, @WithholdingNumber nvarchar(50), @TaxableAmount money, @Warehouse int, @InvoiceDate datetimeoffset(7), @TypeOfTransaction nvarchar(50);
	DECLARE @SalaryAmount money, @Attendance money, @Department int, @EmployeeTaxableIncome money, @EmployeeIncomeTax money;

	DECLARE @MonthStarts datetimeoffset(7), @MonthEnds datetimeoffset(7), @StartDatetime datetimeoffset(7), @EndDatetime datetimeoffset(7);
	
	DECLARE @Organization int, @Currency int, @Date datetimeoffset(7), @BasicSalary money, @TransportationAllowance money, @NumberOfDays money;

	DECLARE @Cashier int, @ExpenseType nvarchar(50), @InvoiceNumber  nvarchar(50), @MachineNumber  nvarchar(50);
END
-- get acceptable document types; and user permissions and general settings;
IF (1=1)-- Journal Vouchers
BEGIN
-- Document 1: Manual JV
	SELECT  @DocumentId = @DocumentId + 1, @LineNumber = 0, @State = N'Voucher', @TransactionType = N'ManualJournalVoucher', @Mode = N'Draft';

	INSERT INTO @Documents( [Id], [State], [TransactionType], [SerialNumber], [Mode], [FolderId], [LinesMemo], [ResponsibleAgentId],
    [LinesStartDateTime], [LinesEndDateTime], [LinesCustody1], [LinesCustody2], [LinesCustody3], [LinesReference1],	[LinesReference2], [LinesReference3])
	VALUES(@DocumentId, @State, @TransactionType, @SerialNumber, @Mode, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

-- Line 1: A point in time transaction
	SELECT @LineNumber = @LineNumber + 1, @EntryNumber = 0, @ResponsibleAgent = @BusinessEntity, @Memo = N'Capital Investment';
	SELECT @StartDatetime = '01.01.2018', @EndDatetime = DATEADD(D, 1, @StartDatetime);

	INSERT INTO @Lines(DocumentId, LineNumber, ResponsibleAgentId, StartDateTime, EndDateTime, Memo)
	VALUES(@DocumentId, @LineNumber, @ResponsibleAgent, @StartDatetime, @EndDatetime, @Memo)

-- Entry 1
	SELECT @EntryNumber = @EntryNumber + 1;
	SELECT @Operation = @BusinessEntity, @Account = N'CashOnHand', @Custody = @TigistNegash, @Resource = @USD, @Direction = 1, @Amount = 200000, @Value = 4700000, @Note = N'ProceedsFromIssuingShares';
	INSERT INTO @Entries(DocumentId, LineNumber, EntryNumber, OperationId, AccountId, CustodyId, ResourceId, Direction, Amount, [Value], NoteId)
	VALUES(@DocumentId, @LineNumber, @EntryNumber, @Operation, @Account, @Custody ,@Resource, @Direction, @Amount, @Value, @Note)
-- Entry 2
	SELECT @EntryNumber = @EntryNumber + 1;
	SELECT @Operation = @BusinessEntity, @Account = N'IssuedCapital', @Custody = @MohamadAkra, @Resource = @CommonStock, @Direction = -1, @Amount = 1000, @Value = 2350000, @Note = N'IssueOfEquity';
	INSERT INTO @Entries(DocumentId, LineNumber, EntryNumber, OperationId, AccountId, CustodyId, ResourceId, Direction, Amount, [Value], NoteId)
	VALUES(@DocumentId, @LineNumber, @EntryNumber, @Operation, @Account, @Custody ,@Resource, @Direction,@Amount, @Value, @Note)
-- Entry 3
	SELECT @EntryNumber = @EntryNumber + 1;
	SELECT @Operation = @BusinessEntity, @Account = N'IssuedCapital', @Custody = @AhmadAkra, @Resource = @CommonStock, @Direction = -1, @Amount = 1000, @Value = 2350000, @Note = N'IssueOfEquity';
	INSERT INTO @Entries(DocumentId, LineNumber, EntryNumber, OperationId, AccountId, CustodyId, ResourceId, Direction, Amount, [Value], NoteId)
	VALUES(@DocumentId, @LineNumber, @EntryNumber, @Operation, @Account, @Custody ,@Resource, @Direction,@Amount, @Value, @Note)

-- Document 2: Manual JV Extended
	SELECT  @DocumentId = @DocumentId + 1, @LineNumber = 0, @State = N'Voucher', @TransactionType = N'ManualJournalVoucherExtended', @Mode = N'Draft';
	INSERT INTO @Documents(  [Id], [State], [TransactionType], [SerialNumber], [Mode], [FolderId], [LinesMemo], [ResponsibleAgentId],
    [LinesStartDateTime], [LinesEndDateTime], [LinesCustody1], [LinesCustody2], [LinesCustody3], [LinesReference1],	[LinesReference2], [LinesReference3])
	VALUES(@DocumentId, @State, @TransactionType, @SerialNumber, @Mode, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

-- Line 1: A period of time transaction
	SELECT @LineNumber = @LineNumber + 1, @EntryNumber = 0, @ResponsibleAgent = @TizitaNigussie, @EntryNumber = 0, @Memo = N'Yearly Depreciation ';
	--Defaults, can be modified
	SELECT @StartDatetime = '01.01.2018', @EndDatetime = DATEADD(YEAR, 1, @StartDatetime);

	INSERT INTO @Lines(DocumentId, LineNumber, ResponsibleAgentId, StartDateTime, EndDateTime, Memo)
	VALUES(@DocumentId, @LineNumber, @ResponsibleAgent, @StartDatetime, @EndDatetime, @Memo)

	-- Entry 1
	SELECT @EntryNumber = @EntryNumber + 1;
	SELECT @Operation = @BusinessEntity, @Account = N'AdministrativeExpense', @Custody = @ExecutiveOffice, @Resource = @ETB, @Direction = 1, @Amount = 120000, @Value = 120000	, @Note = N'DepreciationExpense';
	INSERT INTO @Entries(DocumentId, LineNumber, EntryNumber, OperationId, AccountId, CustodyId, ResourceId, Direction, Amount, [Value], NoteId)
	VALUES(@DocumentId, @LineNumber, @EntryNumber, @Operation, @Account, @Custody ,@Resource, @Direction, @Amount, @Value, @Note)
	-- Entry 2
	SELECT @EntryNumber = @EntryNumber + 1;
	SELECT @Operation = @BusinessEntity, @Account = N'MotorVehicles', @Custody = @MohamadAkra, @Resource = @ETB, @Direction = -1, @Amount = 120000, @Value = 120000, @Note = N'DepreciationPropertyPlantAndEquipment';
	INSERT INTO @Entries(DocumentId, LineNumber, EntryNumber, OperationId, AccountId, CustodyId, ResourceId, Direction, Amount, [Value], NoteId)
	VALUES(@DocumentId, @LineNumber, @EntryNumber, @Operation, @Account, @Custody ,@Resource, @Direction, @Amount, @Value, @Note)

	EXEC ui_Documents_Lines_Entries__Validate @Documents = @Documents, @Lines = @Lines, @Entries = @Entries, @ValidationMessage = @ValidationMessage OUTPUT
	IF @ValidationMessage IS NOT NULL GOTO UI_Error;
END
IF (1=0)-- Purchase Order
BEGIN 
	SELECT @DocumentId = @DocumentId + 1, @State = N'Order', @TransactionType = N'Purchase', @Mode = N'Draft';

	INSERT INTO @Documents(  [Id], [State], [TransactionType], [SerialNumber], [Mode], [FolderId], [LinesMemo], [ResponsibleAgentId],
    [LinesStartDateTime], [LinesEndDateTime], [LinesCustody1], [LinesCustody2], [LinesCustody3], [LinesReference1],	[LinesReference2], [LinesReference3])
	VALUES(@DocumentId, @State, @TransactionType, @SerialNumber, @Mode, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

	SELECT  @ResponsibleAgent = @AyelechHora, @Supplier = @Lifan, @StartDatetime = '2018.01.02', @EndDatetime = DATEADD(D, 1, @StartDatetime);
-- Line 1: Camry
	SELECT @LineNumber = @LineNumber + 1, @Operation = @Existing, @item = @Camry2018, @Quantity = 2, @PriceVATExclusive = 30000;
	SELECT @VAT = 0.15 * @PriceVATExclusive, @LineTotal = @PriceVATExclusive + @VAT;
	INSERT INTO @WideLines(DocumentId, LineNumber, TransactionType, ResponsibleAgentId, StartDateTime, EndDateTime, Operation1, Custody1, Resource1, Amount1, Amount2, RelatedAmount2, Amount3)
	VALUES(@DocumentId, @LineNumber, @TransactionType, @ResponsibleAgent, @StartDateTime, @EndDateTime, @Operation, @Supplier, @item, @Quantity, @VAT, @PriceVATExclusive, @LineTotal);	
-- Line 2: Teddy bear

	SELECT @LineNumber = @LineNumber + 1, @Operation = @Existing, @item = @TeddyBear, @Quantity = 5, @PriceVATExclusive = 500;
	SELECT @VAT = 0.15 * @PriceVATExclusive, @LineTotal = @PriceVATExclusive + @VAT;
	INSERT INTO @WideLines(DocumentId, LineNumber, TransactionType, ResponsibleAgentId, StartDateTime, EndDateTime, Operation1, Custody1, Resource1, Amount1, Amount2, RelatedAmount2, Amount3)
	VALUES(@DocumentId, @LineNumber, @TransactionType, @ResponsibleAgent, @StartDateTime, @EndDateTime, @Operation, @Supplier, @item, @Quantity, @VAT, @PriceVATExclusive, @LineTotal);	
	
	EXEC ui_Documents_WideLines__Validate @Documents = @Documents, @WideLines = @WideLines, @ValidationMessage = @ValidationMessage OUTPUT
	IF @ValidationMessage IS NOT NULL GOTO UI_Error;
END
IF (1=0)-- Purchase Event
BEGIN
	SELECT @DocumentId = @DocumentId + 1, @State = N'Voucher', @TransactionType = N'CashIssueToSupplier', @Mode = N'Draft';
	INSERT INTO @Documents(  [Id], [State], [TransactionType], [SerialNumber], [Mode], [FolderId], [LinesMemo], [ResponsibleAgentId],
    [LinesStartDateTime], [LinesEndDateTime], [LinesCustody1], [LinesCustody2], [LinesCustody3], [LinesReference1],	[LinesReference2], [LinesReference3])
	VALUES(@DocumentId, @State, @TransactionType, @SerialNumber, @Mode, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

	SELECT @ResponsibleAgent = @TizitaNigussie, @Supplier = @Lifan, @StartDatetime =  '2018.01.03', @EndDatetime = DATEADD(D, 1, @StartDatetime);

-- Payment
	SELECT @LineNumber = @LineNumber + 1, @Operation = @BusinessEntity, @Payment = 34465, @Cashier = @TigistNegash, @CashReceiptNumber = N'7023'
	INSERT INTO @WideLines(DocumentId, LineNumber, [TransactionType], ResponsibleAgentId, StartDateTime, EndDateTime, Operation1, Custody1, Amount1, Custody2, Reference2)
	VALUES(@DocumentId, @LineNumber, @TransactionType, @ResponsibleAgent, @StartDateTime, @EndDateTime, @Operation, @Supplier, @Payment, @Cashier, @CashReceiptNumber);

	SELECT @DocumentId = @DocumentId + 1, @State = N'Voucher', @TransactionType = N'PurchaseWitholdingTax', @Mode = N'Draft';
	INSERT INTO @Documents(  [Id], [State], [TransactionType], [SerialNumber], [Mode], [FolderId], [LinesMemo], [ResponsibleAgentId],
    [LinesStartDateTime], [LinesEndDateTime], [LinesCustody1], [LinesCustody2], [LinesCustody3], [LinesReference1],	[LinesReference2], [LinesReference3])
	VALUES(@DocumentId, @State, @TransactionType, @SerialNumber, @Mode, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

	SELECT @ResponsibleAgent = @TizitaNigussie, @Supplier = @Lifan, @StartDatetime = '2018.01.03', @EndDatetime = DATEADD(D, 1, @StartDatetime), @Memo = N'Assets Purchase';

-- Witholding tax: 
	SELECT @LineNumber = @LineNumber + 1, @Operation = @BusinessEntity, @Supplier = @Lifan, @AmountWithheld = 610, @WithholdingNumber = N'0006';
	SELECT @TaxableAmount = @AmountWithheld/0.02;
	INSERT INTO @WideLines(DocumentId, LineNumber, [TransactionType], ResponsibleAgentId, StartDateTime, EndDateTime, Memo, 
		Operation1, Custody1, Amount1, Reference2, RelatedAmount2, RelatedReference2)
	VALUES(@DocumentId,	@LineNumber, @TransactionType, @ResponsibleAgent, @StartDateTime, @EndDateTime, @Memo,
		@Operation, @Supplier, @AmountWithheld, @WithholdingNumber, @TaxableAmount, @TypeOfTransaction);
	/*
	SELECT @LineType = N'StockReceiptFromSupplier', @ResponsibleAgent = @AyelechHora, @Supplier = @Lifan, @StartDatetime = @RecordedOnDateTime, @EndDatetime = DATEADD(D, 1, @RecordedOnDateTime);
-- Stock receipt
-- Camry
	SELECT @LineNumber = @LineNumber + 1, @Operation = @Expansion, @item = @Camry2018, @Quantity = 2, @Warehouse = @FinishedGoodsWarehouse;
	INSERT INTO @WideLines(DocumentId, LineNumber, LineType, ResponsibleAgentId, StartDateTime, EndDateTime, Operation1, Custody1, Resource1, Amount1, Custody2)
	VALUES(@DocumentId, @LineNumber, @LineType, @ResponsibleAgent, @StartDateTime, @EndDateTime, @Operation, @Warehouse, @item, @Quantity, @Supplier);

-- Teddy bear
	SELECT @LineNumber = @LineNumber + 1, @Operation = @Existing, @item = @TeddyBear, @Quantity = 5, @Warehouse = @RawMaterialsWarehouse;
	INSERT INTO @WideLines(DocumentId, LineNumber, LineType, ResponsibleAgentId, StartDateTime, EndDateTime, Operation1, Custody1, Resource1, Amount1, Custody2)
	VALUES(@DocumentId, @LineNumber, @LineType, @ResponsibleAgent, @StartDateTime, @EndDateTime, @Operation, @Warehouse, @item, @Quantity, @Supplier);
	*/

	SELECT @DocumentId = @DocumentId + 1, @State = N'Voucher', @TransactionType = N'Purchase', @Mode = N'Draft';
		
	INSERT INTO @Documents(  [Id], [State], [TransactionType], [SerialNumber], [Mode], [FolderId], [LinesMemo], [ResponsibleAgentId],
    [LinesStartDateTime], [LinesEndDateTime], [LinesCustody1], [LinesCustody2], [LinesCustody3], [LinesReference1],	[LinesReference2], [LinesReference3])
	VALUES(@DocumentId, @State, @TransactionType, @SerialNumber, @Mode, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

	SELECT @ResponsibleAgent = @AyelechHora, @Supplier = @Lifan, @StartDatetime = '2018.01.31', @EndDatetime = DATEADD(D, 1, @StartDatetime);
-- Purchase invoice
	SELECT @LineNumber = @LineNumber + 1, @Operation = @Expansion,  @VAT = 4575, @InvoiceNumber = N'0913', @MachineNumber = N'fs4512219',
			@item = @Camry2018, @Quantity = 2, @PriceVATExclusive = 300000;
	INSERT INTO @WideLines(DocumentId, LineNumber, [TransactionType], ResponsibleAgentId, StartDateTime, EndDateTime, 
			Operation1, Custody1, Resource1, Amount1,	Value1,				Amount2, Reference2, RelatedReference2)
	VALUES(@DocumentId, @LineNumber, @TransactionType, @ResponsibleAgent, @StartDateTime, @EndDateTime,			
			@Operation,	@Supplier,@item,	@Quantity, @PriceVATExclusive, @VAT, @InvoiceNumber, @MachineNumber);
END
IF (1=0)-- Employment Contract
BEGIN
	SELECT @DocumentId = @DocumentId + 1, @State = N'Order', @TransactionType = N'Labor', @Mode = N'Draft';

	INSERT INTO @Documents(  [Id], [State], [TransactionType], [SerialNumber], [Mode], [FolderId], [LinesMemo], [ResponsibleAgentId],
    [LinesStartDateTime], [LinesEndDateTime], [LinesCustody1], [LinesCustody2], [LinesCustody3], [LinesReference1],	[LinesReference2], [LinesReference3])
	VALUES(@DocumentId, @State, @TransactionType, @SerialNumber, @Mode, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

	SELECT  @ResponsibleAgent = @BadegeKebede, @Employee = @MohamadAkra, 
		@StartDatetime = '2019.01.01', @EndDatetime = DATEADD(MONTH, 24, @StartDatetime);

-- Line 1: MA, Basic
	SELECT @LineNumber = @LineNumber + 1, @Operation = @Existing, @Employee = @MohamadAkra, @BasicSalary = 7000, @TransportationAllowance = 1750
	INSERT INTO @WideLines(DocumentId, LineNumber, [TransactionType], ResponsibleAgentId, StartDateTime, EndDateTime, Operation1, Custody1, Amount2, Amount3)
	VALUES(@DocumentId, @LineNumber, @TransactionType, @ResponsibleAgent, @StartDateTime, @EndDateTime, @Operation, @Employee, @BasicSalary, @TransportationAllowance);
-- Line 3: AA, Basic
	SELECT @LineNumber = @LineNumber + 1, @Operation = @Existing, @Employee = @AhmadAkra, @BasicSalary = 7000, @TransportationAllowance = 0
	INSERT INTO @WideLines(DocumentId, LineNumber, [TransactionType], ResponsibleAgentId, StartDateTime, EndDateTime, Memo, Operation1, Custody1, Amount2, Amount3)
	VALUES(@DocumentId, @LineNumber, @TransactionType, @ResponsibleAgent, @StartDateTime, @EndDateTime, @Memo, @Operation, @Employee, @BasicSalary, @TransportationAllowance);
END
IF (1=0)-- Attendance Event
BEGIN
	DELETE FROM @WideLines;
	SELECT  @State = N'Voucher', @TransactionType = N'Payroll';

	SELECT @TransactionType = N'LaborReceiptFromEmployee';
-- Labor receipt
-- MA
	SELECT @LineNumber = @LineNumber + 1, @Operation = @Expansion, @Employee = @MohamadAkra, @Attendance = 208, @Department = @ExecutiveOffice;
	INSERT INTO @WideLines(DocumentId, LineNumber, [TransactionType], ResponsibleAgentId, StartDateTime, EndDateTime, Memo, Operation1, Custody1, Amount1, Custody2)
	VALUES(@DocumentId, @LineNumber, @TransactionType, @ResponsibleAgent, @StartDateTime, @EndDateTime, @Memo, @Operation, @Department, @Attendance, @Employee);
-- Ahmad
	SELECT @LineNumber = @LineNumber + 1, @Operation = @Expansion, @Employee = @AhmadAkra, @Attendance = 208, @Department = @ProductionDept;
	INSERT INTO @WideLines(DocumentId, LineNumber, [TransactionType], ResponsibleAgentId, StartDateTime, EndDateTime, Memo, Operation1, Custody1, Amount1, Custody2)
	VALUES(@DocumentId, @LineNumber, @TransactionType, @ResponsibleAgent, @StartDateTime, @EndDateTime, @Memo, @Operation, @Department, @Attendance, @Employee);

	SELECT @TransactionType = N'EmployeeIncomeTax';
	SELECT @LineNumber = @LineNumber + 1, @Operation = @BusinessEntity, @Employee = @MohamadAkra, @EmployeeTaxableIncome = 7000, @EmployeeIncomeTax = 1105;
	INSERT INTO @WideLines(DocumentId, LineNumber, [TransactionType], ResponsibleAgentId, StartDateTime, EndDateTime, Memo, Operation1, Custody1, Amount1, RelatedAmount2)
	VALUES(@DocumentId, @LineNumber, @TransactionType, @ResponsibleAgent, @StartDateTime, @EndDateTime, @Memo, @Operation, @Employee, @EmployeeIncomeTax, @EmployeeTaxableIncome);

	SELECT @LineNumber = @LineNumber + 1, @Operation = @BusinessEntity, @Employee = @AhmadAkra, @EmployeeTaxableIncome = 7000, @EmployeeIncomeTax = 1105;
	INSERT INTO @WideLines(DocumentId, LineNumber, [TransactionType], ResponsibleAgentId, StartDateTime, EndDateTime, Memo, Operation1, Custody1, Amount1, RelatedAmount2)
	VALUES(@DocumentId, @LineNumber, @TransactionType, @ResponsibleAgent, @StartDateTime, @EndDateTime, @Memo,  @Operation, @Employee, @EmployeeIncomeTax, @EmployeeTaxableIncome);
/*
--	SELECT @LineType = N'CashPaymentToEmployee';
-- Payment
	SELECT @LineNumber = @LineNumber + 1, @Operation = @BusinessEntity, @Supplier = @Lifan, @Payment = 34465, @Cashier = @TigistNegash, @CashReceiptNumber = N'7023'
	INSERT INTO @WideLines(LineNumber, LineType, Operation1, Custody1, Amount1, Custody2, Reference2)
	VALUES(		@LineNumber, @LineType, @Operation, @Supplier, @Payment, @Cashier, @CashReceiptNumber);
*/
END
IF (1=0)-- Inventory transfer order
BEGIN
	DELETE FROM @WideLines;
	SELECT  @State = N'Order', @TransactionType = N'InventoryTransfer';

	SELECT @TransactionType = N'InventoryTransferOrder';
-- Payment
	SELECT @LineNumber = @LineNumber + 1, @Operation = @BusinessEntity, @IssuingWarehouse = @RawMaterialsWarehouse, @ReceivingWarehouse = @FinishedGoodsWarehouse, @Item = @TeddyBear, @Quantity = 10, @Value = 100, @EventDateTime = '2018.01.02'
	INSERT INTO @WideLines(DocumentId, LineNumber, [TransactionType], ResponsibleAgentId, StartDateTime, EndDateTime, Memo, Operation1, Custody2, Custody1, Resource1, Amount1, Value1)
	VALUES(@DocumentId, @LineNumber, @TransactionType, @ResponsibleAgent, @StartDateTime, @EndDateTime, @Memo, @Operation, @IssuingWarehouse, @ReceivingWarehouse, @Item, @Quantity, @Value);
END
--	IF (1=0)-- Inventory transfer event

EXEC [dbo].[api_Documents__Save] @Documents = @Documents, @WideLines = @WideLines, @Lines = @Lines, @Entries = @Entries, @DocumentOffset = @DocumentOffset Output
EXEC [dbo].[api_Documents__Post] @Documents = @Documents;
RETURN
UI_Error:
	Print @ValidationMessage;
RETURN

SELECT * from ft_Journal('01.01.2000', '01.01.2200') ORDER BY Id, LineNumber, EntryNumber;
EXEC rpt_TrialBalance;
EXEC rpt_WithholdingTaxOnPayment;
EXEC rpt_ERCA__VAT_Purchases; 

SELECT Debit, Credit from ft_Account__Statement(N'AdministrativeExpense', '2017.06.30', '2019.01.01');
SELECT * FROM ft_Journal('2017.06.30', '2019.01.01');

EXEC rpt_TrialBalance @fromDate = '2018.01.01', @toDate = '2018.06.30', @ByCustody = 0, @ByResource = 0

SELECT * FROM dbo.Documents;
SELECT * FROM dbo.Lines;
SELECT * FROM dbo.Entries;