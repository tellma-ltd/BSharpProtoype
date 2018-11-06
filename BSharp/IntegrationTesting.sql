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

	DECLARE @DocumentId int = 0, @State nvarchar(50), @TransactionType nvarchar(50), @SerialNumber int, @Mode nvarchar(10), @RecordedByUserId nvarchar(450), @RecordedOnDateTime datetimeoffset(7), @ResponsibleAgent int;
	DECLARE @LineNumber int = 0;
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

	INSERT INTO dbo.Settings Values(N'NameOfReportingEntityOrOtherMeansOfIdentification', N'Banan IT, plc')
	INSERT INTO dbo.Settings Values(N'DomicileOfEntity', N'ET');
	INSERT INTO dbo.Settings Values(N'LegalFormOfEntity', N'PrivateLimitedCompany');
	INSERT INTO dbo.Settings Values(N'CountryOfIncorporation', N'ET');
	INSERT INTO dbo.Settings Values(N'AddressOfRegisteredOfficeOfEntity', N'Addis Abab, Bole Subcity, Woreda 6, House 316/3/203A');
	INSERT INTO dbo.Settings Values(N'PrincipalPlaceOfBusiness', N'Markan GH, Girgi, Addis Ababa');
	INSERT INTO dbo.Settings Values(N'DescriptionOfNatureOfEntitysOperationsAndPrincipalActivities', N'Software design, development and implementation');
	INSERT INTO dbo.Settings Values(N'NameOfParentEntity', N'BIOSS');
	INSERT INTO dbo.Settings Values(N'NameOfUltimateParentOfGroup', N'BIOSS');

	INSERT INTO dbo.Settings Values(N'TaxIdentificationAddress', N'123456789')
	INSERT INTO dbo.Settings Values(N'FunctionalCurrencyUnit', N'ETB')
END
BEGIN -- Users
	INSERT INTO dbo.Users(Id, FriendlyName) VALUES
	(N'system@banan-it.com', N'B#'),
	(N'mohamad.akra@banan-it.com', N'Mohamad Akra'),
	(N'ahmad.akra@banan-it.com', N'Ahmad Akra'),
	(N'badegek@gmail.com', N'Badege'),
	(N'mintewelde00@gmail.com', N'Tizita'),
	(N'ashenafi935@gmail.com', N'Ashenafi'),
	(N'yisak.tegene@gmail.com', N'Yisak'),
	(N'zewdnesh.hora@gmail.com', N'Zewdinesh Hora'),
	(N'tigistnegash74@gmail.com', N'Tigist'),
	(N'roman.zen12@gmail.com', N'Roman'),
	(N'mestawetezige@gmail.com', N'Mestawet'),
	(N'ayelech.hora@gmail.com', N'Ayelech'),
	(N'info@banan-it.com', N'Banan IT'),
	(N'DESKTOP-V0VNDC4\Mohamad Akra', N'Dr. Akra')
END
BEGIN -- Custodies: Agents & Locations
	DECLARE @MohamadAkra int, @AhmadAkra int, @BadegeKebede int, @TizitaNigussie int, @Ashenafi int, @YisakTegene int, @ZewdineshHora int, @TigistNegash int, @RomanZenebe int, @Mestawet int, @AyelechHora int, @YigezuLegesse int;
	EXEC  [dbo].[sbs_Individual__Insert] @LongName = N'Mohamad Akra', @ShortName = N'Mohamad Akra', @BirthDateTime = '1966.02.19', @UserId = N'mohamad.akra@banan-it.com', @Title = N'Dr.',  @Gender = 'M', @Individual = @MohamadAkra OUTPUT
	EXEC  [dbo].[sbs_Individual__Insert] @LongName = N'Ahmad Akra', @ShortName = N'Ahmad Akra', @BirthDateTime = '1992.09.21', @UserId = N'ahmad.akra@banan-it.com', @Title = N'Mr.', @Gender = 'M', @Individual = @AhmadAkra OUTPUT
	EXEC  [dbo].[sbs_Individual__Insert] @LongName = N'Badege Kebede', @ShortName = N'Badege', @UserId = N'badegek@gmail.com', @Title = N'ATO', @Gender = 'M', @Individual = @BadegeKebede OUTPUT
	EXEC  [dbo].[sbs_Individual__Insert] @LongName = N'Tizita Nigussie', @ShortName = N'Tizita', @UserId = N'mintewelde00@gmail.com', @Title = N'Ms.', @Gender = 'F', @Individual = @TizitaNigussie OUTPUT
	EXEC  [dbo].[sbs_Individual__Insert] @LongName = N'Ashenafi Fantahun', @ShortName = N'Ashenafi', @UserId = N'ashenafi935@gmail.com', @Title = N'Mr.', @Gender = 'M', @Individual = @Ashenafi OUTPUT
	EXEC  [dbo].[sbs_Individual__Insert] @LongName = N'Yisak Tegene', @ShortName = N'Yisak', @UserId = N'yisak.tegene@gmail.com', @Title = N'Mr.', @Gender = 'M', @Individual = @YisakTegene OUTPUT
	EXEC  [dbo].[sbs_Individual__Insert] @LongName = N'Zewdinesh Hora', @ShortName = N'Zewdinesh Hora', @UserId = N'zewdnesh.hora@gmail.com', @Title = N'Ms.', @Gender = 'F', @Individual = @ZewdineshHora OUTPUT
	EXEC  [dbo].[sbs_Individual__Insert] @LongName = N'Tigist Negash', @ShortName = N'Tigist', @UserId = N'tigistnegash74@gmail.com', @Title = N'Ms.', @Gender = 'F', @Individual = @TigistNegash OUTPUT
	EXEC  [dbo].[sbs_Individual__Insert] @LongName = N'Roman Zenebe', @ShortName = N'Roman', @UserId = N'roman.zen12@gmail.com', @Title = N'Ms.', @Gender = 'F', @Individual = @RomanZenebe OUTPUT
	EXEC  [dbo].[sbs_Individual__Insert] @LongName = N'Mestawet G/Egziyabhare', @ShortName = N'Mestawet', @UserId = N'mestawetezige@gmail.com', @Title = N'Ms.', @Gender = 'F', @Individual = @Mestawet OUTPUT
	EXEC  [dbo].[sbs_Individual__Insert] @LongName = N'Ayelech Hora', @ShortName = N'Ayelech', @UserId = N'ayelech.hora@gmail.com', @Title = N'Ms.', @Gender = 'F', @Individual = @AyelechHora OUTPUT
	EXEC  [dbo].[sbs_Individual__Insert] @LongName = N'Yigezu Legesse', @ShortName = N'Yigezu Legesse', @UserId = NULL, @Title = N'ATO', @Gender = 'M', @Individual = @YigezuLegesse OUTPUT

	DECLARE @BananIT int, @WaliaSteel int, @Lifan int, @Sesay int, @ERCA int, @Paint int, @Plastic int;
	EXEC  [dbo].[sbs_Organization__Insert] @LongName = N'Banan Information technologies, plc', @ShortName = N'Banan IT', @BirthDateTime = '2017.08.09', @TaxIdentificationNumber = N'0054901530', @UserId = N'info@banan-it.com', @Organization = @BananIT OUTPUT
	EXEC  [dbo].[sbs_Organization__Insert] @LongName = N'Walia Steel Industry, plc', @ShortName = N'Walia Steel', @TaxIdentificationNumber = N'0001656462',  @Organization = @WaliaSteel OUTPUT
	EXEC  [dbo].[sbs_Organization__Insert] @LongName = N'Yangfan Motors, PLC', @ShortName = N'Lifan Motors', @TaxIdentificationNumber = N'0005306731', @RegisteredAddress = N'AA, Bole, 06, New',   @Organization = @Lifan OUTPUT
	EXEC  [dbo].[sbs_Organization__Insert] @LongName = N'Sisay Tesfaye, PLC', @ShortName = N'Sisay Tesfaye', @TaxIdentificationNumber = N'', @Organization = @Sesay OUTPUT
	EXEC  [dbo].[sbs_Organization__Insert] @LongName = N'Ethiopian Revenues and Customs Authority', @ShortName = N'ERCA', @Organization = @ERCA OUTPUT
	EXEC  [dbo].[sbs_Organization__Insert] @LongName = N'Best Paint Industry', @ShortName = N'Best Paint', @TaxIdentificationNumber = N'',  @Organization = @Paint OUTPUT
	EXEC  [dbo].[sbs_Organization__Insert] @LongName = N'Best Plastic Industry', @ShortName = N'Best Plastic', @TaxIdentificationNumber = N'',  @Organization = @Plastic OUTPUT
	
	DECLARE @CBE int, @AWB int
	EXEC  [dbo].[sbs_Organization__Insert] @LongName = N'Commercial Bank of Ethiopia', @ShortName = N'CBE', @TaxIdentificationNumber = N'',  @Organization = @CBE OUTPUT
	EXEC  [dbo].[sbs_Organization__Insert] @LongName = N'Awash Bank', @ShortName = N'AWB', @TaxIdentificationNumber = N'',  @Organization = @AWB OUTPUT

	DECLARE @RawMaterialsWarehouse int, @FinishedGoodsWarehouse int; 
	EXEC [dbo].[sbs_Warehouse__Insert] @Name = N'Raw Materials Warehouse', @Address = N'Oromia', @Warehouse = @RawMaterialsWarehouse OUTPUT
	EXEC [dbo].[sbs_Warehouse__Insert] @Name = N'Finished Goods Warehouse', @Address = N'Oromia', @Warehouse = @FinishedGoodsWarehouse OUTPUT

	DECLARE @ExecutiveOffice int, @ProductionDept int, @FinanceUnit int;
	EXEC [dbo].[sbs_OrganizationUnit__Insert] @LongName = N'Executive Office', @ShortName = N'Executive Office', @BirthDateTime = '2017.08.09',  @OrganizationUnit = @ExecutiveOffice OUTPUT
	EXEC [dbo].[sbs_OrganizationUnit__Insert] @LongName = N'Software Development Unit', @ShortName = N'Development', @BirthDateTime = '2017.08.09',  @OrganizationUnit = @ProductionDept OUTPUT
	EXEC [dbo].[sbs_OrganizationUnit__Insert] @LongName = N'Finance Unit', @ShortName = N'Finance', @BirthDateTime = '2017.08.09',  @OrganizationUnit = @FinanceUnit OUTPUT

	INSERT INTO dbo.Settings Values(N'TaxAuthority', @ERCA);
	-- Pension social contribution authority,
END
BEGIN -- Resources
	DECLARE @ETB int, @USD int, @CashETB int, @BankETB int, @CashUSD int, @BankUSD int,
			@Camry2018 int, @TeddyBear int, @CommonStock int, 
			@HolidayOvertime int, @Labor int;
	EXEC sbs_Resource__Insert @ResourceType = N'Money', @Name = N'Money', @Code = N'ETB', @UnitOfMeasure = N'ETB', @Resource = @ETB OUTPUT
	EXEC sbs_Resource__Insert @ResourceType = N'Money', @Name = N'Money', @Code = N'USD', @UnitOfMeasure = N'USD', @Resource = @USD OUTPUT
	EXEC sbs_Resource__Insert @ResourceType = N'Vehicles', @Name = N'Toyota Camry 2018', @Code = NULL, @UnitOfMeasure = N'pcs', @Lookup1 = N'Toyota', @Lookup2 = N'Camry', @Resource = @Camry2018 OUTPUT
	EXEC sbs_Resource__Insert @ResourceType = N'GeneralGoods', @Name = N'Teddy bear', @Code = NULL, @UnitOfMeasure = N'pcs', @Resource = @TeddyBear OUTPUT

	EXEC sbs_Resource__Insert @ResourceType = N'Shares', @Name = N'Common Stock', @UnitOfMeasure = N'share', @Resource = @CommonStock OUTPUT
	EXEC sbs_Resource__Insert @ResourceType = N'WagesAndSalaries', @Name = N'Holiday Overtime', @UnitOfMeasure = N'wd', @Resource = @HolidayOvertime OUTPUT
	EXEC sbs_Resource__Insert @ResourceType = N'WagesAndSalaries', @Name = N'Labor', @UnitOfMeasure = N'hr', @Resource = @Labor OUTPUT
	INSERT INTO dbo.Settings VALUES
		(N'HolidayOvertime', @HolidayOvertime),
		(N'Labor', @Labor);
END 
BEGIN -- Operations
	DECLARE @BusinessEntity int; EXEC [dbo].[sbs_Operation__Insert] @OperationType = N'BusinessEntity', @Name = N'Walia Steel Industry', @Operation = @BusinessEntity OUTPUT;
	DECLARE @Existing int; EXEC  [dbo].[sbs_Operation__Insert] @OperationType = N'Investment', @Name = N'Existing', @Parent = @BusinessEntity, @Operation = @Existing OUTPUT;
	DECLARE @Expansion int; EXEC  [dbo].[sbs_Operation__Insert] @OperationType = N'Investment', @Name = N'Expansion', @Parent = @BusinessEntity, @Operation = @Expansion OUTPUT;
END
IF (1=1)-- Journal Voucher
BEGIN 
	-- Adding New General Journal. It accepts only manual JV
	SELECT  @DocumentId = @DocumentId + 1, @LineNumber = 0, @State = N'Event', @TransactionType = N'ManualJournalVoucher', @Mode = N'Draft', @RecordedByUserId = N'system@banan-it.com', @RecordedOnDateTime = '2018.01.01';
	INSERT INTO @Documents([Id], [State], [TransactionType], [SerialNumber], [Mode], [RecordedByUserId], [RecordedOnDateTime])
	VALUES(@DocumentId, @State, @TransactionType, @SerialNumber, @Mode, @RecordedByUserId, @RecordedOnDateTime)

-- Line 1: A point in time transaction
	SELECT @LineNumber = @LineNumber + 1, @EntryNumber = 0, @ResponsibleAgent = @TizitaNigussie, @Memo = N'Capital payment';
	--Defaults, can be modified
	SELECT @StartDatetime = @RecordedOnDateTime, @EndDatetime = DATEADD(D, 1, @RecordedOnDateTime);

	INSERT INTO @Lines(DocumentId, LineNumber, ResponsibleAgentId, StartDateTime, EndDateTime, Memo)
	VALUES(@DocumentId, @LineNumber, @ResponsibleAgent, @StartDatetime, @EndDatetime, @Memo)

-- Entry 1
	SELECT @EntryNumber = @EntryNumber + 1;
	SELECT @Operation = @BusinessEntity, @Account = N'CashOnHand', @Custody = @TigistNegash, @Resource = @ETB, @Direction = 1, @Amount = 200000, @Value = 200000	, @Note = N'ProceedsFromIssuingShares';
	INSERT INTO @Entries(DocumentId, LineNumber, EntryNumber, OperationId, AccountId, CustodyId, ResourceId, Direction, Amount, [Value], NoteId)
	VALUES(@DocumentId, @LineNumber, @EntryNumber, @Operation, @Account, @Custody ,@Resource, @Direction,@Amount, @Value, @Note)
-- Entry 2
	SELECT @EntryNumber = @EntryNumber + 1;
	SELECT @Operation = @BusinessEntity, @Account = N'IssuedCapital', @Custody = @MohamadAkra, @Resource = @CommonStock, @Direction = -1, @Amount = 5000, @Value = 100000, @Note = N'IssueOfEquity';
	INSERT INTO @Entries(DocumentId, LineNumber, EntryNumber, OperationId, AccountId, CustodyId, ResourceId, Direction, Amount, [Value], NoteId)
	VALUES(@DocumentId, @LineNumber, @EntryNumber, @Operation, @Account, @Custody ,@Resource, @Direction,@Amount, @Value, @Note)
-- Entry 3
	SELECT @EntryNumber = @EntryNumber + 1;
	SELECT @Operation = @BusinessEntity, @Account = N'IssuedCapital', @Custody = @AhmadAkra, @Resource = @CommonStock, @Direction = -1, @Amount = 5000, @Value = 100000, @Note = N'IssueOfEquity';
	INSERT INTO @Entries(DocumentId, LineNumber, EntryNumber, OperationId, AccountId, CustodyId, ResourceId, Direction, Amount, [Value], NoteId)
	VALUES(@DocumentId, @LineNumber, @EntryNumber, @Operation, @Account, @Custody ,@Resource, @Direction,@Amount, @Value, @Note)

-- Line 2: A period of time transaction
	SELECT  @DocumentId = @DocumentId + 1, @LineNumber = 0, @State = N'Event', @TransactionType = N'ManualJournalVoucherExtended', @Mode = N'Draft', @RecordedByUserId = N'system@banan-it.com', @RecordedOnDateTime = '2018.01.01';
	INSERT INTO @Documents([Id], [State], [TransactionType], [SerialNumber], [Mode], [RecordedByUserId], [RecordedOnDateTime])
	VALUES(@DocumentId, @State, @TransactionType, @SerialNumber, @Mode, @RecordedByUserId, @RecordedOnDateTime)

	SELECT @LineNumber = @LineNumber + 1, @EntryNumber = 0, @ResponsibleAgent = @TizitaNigussie, @EntryNumber = 0, @Memo = N'Yearly Depreciation ';
	--Defaults, can be modified
	SELECT @StartDatetime = @RecordedOnDateTime, @EndDatetime = DATEADD(YEAR, 1, @RecordedOnDateTime);

	INSERT INTO @Lines(DocumentId, LineNumber, ResponsibleAgentId, StartDateTime, EndDateTime, Memo)
	VALUES(@DocumentId, @LineNumber, @ResponsibleAgent, @StartDatetime, @EndDatetime, @Memo)
	-- Entry 1
	SELECT @EntryNumber = @EntryNumber + 1;
	SELECT @Operation = @BusinessEntity, @Account = N'AdministrativeExpense', @Custody = @ExecutiveOffice, @Resource = @ETB, @Direction = 1, @Amount = 120000, @Value = 120000	, @Note = N'DepreciationExpense';
	INSERT INTO @Entries(DocumentId, LineNumber, EntryNumber, OperationId, AccountId, CustodyId, ResourceId, Direction, Amount, [Value], NoteId)
	VALUES(@DocumentId, @LineNumber, @EntryNumber, @Operation, @Account, @Custody ,@Resource, @Direction,@Amount, @Value, @Note)
	-- Entry 2
	SELECT @EntryNumber = @EntryNumber + 1;
	SELECT @Operation = @BusinessEntity, @Account = N'MotorVehicles', @Custody = @MohamadAkra, @Resource = @ETB, @Direction = -1, @Amount = 120000, @Value = 120000, @Note = N'DepreciationPropertyPlantAndEquipment';
	INSERT INTO @Entries(DocumentId, LineNumber, EntryNumber, OperationId, AccountId, CustodyId, ResourceId, Direction, Amount, [Value], NoteId)
	VALUES(@DocumentId, @LineNumber, @EntryNumber, @Operation, @Account, @Custody ,@Resource, @Direction,@Amount, @Value, @Note)

	EXEC ui_Documents_Lines_Entries__Validate @Documents = @Documents, @Lines = @Lines, @Entries = @Entries, @ValidationMessage = @ValidationMessage OUTPUT
	IF @ValidationMessage IS NOT NULL GOTO UI_Error;
END
IF (1=1)-- Purchase Order
BEGIN 
	SELECT @DocumentId = @DocumentId + 1, @State = N'Order', @TransactionType = N'Purchase', @Mode = N'Draft', 
			@RecordedByUserId = N'system@banan-it.com', @RecordedOnDateTime = '2018.01.02';
	INSERT INTO @Documents([Id], [State], [TransactionType], [SerialNumber], [Mode], [RecordedByUserId], [RecordedOnDateTime])
	VALUES(@DocumentId, @State, @TransactionType, @SerialNumber, @Mode, @RecordedByUserId, @RecordedOnDateTime)

	SELECT  @ResponsibleAgent = @AyelechHora, @Supplier = @Lifan, @StartDatetime = @RecordedOnDateTime, @EndDatetime = DATEADD(D, 1, @RecordedOnDateTime);
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
IF (1=1)-- Purchase Event
BEGIN
	SELECT @DocumentId = @DocumentId + 1, @State = N'Event', @TransactionType = N'CashIssueToSupplier', @Mode = N'Draft', 
			@RecordedByUserId = N'system@banan-it.com', @RecordedOnDateTime = '2018.01.03';
	INSERT INTO @Documents([Id], [State], [TransactionType], [SerialNumber], [Mode], [RecordedByUserId], [RecordedOnDateTime])
	VALUES(@DocumentId, @State, @TransactionType, @SerialNumber, @Mode, @RecordedByUserId, @RecordedOnDateTime)

	SELECT @ResponsibleAgent = @TizitaNigussie, @Supplier = @Lifan, @StartDatetime = @RecordedOnDateTime, @EndDatetime = DATEADD(D, 1, @RecordedOnDateTime);
-- Payment
	SELECT @LineNumber = @LineNumber + 1, @Operation = @BusinessEntity, @Payment = 34465, @Cashier = @TigistNegash, @CashReceiptNumber = N'7023'
	INSERT INTO @WideLines(DocumentId, LineNumber, [TransactionType], ResponsibleAgentId, StartDateTime, EndDateTime, Operation1, Custody1, Amount1, Custody2, Reference2)
	VALUES(@DocumentId, @LineNumber, @TransactionType, @ResponsibleAgent, @StartDateTime, @EndDateTime, @Operation, @Supplier, @Payment, @Cashier, @CashReceiptNumber);

	SELECT @DocumentId = @DocumentId + 1, @State = N'Event', @TransactionType = N'PurchaseWitholdingTax', @Mode = N'Draft', 
			@RecordedByUserId = N'system@banan-it.com', @RecordedOnDateTime = '2018.01.03';
	INSERT INTO @Documents([Id], [State], [TransactionType], [SerialNumber], [Mode], [RecordedByUserId], [RecordedOnDateTime])
	VALUES(@DocumentId, @State, @TransactionType, @SerialNumber, @Mode, @RecordedByUserId, @RecordedOnDateTime)

	SELECT @ResponsibleAgent = @TizitaNigussie, @Supplier = @Lifan, @StartDatetime = @RecordedOnDateTime, @EndDatetime = DATEADD(D, 1, @RecordedOnDateTime), @Memo = N'Assets Purchase';
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

	SELECT @DocumentId = @DocumentId + 1, @State = N'Event', @TransactionType = N'Purchase', @Mode = N'Draft', 
			@RecordedByUserId = N'system@banan-it.com', @RecordedOnDateTime = '2018.01.03';
		
	INSERT INTO @Documents([Id], [State], [TransactionType], [SerialNumber], [Mode], [RecordedByUserId], [RecordedOnDateTime])
	VALUES(@DocumentId, @State, @TransactionType, @SerialNumber, @Mode, @RecordedByUserId, @RecordedOnDateTime)

	SELECT @ResponsibleAgent = @AyelechHora, @Supplier = @Lifan, @StartDatetime = @RecordedOnDateTime, @EndDatetime = DATEADD(D, 1, @RecordedOnDateTime);
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
	SELECT @DocumentId = @DocumentId + 1, @State = N'Order', @TransactionType = N'Labor', @Mode = N'Draft', 
			@RecordedByUserId = N'system@banan-it.com', @RecordedOnDateTime = '2018.01.31'; 
	INSERT INTO @Documents([Id], [State], [TransactionType], [SerialNumber], [Mode], [RecordedByUserId], [RecordedOnDateTime])
	VALUES(@DocumentId, @State, @TransactionType, @SerialNumber, @Mode, @RecordedByUserId, @RecordedOnDateTime)

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
	SELECT  @State = N'Event', @TransactionType = N'Payroll', @RecordedOnDateTime = '2018.01.03';

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
	SELECT  @State = N'Order', @TransactionType = N'InventoryTransfer', @RecordedOnDateTime = '2018.01.03';

	SELECT @TransactionType = N'InventoryTransferOrder';
-- Payment
	SELECT @LineNumber = @LineNumber + 1, @Operation = @BusinessEntity, @IssuingWarehouse = @RawMaterialsWarehouse, @ReceivingWarehouse = @FinishedGoodsWarehouse, @Item = @TeddyBear, @Quantity = 10, @Value = 100, @EventDateTime = '2018.01.02'
	INSERT INTO @WideLines(DocumentId, LineNumber, [TransactionType], ResponsibleAgentId, StartDateTime, EndDateTime, Memo, Operation1, Custody2, Custody1, Resource1, Amount1, Value1)
	VALUES(@DocumentId, @LineNumber, @TransactionType, @ResponsibleAgent, @StartDateTime, @EndDateTime, @Memo, @Operation, @IssuingWarehouse, @ReceivingWarehouse, @Item, @Quantity, @Value);
END
--	IF (1=0)-- Inventory transfer event

EXEC [dbo].[api_Documents__Save] @Documents = @Documents, @WideLines = @WideLines, @Lines = @Lines, @Entries = @Entries
EXEC [dbo].[api_Documents__Post] @Documents = @Documents;
RETURN

SELECT * from ft_Journal('01.01.2000', '01.01.2200') ORDER BY Id, LineNumber, EntryNumber;
EXEC rpt_TrialBalance;
--EXEC rpt_WithholdingTaxOnPayment;
--EXEC rpt_ERCA__VAT_Purchases; 
UI_Error:
	Print @ValidationMessage;

SELECT Debit, Credit from ft_Account__Statement(N'AdministrativeExpense', '2017.06.30', '2019.01.01');
SELECT * FROM ft_Journal('2017.06.30', '2019.01.01');

EXEC rpt_TrialBalance @fromDate = '2018.01.01', @toDate = '2018.06.30', @ByCustody = 0, @ByResource = 0

SELECT * FROM dbo.Documents;
SELECT * FROM dbo.Lines;
SELECT * FROM dbo.Entries;