BEGIN -- Cleanup & Declarations
	Declare @Documents DocumentList, @Lines LineList, @WideLines WideLineList, @Entries EntryList;
	DECLARE @SerialNumber int;
	DECLARE @ResponsibleAgent int, @Memo nvarchar(255), @StartDateTime datetimeoffset(7), @EndDateTime datetimeoffset(7);
	DECLARE @EntryNumber int, @Operation int, @Account nvarchar(255), @Custody int, @Resource int, @Direction smallint, @Amount money, @Value money, @Note nvarchar(255);
	DECLARE @ValidationMessage nvarchar(1024);
END

-- get acceptable document types; and user permissions and general settings;
-- Journal Vouchers
BEGIN
	INSERT INTO @Documents( [Id], [State], [TransactionType], [FolderId], [LinesMemo], [LinesResponsibleAgentId], [LinesStartDateTime], [LinesEndDateTime]
	--[LinesCustody1], [LinesCustody2], [LinesCustody3], [LinesReference1],	[LinesReference2], [LinesReference3]
	) VALUES
	(-100, N'Event', N'ManualJournalVoucher', NULL, N'Capital Investment', NULL, '01.01.2018', NULL),
	(-99, N'Event', N'ManualJournalVoucher', NULL, N'Inventory migration', NULL, '01.01.2018', NULL),
	(-98, N'Event', N'ManualJournalVoucher', NULL, N'Fixed assets migratipm',	NULL, '01.01.2018', NULL);
/*
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
	*/
	EXEC ui_Documents_Lines_Entries__Validate @Documents = @Documents, @Lines = @Lines, @Entries = @Entries, @ValidationMessage = @ValidationMessage OUTPUT
	IF @ValidationMessage IS NOT NULL GOTO UI_Error;
END

EXEC [dbo].[api_Documents__Save] @Documents = @Documents, @WideLines = @WideLines, @Lines = @Lines, @Entries = @Entries;
EXEC [dbo].[api_Documents__Post] @Documents = @Documents;
RETURN
UI_Error:
	Print @ValidationMessage;
RETURN

SELECT * from ft_Journal('01.01.2000', '01.01.2200') ORDER BY Id, LineId, EntryId
EXEC rpt_TrialBalance;
EXEC rpt_WithholdingTaxOnPayment;
EXEC rpt_ERCA__VAT_Purchases; 

SELECT Debit, Credit from ft_Account__Statement(N'AdministrativeExpense', '2017.06.30', '2019.01.01');
SELECT * FROM ft_Journal('2017.06.30', '2019.01.01');

EXEC rpt_TrialBalance @fromDate = '2018.01.01', @toDate = '2018.06.30', @ByCustody = 0, @ByResource = 0

SELECT * FROM dbo.Documents;
SELECT * FROM dbo.Lines;
SELECT * FROM dbo.Entries;