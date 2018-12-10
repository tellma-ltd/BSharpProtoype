BEGIN -- Cleanup & Declarations
	DECLARE @D1Save dbo.DocumentForSaveList, @D2Save dbo.DocumentForSaveList;
	DECLARE @D1Result dbo.DocumentList, @D2Result dbo.DocumentList;
	DECLARE @D1ResultJson NVARCHAR(MAX), @D2ResultJson NVARCHAR(MAX), @D3ResultJson NVARCHAR(MAX);

	DECLARE @L1Save dbo.LineForSaveList, @L2Save dbo.LineForSaveList;
	DECLARE @L1Result dbo.LineList, @L2Result dbo.LineList;
	DECLARE @L1ResultJson NVARCHAR(MAX), @L2ResultJson NVARCHAR(MAX), @L3ResultJson NVARCHAR(MAX);

	DECLARE @E1Save dbo.EntryForSaveList, @E2Save dbo.EntryForSaveList;
	DECLARE @E1Result dbo.EntryList, @E2Result dbo.EntryList;
	DECLARE @E1ResultJson NVARCHAR(MAX), @E2ResultJson NVARCHAR(MAX), @E3ResultJson NVARCHAR(MAX);
END

-- get acceptable document types; and user permissions and general settings;
-- Journal Vouchers
BEGIN
	INSERT INTO @D1Save(
	[State], [TransactionType],	[FolderId],	[LinesMemo],[LinesStartDateTime], [LinesEndDateTime]
	--[LinesCustody1], [LinesCustody2], [LinesCustody3], [LinesReference1],	[LinesReference2], [LinesReference3]
	) VALUES
	(N'Voucher', N'ManualJournalVoucher', NULL, N'Capital Investment', '2018.01.01', NULL),
	(N'Voucher', N'ManualJournalVoucher', NULL, N'Inventory migration', '2018.01.01', NULL),
	(N'Voucher', N'ManualJournalVoucher', NULL, N'Fixed assets migratipm', '2018.01.01', NULL);

-- Line 1: A point in time transaction

	INSERT INTO @L1Save ([DocumentIndex]) VALUES (0);

/* -- better done in BE
	UPDATE L 
	SET
		L.[Memo] = ISNULL(L.[Memo], D.[LinesMemo]),
		L.[StartDateTime] = ISNULL(L.[StartDateTime], D.[LinesStartDateTime]),
		L.[EndDateTime] = ISNULL(L.[EndDateTime], D.[LinesEndDateTime])
	FROM @L1Save L JOIN @D1Save D ON L.DocumentId = D.Id
*/
	INSERT INTO @E1Save
	(LineIndex, EntryNumber, OperationId,	AccountId,			CustodyId,		ResourceId,	Direction, Amount, [Value],		NoteId) VALUES
	(0,			1,			@BusinessEntity, N'CashOnHand',		@TigistNegash,	@USD,			+1,		200000, 4700000,	N'ProceedsFromIssuingShares'),
	(0,			2,			@BusinessEntity, N'IssuedCapital',	@MohamadAkra,	@CommonStock,	-1,		1000,	2350000,	N'IssueOfEquity'),
	(0,			3,			@BusinessEntity, N'IssuedCapital',	@AhmadAkra,		@CommonStock,	-1,		1000,	2350000,	N'IssueOfEquity');

	EXEC [dbo].[api_Documents_Lines__Save]
		@Documents = @D1Save, @Lines = @L1Save, @Entries  = @E1Save,
		@ValidationErrorsJson = @ValidationErrorsJson OUTPUT,
		@DocumentsResultJson = @D1ResultJson OUTPUT, @LinesResultJson = @L1ResultJson OUTPUT, @EntriesResultJson = @E1ResultJson OUTPUT

	IF @ValidationErrorsJson IS NOT NULL 
	BEGIN
		Print 'Manual JV: Location 1'
		GOTO Err_Label;
	END

	INSERT INTO @D1Result
	SELECT *
	FROM OpenJson(@D1ResultJson)
	WITH (
		[Index]					INT '$.Index',
		[Id]					INT '$.Id',
		[State]					NVARCHAR (255) '$.State',
		[TransactionType]		NVARCHAR (255) '$.TransactionType',
		[Mode]					NVARCHAR (255) '$.Mode',
		[SerialNumber]			INT '$.SerialNumber',
		[ResponsibleAgentId]	INT '$.ResponsibleAgentId',
		[ForwardedToAgentId]	INT '$.ForwardedToAgentId',
		[FolderId]				INT '$.FolderId',
		[LinesMemo]				NVARCHAR (255) '$.LinesMemo',
		[LinesStartDateTime]	DATETIMEOFFSET (7) '$.LinesStartDateTime',
		[LinesEndDateTime]		DATETIMEOFFSET (7) '$.LinesEndDateTime',
		[LinesCustody1]			INT '$.LinesCustody1',
		[LinesCustody2]			INT '$.LinesCustody2',
		[LinesCustody3]			INT '$.LinesCustody3',
		[LinesReference1]		NVARCHAR(255) '$.LinesReference1',
		[LinesReference2]		NVARCHAR(255) '$.LinesReference2',
		[LinesReference3]		NVARCHAR(255) '$.LinesReference3',
		[CreatedAt]				DATETIMEOFFSET(7) '$.CreatedAt',
		[CreatedBy]				NVARCHAR(450) '$.CreatedBy',
		[ModifiedAt]			DATETIMEOFFSET(7) '$.ModifiedAt',
		[ModifiedBy]			NVARCHAR(450) '$.ModifiedBy',
		[EntityState]			NVARCHAR(255) '$.EntityState'
	)
END
	SELECT * FROM [dbo].Documents;
	SELECT * FROM [dbo].Lines;
	SELECT * FROM [dbo].Entries;

-- EXEC [dbo].[api_Documents__Post] @Documents = @Documents;

