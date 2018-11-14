BEGIN -- Cleanup & Declarations
	Declare @Documents DocumentList, @DocumentsResult DocumentList, @Lines LineList,  @LinesResult LineList, @WideLines WideLineList,  @WideLinesResult WideLineList, @Entries EntryList, @EntriesResult EntryList;
END

-- get acceptable document types; and user permissions and general settings;
-- Journal Vouchers
BEGIN
	INSERT INTO @Documents( [Id], [State], [TransactionType], [FolderId], [LinesMemo], [LinesResponsibleAgentId], [LinesStartDateTime], [LinesEndDateTime]
	--[LinesCustody1], [LinesCustody2], [LinesCustody3], [LinesReference1],	[LinesReference2], [LinesReference3]
	) VALUES
	(-100, N'Event', N'ManualJournalVoucher', NULL, N'Capital Investment', NULL, '01.01.2018', NULL);--,
--	(-99, N'Event', N'ManualJournalVoucher', NULL, N'Inventory migration', NULL, '01.01.2018', NULL),
--	(-98, N'Event', N'ManualJournalVoucher', NULL, N'Fixed assets migratipm',	NULL, '01.01.2018', NULL);

-- Line 1: A point in time transaction

	INSERT INTO @Lines
	([Id], DocumentId, ResponsibleAgentId, StartDateTime, EndDateTime, Memo) VALUES
	(-1000, -100,		@BusinessEntity,	'01.01.2018', '01.01.2018', N'Capital Investment');

	INSERT INTO @Entries
	(Id,	LineId, EntryNumber, OperationId,	AccountId,			CustodyId,		ResourceId, Direction, Amount, [Value],		NoteId) VALUES
	(-10000, -1000, 1,			@BusinessEntity, N'CashOnHand',		@TigistNegash,	@USD,			+1,		200000, 4700000,	N'ProceedsFromIssuingShares'),
	(-9999, -1000,	2,			@BusinessEntity, N'IssuedCapital', @MohamadAkra,	@CommonStock,	-1,		1000,	2350000,	N'IssueOfEquity'),
	(-9998, -1000,	3,			 @BusinessEntity, N'IssuedCapital', @AhmadAkra,		@CommonStock,	-1,		1000,	2350000,	N'IssueOfEquity');

	EXEC ui_Documents_Lines_Entries__Validate @Documents = @Documents, @Lines = @Lines, @Entries = @Entries
END

DELETE FROM @DocumentsResult;
INSERT INTO @DocumentsResult([Id], [State], [TransactionType], [SerialNumber], [Mode], [FolderId], 
	[LinesMemo], [LinesResponsibleAgentId],	[LinesStartDateTime], [LinesEndDateTime], 
	[LinesCustody1], [LinesCustody2], [LinesCustody3], [LinesReference1], [LinesReference2], [LinesReference3], 
	[ForwardedToUserId], [Status], [TemporaryId])
EXEC [dbo].[api_Documents__Save] @Documents = @Documents, @WideLines = @WideLines, @Lines = @Lines, @Entries = @Entries;
DELETE FROM @Documents WHERE Status IN (N'Inserted', N'Updated', 'Deleted'); INSERT INTO @Documents SELECT * FROM @DocumentsResult;

--SELECT * FROM @Documents;
EXEC [dbo].[api_Documents__Post] @Documents = @Documents;