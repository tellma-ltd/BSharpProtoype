BEGIN
	DELETE FROM dbo.Entries;
	DELETE FROM dbo.Lines;
	DELETE FROM dbo.Documents;
	DELETE FROM dbo.Custodies;

	DELETE FROM dbo.Operations;
	DELETE FROM dbo.Resources;	

	DBCC CHECKIDENT ('dbo.Operations', RESEED, 0) WITH NO_INFOMSGS;
	DBCC CHECKIDENT ('dbo.Custodies', RESEED, 0) WITH NO_INFOMSGS;
	DBCC CHECKIDENT ('dbo.Resources', RESEED, 0) WITH NO_INFOMSGS;;

	Truncate Table dbo.Settings;
BEGIN -- Settings
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
	DECLARE @MohamadAkra int, @AhmadAkra int, @BadegeKebede int, @TizitaNigussie int, @Ashenafi int, @YisakTegene int, @ZewdineshHora int, @TigistNegash int, @RomanZenebe int, @Mestawet int, @AyelechHora int, @YigezuLegesse int;
	/*
		*/
	
	DECLARE @CBE int, @AWB int
	EXEC  [dbo].[sbs_Organization__Insert] @Name = N'Commercial Bank of Ethiopia', @TaxIdentificationNumber = N'',  @Organization = @CBE OUTPUT
	EXEC  [dbo].[sbs_Organization__Insert] @Name = N'Awash Bank', @TaxIdentificationNumber = N'',  @Organization = @AWB OUTPUT

	DECLARE @RawMaterialsWarehouse int, @FinishedGoodsWarehouse int; 
	EXEC [dbo].[sbs_Warehouse__Insert] @Name = N'Raw Materials Warehouse', @Address = N'Oromia', @Warehouse = @RawMaterialsWarehouse OUTPUT
	EXEC [dbo].[sbs_Warehouse__Insert] @Name = N'Finished Goods Warehouse', @Address = N'Oromia', @Warehouse = @FinishedGoodsWarehouse OUTPUT

	DECLARE @ExecutiveOffice int, @ProductionDept int, @FinanceUnit int;
	EXEC [dbo].[sbs_OrganizationUnit__Insert] @Name = N'Executive Office', @BirthDateTime = '2017.08.09',  @OrganizationUnit = @ExecutiveOffice OUTPUT
	EXEC [dbo].[sbs_OrganizationUnit__Insert] @Name = N'Software Development Unit', @BirthDateTime = '2017.08.09',  @OrganizationUnit = @ProductionDept OUTPUT
	EXEC [dbo].[sbs_OrganizationUnit__Insert] @Name = N'Finance Unit', @BirthDateTime = '2017.08.09',  @OrganizationUnit = @FinanceUnit OUTPUT

	INSERT INTO dbo.Settings Values(N'TaxAuthority', @ERCA);
	-- Pension social contribution authority,
END
BEGIN -- Resources
	DECLARE @ETB int, @USD int,	@Camry2018 int, @TeddyBear int, @CommonStock int, @HolidayOvertime int, @Labor int;
	EXEC sbs_Resource__Insert @ResourceType = N'Money', @Name = N'ETB', @Code = N'ETB', @UnitOfMeasure = N'ETB', @Resource = @ETB OUTPUT;
	EXEC sbs_Resource__Insert @ResourceType = N'Money', @Name = N'USD', @Code = N'USD', @UnitOfMeasure = N'USD', @Resource = @USD OUTPUT;
	EXEC sbs_Resource__Insert @ResourceType = N'Vehicles', @Name = N'Toyota Camry 2018', @Code = NULL, @UnitOfMeasure = N'pcs', @Lookup1 = N'Toyota', @Lookup2 = N'Camry', @Resource = @Camry2018 OUTPUT;
	EXEC sbs_Resource__Insert @ResourceType = N'GeneralGoods', @Name = N'Teddy bear', @Code = NULL, @UnitOfMeasure = N'pcs', @Resource = @TeddyBear OUTPUT;

	EXEC sbs_Resource__Insert @ResourceType = N'Shares', @Name = N'Common Stock', @UnitOfMeasure = N'share', @Resource = @CommonStock OUTPUT
	EXEC sbs_Resource__Insert @ResourceType = N'WagesAndSalaries', @Name = N'Holiday Overtime', @UnitOfMeasure = N'hr', @Resource = @HolidayOvertime OUTPUT
	EXEC sbs_Resource__Insert @ResourceType = N'WagesAndSalaries', @Name = N'Labor', @UnitOfMeasure = N'wmo', @Resource = @Labor OUTPUT
	INSERT INTO dbo.Settings VALUES
		(N'HolidayOvertime', @HolidayOvertime),
		(N'Labor', @Labor);
END 
BEGIN -- Operations
	DECLARE @BusinessEntity int; EXEC [dbo].[sbs_Operation__Insert] @OperationType = N'BusinessEntity', @Name = N'Walia Steel Industry', @Operation = @BusinessEntity OUTPUT;
	DECLARE @Existing int; EXEC  [dbo].[sbs_Operation__Insert] @OperationType = N'Investment', @Name = N'Existing', @Parent = @BusinessEntity, @Operation = @Existing OUTPUT;
	DECLARE @Expansion int; EXEC  [dbo].[sbs_Operation__Insert] @OperationType = N'Investment', @Name = N'Expansion', @Parent = @BusinessEntity, @Operation = @Expansion OUTPUT;
END
-- get acceptable document types; and user permissions and general settings;
-- Journal Vouchers
BEGIN
	SELECT  @DocumentId = @DocumentId + 1, @LineNumber = 0, @State = N'Event', @TransactionType = N'ManualJournalVoucher', @Mode = N'Draft';

	INSERT INTO @Documents( [Id], [State], [TransactionType], [SerialNumber], [Mode], [FolderId], [LinesMemo], [LinesResponsibleAgentId],
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

	EXEC ui_Documents_Lines_Entries__Validate @Documents = @Documents, @Lines = @Lines, @Entries = @Entries, @ValidationMessage = @ValidationMessage OUTPUT
	IF @ValidationMessage IS NOT NULL GOTO UI_Error;
END

EXEC [dbo].[api_Documents__Save] @Documents = @Documents, @WideLines = @WideLines, @Lines = @Lines, @Entries = @Entries;
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