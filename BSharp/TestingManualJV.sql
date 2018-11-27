BEGIN -- Cleanup & Declarations
	Declare @Documents DocumentList, @DocumentsResult DocumentList, @Lines LineList,  @LinesResult LineList, @WideLines WideLineList,  @WideLinesResult WideLineList, @Entries EntryList, @EntriesResult EntryList;
END

-- get acceptable document types; and user permissions and general settings;
-- Journal Vouchers
BEGIN
	INSERT INTO @Documents(
	[Id], [TemporaryId], [State], [TransactionType],		[LinesMemo],			[LinesStartDateTime], [LinesEndDateTime]
	--[LinesCustody1], [LinesCustody2], [LinesCustody3], [LinesReference1],	[LinesReference2], [LinesReference3]
	) VALUES
	(-100, -100,		N'Voucher', N'ManualJournalVoucher', N'Capital Investment', '2018.01.01',		'2018.01.01');--,
--	(-99, -99,			N'Voucher', N'ManualJournalVoucher', N'Inventory migration', '2018.01.01', NULL),
--	(-98, -98,			N'Voucher', N'ManualJournalVoucher', N'Fixed assets migratipm', '2018.01.01', NULL);

-- Line 1: A point in time transaction

	INSERT INTO @Lines
	([Id], [TemporaryId], [DocumentId]) VALUES
	(-1000, -1000,			-100);

	UPDATE L
	SET
		L.[Memo] = ISNULL(L.[Memo], D.[LinesMemo]),
		L.[StartDateTime] = ISNULL(L.[StartDateTime], D.[LinesStartDateTime]),
		L.[EndDateTime] = ISNULL(L.[EndDateTime], D.[LinesEndDateTime])
	FROM @Lines L JOIN @Documents D ON L.DocumentId = D.Id

	INSERT INTO @Entries
	(Id,	[TemporaryId], LineId, EntryNumber, OperationId,	AccountId,			CustodyId,		ResourceId, Direction, Amount, [Value],		NoteId) VALUES
	(-10000, -10000,	-1000,		1,			@BusinessEntity, N'CashOnHand',		@TigistNegash,	@USD,			+1,		200000, 4700000,	N'ProceedsFromIssuingShares'),
	(-9999, -9999,		-1000,		2,			@BusinessEntity, N'IssuedCapital', @MohamadAkra,	@CommonStock,	-1,		1000,	2350000,	N'IssueOfEquity'),
	(-9998, -9998,		-1000,		3,			 @BusinessEntity, N'IssuedCapital', @AhmadAkra,		@CommonStock,	-1,		1000,	2350000,	N'IssueOfEquity');

	EXEC ui_Documents_Lines_Entries__Validate @Documents = @Documents, @Lines = @Lines, @Entries = @Entries
END

DELETE FROM @DocumentsResult;
INSERT INTO @DocumentsResult([Id], [State], [TransactionType], [SerialNumber], [Mode], [FolderId], 
	[LinesMemo], [ResponsibleAgentId],	[LinesStartDateTime], [LinesEndDateTime], 
	[LinesCustody1], [LinesCustody2], [LinesCustody3], [LinesReference1], [LinesReference2], [LinesReference3], 
	[ForwardedToAgentId], [Status], [TemporaryId])
EXEC [dbo].[api_Documents__Save] @Documents = @Documents, @WideLines = @WideLines, @Lines = @Lines, @Entries = @Entries;
DELETE FROM @Documents WHERE Status IN (N'Inserted', N'Updated', 'Deleted'); INSERT INTO @Documents SELECT * FROM @DocumentsResult;

--SELECT * FROM @Documents;
EXEC [dbo].[api_Documents__Post] @Documents = @Documents;

