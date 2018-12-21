BEGIN -- Cleanup & Declarations
	DECLARE @D1Save [dbo].DocumentForSaveList, @D2Save [dbo].DocumentForSaveList;
	DECLARE @D1Result [dbo].DocumentList, @D2Result [dbo].DocumentList;
	DECLARE @D1ResultJson NVARCHAR(MAX), @D2ResultJson NVARCHAR(MAX), @D3ResultJson NVARCHAR(MAX);

	DECLARE @L1Save [dbo].LineForSaveList, @L2Save [dbo].LineForSaveList;
	DECLARE @L1Result [dbo].LineList, @L2Result [dbo].LineList;
	DECLARE @L1ResultJson NVARCHAR(MAX), @L2ResultJson NVARCHAR(MAX), @L3ResultJson NVARCHAR(MAX);

	DECLARE @E1Save [dbo].EntryForSaveList, @E2Save [dbo].EntryForSaveList;
	DECLARE @E1Result [dbo].EntryList, @E2Result [dbo].EntryList;
	DECLARE @E1ResultJson NVARCHAR(MAX), @E2ResultJson NVARCHAR(MAX), @E3ResultJson NVARCHAR(MAX);
END
-- get acceptable document types; and user permissions and general settings;
-- Journal Vouchers

INSERT INTO @D1Save(
	[State], [TransactionType],				[LinesMemo],		[LinesStartDateTime], [LinesEndDateTime]
--		[ResponsibleAgentId], [FolderId], , [LinesCustody1], [LinesCustody2], [LinesCustody3], [LinesReference1], [LinesReference2], [LinesReference3],
) VALUES
(N'Voucher', N'ManualJournalVoucher',		N'Capital Investment',	'2018.01.01',		NULL),
(N'Voucher', N'ManualJournalVoucher',		N'Exchange of $50000',	'2018.01.01',		NULL),
(N'Voucher', N'ManualJournalVoucher',		N'Vehicle purchases',	'2018.01.05',		NULL),
(N'Voucher', N'ManualJournalVoucher',		N'Vehicles Put in use',	'2018.02.01',		NULL),
(N'Voucher', N'ManualJournalVoucherExtended',N'Vehicles Depreciation','2018.02.01',		'2023.02.01');
INSERT INTO @L1Save ([DocumentIndex]) VALUES (0), (1), (2), (3), (4);

INSERT INTO @E1Save
([LineIndex], EntryNumber, OperationId,	AccountId,				CustodyId,		ResourceId,	Direction, Amount, [Value],		NoteId,							[Reference],	[RelatedReference], [RelatedAgentId], [RelatedResourceId], [RelatedAmount]) VALUES
(	0,			1,			@Common,	N'BalancesWithBanks',	@CBEUSD,		@USD,			+1,		200000, 4700000,	N'ProceedsFromIssuingShares',	NULL,			NULL,				NULL,				NULL,				NULL),
(	0,			2,			@Common,	N'IssuedCapital',		@MohamadAkra,	@CommonStock,	-1,		1000,	2350000,	N'IssueOfEquity',				NULL,			NULL,				NULL,				NULL,				NULL),
(	0,			3,			@Common,	N'IssuedCapital',		@AhmadAkra,		@CommonStock,	-1,		1000,	2350000,	N'IssueOfEquity',				NULL,			NULL,				NULL,				NULL,				NULL),

(	1,			1,			@Common,	N'BalancesWithBanks',	@CBEETB,		@ETB,			+1,		1175000, NULL,		NULL,							NULL,			NULL,				NULL,				NULL,				NULL),
(	1,			2,			@Common,	N'BalancesWithBanks',	@CBEUSD,		@USD,			-1,		50000,	1175000,	NULL,							NULL,			NULL,				NULL,				NULL,				NULL),

(	2,			1,			@Common,	N'OtherInventories',	@MiscWarehouse,	@Camry2018,		+1,		2,		600000,		NULL,							NULL,			NULL,				NULL,				NULL,				NULL),
(	2,			2,			@Common,	N'CurrentValueAddedTaxReceivables',@ERCA,@ETB,			+1,		90000,	NULL,		NULL,							N'INV-YM01',	N'FS0987',			@Lifan,				NULL,				600000),
(	2,			3,			@Common,	N'CurrentWithholdingTaxPayable',@ERCA,	@ETB,			-1,		12000,	NULL,		NULL,							N'WT0901',		NULL,				@Lifan,				NULL,				600000),
(	2,			4,			@Common,	N'BalancesWithBanks',	@CBEETB,		@ETB,			-1,		678000,	NULL,		N'PurchaseOfPropertyPlantAndEquipmentClassifiedAsInvestingActivities',NULL,NULL,NULL,	NULL,				NULL),	

(	3,			1,			@ExecutiveOffice, N'MotorVehicles',	@GeneralManager,@Car1Svc,		+1,		5,		300000,		N'AdditionsOtherThanThroughBusinessCombinationsPropertyPlantAndEquipment',NULL,NULL,NULL,@Car1,				NULL),
(	3,			2,			@Common,	N'OtherInventories',	@MiscWarehouse,	@Camry2018,		-1,		1,		300000,		NULL,							NULL,			NULL,				NULL,				NULL,				NULL),

(	4,			1,			@ExecutiveOffice, N'AdministrativeExpense',@GeneralManager,@Car1Svc,+1,		5,		300000,		N'DepreciationExpense',			NULL,			NULL,				NULL,				NULL,				NULL),
(	4,			2,			@ExecutiveOffice, N'MotorVehicles',	@GeneralManager,@Car1Svc,		-1,		5,		300000,		N'DepreciationPropertyPlantAndEquipment',NULL,	NULL,				NULL,				@Car1,				NULL);

BEGIN -- UI logic to fill missing fields
	UPDATE D -- For instant transaction types, make end time equals start time
	SET LinesEndDateTime = LinesStartDateTime
	FROM @D1Save D
	JOIN [dbo].TransactionTypes T ON D.TransactionType = T.Id
	WHERE T.IsInstant = 1
	AND LinesEndDateTime IS NULL;

	UPDATE L -- Inherit memo from header if not null
	SET L.Memo = D.LinesMemo
	FROM @L1Save L
	JOIN @D1Save D ON L.DocumentIndex = D.[Index]
	WHERE D.LinesMemo IS NOT NULL;
	
	UPDATE L -- Inherit end time from header if not null
	SET L.EndDateTime = D.LinesEndDateTime
	FROM @L1Save L
	JOIN @D1Save D ON L.DocumentIndex = D.[Index]
	WHERE D.LinesEndDateTime IS NOT NULL;

	UPDATE L -- Inherit start time from header if not null
	SET L.StartDateTime = D.LinesStartDateTime
	FROM @L1Save L
	JOIN @D1Save D ON L.DocumentIndex = D.[Index]
	WHERE D.LinesStartDateTime IS NOT NULL;

	UPDATE L -- For instant transaction types, make end time equals start time
	SET EndDateTime = StartDateTime
	FROM @L1Save L
	JOIN @D1Save D ON L.DocumentIndex = D.[Index]
	JOIN [dbo].TransactionTypes T ON D.TransactionType = T.Id
	WHERE T.IsInstant = 1
	AND EndDateTime IS NULL;

	UPDATE E
	SET [Value] = [Amount]
	FROM @E1Save E
	WHERE [ResourceId] IN (
		SELECT [Id] FROM dbo.Resources
		WHERE ResourceType = N'Money'
		AND [MeasurementUnitId] = @ETBUnit
	)
END

EXEC [dbo].[api_Documents__Save]
	@Documents = @D1Save, @Lines = @L1Save, @Entries = @E1Save,
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
/*
INSERT INTO @D2Save(
	[Id], [State], [TransactionType], [ResponsibleAgentId],	[FolderId],	[LinesMemo],[LinesStartDateTime], [LinesEndDateTime],
	[LinesCustody1], [LinesCustody2], [LinesCustody3], [LinesReference1], [LinesReference2], [LinesReference3],
	[EntityState]
)
SELECT 
	[Id], [State], [TransactionType], [ResponsibleAgentId],	[FolderId],	[LinesMemo],[LinesStartDateTime], [LinesEndDateTime],
	[LinesCustody1], [LinesCustody2], [LinesCustody3], [LinesReference1], [LinesReference2], [LinesReference3],
	N'Unchanged' As [EntityState]
FROM [dbo].[Documents] WHERE LinesMemo Like N'Capital%'
INSERT INTO @L2Save(
	[Id], [DocumentIndex], [DocumentId], [StartDateTime], [EndDateTime], [BaseLineId], [ScalingFactor], [Memo], [EntityState]	
)
SELECT 
	L.[Id], D.[Index]	, L.[DocumentId], [StartDateTime], [EndDateTime], [BaseLineId], [ScalingFactor], L.[Memo], N'Unchanged'
FROM [dbo].[Lines] L
JOIN @D2Save D ON L.[DocumentId] = D.[Id]
INSERT INTO @E2Save (
	[Id], [LineIndex], [LineId], EntryNumber, OperationId,	AccountId, CustodyId, ResourceId, Direction, Amount, [Value], NoteId, [RelatedReference], [RelatedAgentId], [RelatedResourceId], [RelatedAmount], [EntityState]
)
SELECT
	E.[Id], L.[Index],	[LineId], EntryNumber, OperationId,	AccountId, CustodyId, ResourceId, Direction, Amount, [Value], NoteId, [RelatedReference], [RelatedAgentId], [RelatedResourceId], [RelatedAmount], N'Unchanged' AS [EntityState]
FROM [dbo].[Entries] E
JOIN @L2Save L ON E.[LineId] = L.[Id]

UPDATE @D2Save SET [LinesStartDateTime] = '2018.01.02', [EntityState] = N'Updated'
UPDATE @E2Save SET [EntityState] = N'Deleted' WHERE [Index] = 1;
INSERT INTO @E2Save
([Id], [LineIndex], [LineId], EntryNumber, OperationId,		AccountId,			CustodyId,		ResourceId,	Direction, Amount, [Value],		NoteId,				[RelatedReference], [RelatedAgentId], [RelatedResourceId], [RelatedAmount], [EntityState]) VALUES
(NULL, 0,			1, 			4,			@Common, N'IssuedCapital',	@MohamadAkra,	@CommonStock,	-1,		1000,	2350000,	N'IssueOfEquity',	NULL,				NULL,				NULL,				NULL,			N'Inserted');
	
UPDATE @L2Save SET [EntityState] = N'Updated'
WHERE [EntityState] = N'Unchanged'
AND [Index] IN (
	SELECT [LineIndex] FROM @E2Save WHERE [EntityState] IN (N'Inserted', N'Updated', N'Deleted')
)

UPDATE @D2Save SET [EntityState] = N'Updated'
WHERE [EntityState] = N'Unchanged'
AND [Index] IN (
	SELECT [DocumentIndex] FROM @L2Save WHERE [EntityState] IN (N'Inserted', N'Updated', N'Deleted')
)
	
EXEC [dbo].[api_Documents__Save]
	@Documents = @D2Save, @Lines = @L2Save, @Entries = @E2Save,
	@ValidationErrorsJson = @ValidationErrorsJson OUTPUT,
	@DocumentsResultJson = @D2ResultJson OUTPUT, @LinesResultJson = @L2ResultJson OUTPUT, @EntriesResultJson = @E2ResultJson OUTPUT

IF @ValidationErrorsJson IS NOT NULL 
BEGIN
	Print 'Manual JV: Location 2'
	GOTO Err_Label;
END

INSERT INTO @D2Result
SELECT *
FROM OpenJson(@D2ResultJson)
WITH (
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
) */

DECLARE @Docs [dbo].[IndexedIdList];
INSERT INTO @Docs([Id]) VALUES
	(1),
	(2),
	(3),
	(4),
	(5);

EXEC [dbo].[api_Documents__Submit]
	@Documents = @Docs,
	@ValidationErrorsJson = @ValidationErrorsJson OUTPUT,
	@ReturnEntities = 0,
 	@DocumentsResultJson = @D3ResultJson OUTPUT,
	@LinesResultJson = @L3ResultJson OUTPUT,
	@EntriesResultJson = @E3ResultJson OUTPUT

IF @ValidationErrorsJson IS NOT NULL 
BEGIN
	Print 'Manual JV: Location 3'
	GOTO Err_Label;
END

EXEC [dbo].[api_Documents__Post]
	@Documents = @Docs,
	@ValidationErrorsJson = @ValidationErrorsJson OUTPUT,
	@ReturnEntities = 0,
 	@DocumentsResultJson = @D3ResultJson OUTPUT,
	@LinesResultJson = @L3ResultJson OUTPUT,
	@EntriesResultJson = @E3ResultJson OUTPUT

IF @ValidationErrorsJson IS NOT NULL 
BEGIN
	Print 'Manual JV: Location 4'
	GOTO Err_Label;
END

--SELECT * FROM [dbo].[Documents];
--SELECT * FROM [dbo].[Lines];
--SELECT * FROM [dbo].[Entries];