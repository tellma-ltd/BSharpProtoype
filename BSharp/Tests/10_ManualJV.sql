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
DECLARE @VR1_2 VTYPE, @VRU_3 VTYPE, @Frequency NVARCHAR(255), @P1_2 int, @P1_U int, @PU_3 int, @P2_3 int,
		@d1 datetime = '2017.02.01', @d2 datetime = '2022.02.01', @dU datetime = '2018.02.01', @d3 datetime = '2023.02.01';

INSERT INTO @D1Save( 
	[State], [TransactionType],				[LinesMemo],				[Frequency], [Duration], [StartDateTime]
--		[ResponsibleAgentId], [FolderId], , [LinesCustody1], [LinesCustody2], [LinesCustody3], [LinesReference1], [LinesReference2], [LinesReference3],
) VALUES
(N'Voucher', N'ManualJournalVoucher',		N'Capital Investment',		N'OneTime',		0,	'2017.01.01'),
(N'Voucher', N'ManualJournalVoucher',		N'Exchange of $50000',		N'OneTime',		0,	'2017.01.01'),
(N'Voucher', N'ManualJournalVoucher',		N'Vehicles receipt on account',N'OneTime',	0,	'2017.01.05'),
(N'Voucher', N'ManualJournalVoucher',		N'Invoice for vehicles',	N'OneTime',		0,	'2017.01.06'),
(N'Voucher', N'ManualJournalVoucher',		N'Vehicles Invoice payment',N'OneTime',		0,	'2017.01.15'),
(N'Voucher', N'ManualJournalVoucher',		N'Invoice for rental',		N'OneTime',		0,	'2017.01.25'),
(N'Voucher', N'ManualJournalVoucher',		N'Rental payment',			N'OneTime',		0,	'2017.01.30'),
(N'Voucher', N'ManualJournalVoucher',		N'Vehicles Put in use',		N'OneTime',		0,	'2017.02.01'),
(N'Voucher', N'ManualJournalVoucher',		N'Vehicles Depreciation',	N'Monthly',		60,	@d1),
(N'Voucher', N'ManualJournalVoucher',		N'Sales Point Rental',		N'Monthly',		60,	'2017.02.01'),
(N'Voucher', N'ManualJournalVoucher',		N'Vehicle 1 Reinforcement',	N'OneTime',		0,	@dU),
(N'Voucher', N'ManualJournalVoucher',		N'Reverse Depreciation',	N'Monthly',		48,	@dU),
(N'Voucher', N'ManualJournalVoucher',		N'Vehicles Depreciation',	N'Monthly',		60,	@dU),
(N'Voucher', N'ManualJournalVoucher',		N'Employee Hire',			N'Monthly',		60,	'2018.02.01'),
(N'Voucher', N'ManualJournalVoucher',		N'Feb 2018 Overtime',		N'OneTime',		0,	'2018.02.15'),
(N'Voucher', N'ManualJournalVoucher',		N'Job 1 Hours Loging',		N'OneTime',		0,	'2018.02.20'),
(N'Voucher', N'ManualJournalVoucher',		N'Feb 2018 Paysheet',		N'OneTime',		0,	'2018.02.25'),
(N'Voucher', N'ManualJournalVoucher',		N'Feb 2018 Salaries Xfer',	N'OneTime',		0,	'2018.02.28'),
(N'Voucher', N'ManualJournalVoucher',		N'Feb 2018 Month Closing',	N'OneTime',		0,	'2018.02.28');

INSERT INTO @L1Save ([DocumentIndex]) VALUES 
	(0), (1), (2), (3), (4), (5), (6), (7), (8), (9), (10), (11), (12),
	(13), 
	(14), (15),
	(16), (16), (16), (16), (16), (16),
	(17);--, (18), (19), (20);

SELECT @Frequency = N'Monthly';
SELECT
	@P1_2 = 
		CASE 
			WHEN @Frequency = N'Daily' THEN DATEDIFF(DAY, @d1, @d2)
			WHEN @Frequency = N'Monthly' THEN DATEDIFF(MONTH, @d1, @d2)
		END,
	@P1_U = 
		CASE 
			WHEN @Frequency = N'Daily' THEN DATEDIFF(DAY, @d1, @dU)
			WHEN @Frequency = N'Monthly' THEN DATEDIFF(MONTH, @d1, @dU)
		END,		
	@P2_3 = 
		CASE 
			WHEN @Frequency = N'Daily' THEN DATEDIFF(DAY, @d2, @d3)
			WHEN @Frequency = N'Monthly' THEN DATEDIFF(MONTH, @d2, @d3)
		END,
	@PU_3 = 
		CASE 
			WHEN @Frequency = N'Daily' THEN DATEDIFF(DAY, @dU, @d3)
			WHEN @Frequency = N'Monthly' THEN DATEDIFF(MONTH, @dU, @d3)
		END;
SELECT @VR1_2 = CAST(300000 AS DECIMAL(38,22))/@P1_2;	
SELECT @VRU_3 = (420000 - @P1_U * @VR1_2)/@PU_3;

INSERT INTO @E1Save -- Purchases and Rentals
([LineIndex],EntryNumber,OperationId,AccountId,		CustodyId,		ResourceId,	Direction, Amount,	[Value],	NoteId,							[Reference],	[RelatedReference], [RelatedAgentId], [RelatedAmount]) VALUES
-- Capital Investment
(	0,	1,	@Common,	N'BalancesWithBanks',		@CBEUSD,		@USD,			+1,		200000, 4700000,	N'ProceedsFromIssuingShares',	NULL,			NULL,				NULL,					NULL),
(	0,	2,	@Common,	N'IssuedCapital',			@MohamadAkra,	@CommonStock,	-1,		1000,	2350000,	N'IssueOfEquity',				NULL,			NULL,				NULL,					NULL),
(	0,	3,	@Common,	N'IssuedCapital',			@AhmadAkra,		@CommonStock,	-1,		1000,	2350000,	N'IssueOfEquity',				NULL,			NULL,				NULL,					NULL),
-- Exchange of $50000
(	1,	1,	@Common,	N'BalancesWithBanks',		@CBEETB,		@ETB,			+1,		1175000, NULL,		N'InternalCashTransfer',		NULL,			NULL,				NULL,					NULL),
(	1,	2,	@Common,	N'BalancesWithBanks',		@CBEUSD,		@USD,			-1,		50000,	1175000,	N'InternalCashTransfer',		NULL,			NULL,				NULL,					NULL),
-- Vehicles receipt on account
(	2,	1,	@Common,	N'OtherInventories',		@MiscWarehouse,	@Camry2018,		+1,		2,		600000,		NULL,							NULL,			NULL,				NULL,					NULL),
(	2,	2,	@Common,	N'GoodsAndServicesReceivedFromSupplierButNotBilled',@Lifan,@Camry2018,-1,2,	600000,		NULL,							NULL,			NULL,				NULL,					NULL),
-- Invoice for vehicles
(	3,	1,	@Common,	N'GoodsAndServicesReceivedFromSupplierButNotBilled',@Lifan,@Camry2018,+1,2,	600000,		NULL,							NULL,			NULL,				NULL,					NULL),
(	3,	2,	@Common,	N'CurrentValueAddedTaxReceivables',@ERCA,	@ETB,			+1,		90000,	NULL,		NULL,							N'INV-YM01',	N'FS0987',			@Lifan,					600000),
(	3,	3,	@Common,	N'CurrentPayablesForPurchaseOfNoncurrentAssets',@Lifan,@ETB,-1,		690000,	NULL,		NULL,							NULL,			NULL,				NULL,					NULL),
-- Vehicles Invoice payment
(	4,	1,	@Common,	N'CurrentPayablesForPurchaseOfNoncurrentAssets',@Lifan,@ETB,+1,		690000,	NULL,		NULL,							NULL,			NULL,				NULL,					NULL),
(	4,	2,	@Common,	N'CurrentWithholdingTaxPayable',@ERCA,		@ETB,			-1,		12000,	NULL,		NULL,							N'WT0901',		NULL,				@Lifan,					600000),
(	4,	3,	@Common,	N'BalancesWithBanks',		@CBEETB,		@ETB,			-1,		678000,	NULL,		N'PurchaseOfPropertyPlantAndEquipmentClassifiedAsInvestingActivities',N'Ck002',NULL,NULL,		NULL),
-- Invoice for rental
(	5,	1,	@Sales,		N'RentAccrualClassifiedAsCurrent',@Regus,	@Goff,			+1,		6,		24000,		NULL,							NULL,			NULL,				NULL,					NULL),
(	5,	2,	@Sales,		N'CurrentValueAddedTaxReceivables',@ERCA,	@ETB,			+1,		3600,	NULL,		NULL,							N'INV-YM02',	N'FS10117',			@Regus,					12000),
(	5,	3,	@Sales,		N'CurrentPayablesToLessors',@Regus,			@ETB,			-1,		27600,	NULL,		NULL,							NULL,			NULL,				NULL,					NULL),
-- Rental payment
(	6,	1,	@Sales,		N'CurrentPayablesToLessors',@Regus,			@ETB,			+1,		27600,	NULL,		NULL,							NULL,			NULL,				NULL,					NULL),
(	6,	2,	@Sales,		N'CurrentWithholdingTaxPayable',@ERCA,		@ETB,			-1,		480,	NULL,		NULL,							N'WT0902',		NULL,				@Regus,					12000),
(	6,	3,	@Sales,		N'BalancesWithBanks',		@CBEETB,		@ETB,			-1,		27120,	NULL,		N'PaymentsToSuppliersForGoodsAndServices',N'Ck003',	NULL,			NULL,					NULL),
-- Vehicles Put in use
(	7,	1,	@ExecOffice,N'MotorVehicles',			@GeneralManager,@Car1Svc,		+1,		@P1_2,	300000,		N'AdditionsOtherThanThroughBusinessCombinationsPropertyPlantAndEquipment',NULL,NULL,NULL,	NULL),
(	7,	2,	@Common,	N'OtherInventories',		@MiscWarehouse,	@Camry2018,		-1,		1,		300000,		NULL,							NULL,			NULL,				NULL,					NULL),
-- Vehicles Depreciation
(	8,	1,	@ExecOffice,N'AdministrativeExpense',	@GeneralManager,@Car1Svc,		+1,		+1,		@VR1_2,		N'DepreciationExpense',			NULL,			NULL,				NULL,					NULL),
(	8,	2,	@ExecOffice,N'MotorVehicles',			@GeneralManager,@Car1Svc,		-1,		+1,		@VR1_2,		N'DepreciationPropertyPlantAndEquipment',NULL,	NULL,				NULL,					NULL),
-- Sales Point Rental
(	9,	1,	@Sales,		N'DistributionCosts',		@SalesManager,	@Goff,			+1,		+1,		4000,		N'OfficeSpaceExpense',			NULL,			NULL,				NULL,					NULL),
(	9,	2,	@Sales,		N'RentAccrualClassifiedAsCurrent',@Regus,	@Goff,			-1,		+1,		4000,		NULL,							NULL,			NULL,				NULL,					NULL),
-- Vehicle 1 Reinforcement
(	10,	1,	@ExecOffice,N'MotorVehicles',			@GeneralManager,@Car1Svc,		+1,		@P2_3,	120000,		N'AdditionsOtherThanThroughBusinessCombinationsPropertyPlantAndEquipment',NULL,NULL,NULL,	NULL),
(	10,	2,	@Common,	N'BalancesWithBanks',		@CBEETB,		@ETB,			-1,		120000,	NULL,		N'PurchaseOfPropertyPlantAndEquipmentClassifiedAsInvestingActivities',N'Ck001',NULL,NULL,	NULL),
-- Reverse Depreciation
(	11,	1,	@ExecOffice,N'AdministrativeExpense',	@GeneralManager,@Car1Svc,		+1,		-1,		-@VR1_2,	N'DepreciationExpense',			NULL,			NULL,				NULL,					NULL),
(	11,	2,	@ExecOffice,N'MotorVehicles',			@GeneralManager,@Car1Svc,		-1,		-1,		-@VR1_2,	N'DepreciationPropertyPlantAndEquipment',NULL,	NULL,				NULL,					NULL),
---- Vehicles Depreciation
(	12,	1,	@ExecOffice,N'AdministrativeExpense',	@GeneralManager,@Car1Svc,		+1,		+1,		@VRU_3,		N'DepreciationExpense',			NULL,			NULL,				NULL,					NULL),
(	12,	2,	@ExecOffice,N'MotorVehicles',			@GeneralManager,@Car1Svc,		-1,		+1,		@VRU_3,		N'DepreciationPropertyPlantAndEquipment',NULL,	NULL,				NULL,					NULL);
INSERT INTO @E1Save -- HR, Employment Contract
([LineIndex],EntryNumber,OperationId,AccountId,		CustodyId,		ResourceId,	Direction, Amount,	[Value],	NoteId,							[Reference],	[RelatedReference], [RelatedAgentId], [RelatedAmount]) VALUES
-- Employee Hire: similar to depreciation and rental.
(	13,	1,	@Production,N'OtherInventories',		@ProductionManager,@Labor,		+1,		+208,	18870,		NULL,							NULL,			NULL,				@MesfinWolde,			NULL),
(	13,	2,	@Production,N'ShorttermPensionContributionAccruals',@ERCA,@ETB,			-1,		+1870,	1870,		NULL,							NULL,			NULL,				@MesfinWolde,			NULL),
(	13,	3,	@Production,N'ShorttermEmployeeBenefitsAccruals',@MesfinWolde,@Basic,	-1,		+1,		15000,		NULL,							NULL,			NULL,				NULL,					NULL),
(	13,	4,	@Production,N'ShorttermEmployeeBenefitsAccruals',@MesfinWolde,@Transportation,-1,+1,	2000,		NULL,							NULL,			NULL,				NULL,					NULL);
INSERT INTO @E1Save -- Overtime and Costing
([LineIndex],EntryNumber,OperationId,AccountId,		CustodyId,		ResourceId,	Direction, Amount,	[Value],	RelatedResourceId,				[Reference],	[RelatedReference], [RelatedAgentId], [RelatedAmount]) VALUES
-- Feb 2018 Overtime: recorded while taken
(	14,	1,	@Production,N'OtherInventories',		@ProductionManager,@Labor,		+1,		+20,	3000,		NULL,							NULL,			NULL,				NULL,					NULL),
(	14,	2,	@Production,N'ShorttermEmployeeBenefitsAccruals',@MesfinWolde,@HOvertime,-1,	+20,	3000,		NULL,							NULL,			NULL,				NULL,					NULL),
-- Feb 2018 Job 1 Hours Logging
(	15, 1,	@Production,N'WorkInProgress',			@ProductionManager,@TeddyBear,	+1,		2,		1000,		@Cotton,						'JO01',			NULL,				NULL,					1000),
(	15, 2,	@Production,N'RawMaterials',			@ProductionManager,@Cotton,		-1,		+1,		1000,		NULL,							NULL,			NULL,				NULL,					NULL),
(	15, 3,	@Production,N'WorkInProgress',			@ProductionManager,@TeddyBear,	+1,		0,		5000,		@Labor,							'JO01',			NULL,				@MesfinWolde,			50),
(	15, 4,	@Production,N'OtherInventories',		@ProductionManager,@Labor,		-1,		+50,	5000,		NULL,							NULL,			NULL,				@MesfinWolde,			NULL);
INSERT INTO @E1Save -- Payroll
([LineIndex],EntryNumber,OperationId,AccountId,		CustodyId,		ResourceId,	Direction, Amount,	[Value],	NoteId,							[Reference],	[RelatedReference], [RelatedAgentId], [RelatedAmount]) VALUES
-- Feb 2018 Paysheet: Invoicing for basic salary
(	16,	1,	@Production,N'ShorttermEmployeeBenefitsAccruals',@MesfinWolde,@Basic,	+1,		+1,		15000,		NULL,							'2018.02',		NULL,				@MesfinWolde,			NULL),
(	16,	2,	@Production,N'CurrentPayablesToEmployees',@MesfinWolde,	@ETB,			-1,		15000,	NULL,		NULL,							'2018.02',		NULL,				@MesfinWolde,			NULL),
-- Feb 2018 Paysheet: Invoicing for transportation
(	17,	1,	@Production,N'ShorttermEmployeeBenefitsAccruals',@MesfinWolde,@Transportation,+1,+1,	2000,		NULL,							'2018.02',		NULL,				@MesfinWolde,			NULL),
(	17,	2,	@Production,N'CurrentPayablesToEmployees',@MesfinWolde,	@ETB,			-1,		2000,	NULL,		NULL,							'2018.02',		NULL,				@MesfinWolde,			NULL),
-- Feb 2018 Paysheet: Invoicing for overtime
(	18,	1,	@Production,N'ShorttermEmployeeBenefitsAccruals',@MesfinWolde,@HOvertime,+1,	+20,	3000,		NULL,							'2018.02',		NULL,				@MesfinWolde,			NULL),
(	18,	2,	@Production,N'CurrentPayablesToEmployees',@MesfinWolde,	@ETB,			-1,		3000,	NULL,		NULL,							'2018.02',		NULL,				@MesfinWolde,			NULL),
-- Feb 2018 Paysheet: Withholding Income Tax
(	19,	1,	@Production,N'CurrentPayablesToEmployees',@MesfinWolde,	@ETB,			+1,		4450,	NULL,		NULL,							'2018.02',		NULL,				@MesfinWolde,			NULL),
(	19,	2,	@Production,N'CurrentEmployeeIncomeTaxPayable',@ERCA,	@ETB,			-1,		4450,	NULL,		NULL,							'2018.02',		NULL,				@MesfinWolde,			NULL),
-- Feb 2018 Paysheet: Withholding Social security
(	20,	1,	@Production,N'CurrentPayablesToEmployees',@MesfinWolde,	@ETB,			+1,		1190,	NULL,		NULL,							'2018.02',		NULL,				@MesfinWolde,			NULL),
(	20,	2,	@Production,N'ShorttermPensionContributionAccruals',@ERCA,@ETB,			+1,		1870,	NULL,		NULL,							'2018.02',		NULL,				@MesfinWolde,			NULL),
(	20,	3,	@Production,N'CurrentSocialSecurityTaxPayable',@ERCA,	@ETB,			-1,	1870+1190,	NULL,		NULL,							'2018.02',		NULL,				@MesfinWolde,			NULL),
-- Feb 2018 Paysheet: Loan Deduction
(	21,	1,	@Production,N'CurrentPayablesToEmployees',@MesfinWolde,	@ETB,			+1,		2000,	NULL,		NULL,							'2018.02',		NULL,				@MesfinWolde,			NULL),
(	21,	2,	@Production,N'OtherCurrentReceivables',	@MesfinWolde,	@ETB,			-1,		2000,	NULL,		NULL,							'2018.02',		NULL,				@MesfinWolde,			NULL),

-- Feb 2018 Salaries Xfer: Similar to Rental payment. We can deduct loans, and cost sharing before payments
(	22,	1,	@Production,N'CurrentPayablesToEmployees',@MesfinWolde,	@ETB,			+1,		12360,	NULL,		NULL,							NULL,			NULL,				NULL,					NULL),
(	22,	2,	@Production,N'BalancesWithBanks',		@CBEETB,		@ETB,			-1,		12360,	NULL,		N'PaymentsToAndOnBehalfOfEmployees',N'Ck004',	NULL,				NULL,					NULL);

BEGIN -- UI logic to fill missing fields
	UPDATE D -- If end date is null, set it to start date.
	SET [EndDateTime] =
		CASE 
			WHEN [Frequency] = N'OneTime' THEN [StartDateTime]
			WHEN [Frequency] = N'Daily' THEN DATEADD(DAY, [Duration], [StartDateTime])
			WHEN [Frequency] = N'Weekly' THEN DATEADD(WEEK, [Duration], [StartDateTime])
			WHEN [Frequency] = N'Monthly' THEN DATEADD(MONTH, [Duration], [StartDateTime])
			WHEN [Frequency] = N'Quarterly' THEN DATEADD(QUARTER, [Duration], [StartDateTime])
			WHEN [Frequency] = N'Yearly' THEN DATEADD(YEAR, [Duration], [StartDateTime])
		END
	FROM @D1Save D

	UPDATE L -- Inherit memo from header if not null
	SET L.Memo = D.LinesMemo
	FROM @L1Save L
	JOIN @D1Save D ON L.DocumentIndex = D.[Index]
	WHERE D.LinesMemo IS NOT NULL;

	UPDATE E
	SET [Value] = [Amount]
	FROM @E1Save E
	WHERE [ResourceId] = dbo.fn_FunctionalCurrency();

	UPDATE E
	SET RelatedAgentId = CustodyId
	FROM @E1Save E
	WHERE AccountId IN (N'ShorttermEmployeeBenefitsAccruals', N'CurrentPayablesToEmployees');
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
	[Frequency]				NVARCHAR (255) '$.Frequency',
	[Duration]				INT '$.Duration',
	[StartDateTime]			DATETIMEOFFSET (7) '$.StartDateTime',
	[EndDateTime]			DATETIMEOFFSET (7) '$.EndDateTime',
	[Mode]					NVARCHAR (255) '$.Mode',
	[SerialNumber]			INT '$.SerialNumber',
	[ResponsibleAgentId]	INT '$.ResponsibleAgentId',
	[ForwardedToAgentId]	INT '$.ForwardedToAgentId',
	[FolderId]				INT '$.FolderId',
	[LinesMemo]				NVARCHAR (255) '$.LinesMemo',
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
	[Id], [State], [TransactionType], [ResponsibleAgentId],	[FolderId],	[LinesMemo],[StartDateTime], [EndDateTime],
	[LinesCustody1], [LinesCustody2], [LinesCustody3], [LinesReference1], [LinesReference2], [LinesReference3],
	[EntityState]
)
SELECT 
	[Id], [State], [TransactionType], [ResponsibleAgentId],	[FolderId],	[LinesMemo],[StartDateTime], [EndDateTime],
	[LinesCustody1], [LinesCustody2], [LinesCustody3], [LinesReference1], [LinesReference2], [LinesReference3],
	N'Unchanged' As [EntityState]
FROM [dbo].[Documents] WHERE LinesMemo Like N'Capital%'
INSERT INTO @L2Save(
	[Id], [DocumentIndex], [DocumentId], [BaseLineId], [ScalingFactor], [Memo], [EntityState]	
)
SELECT 
	L.[Id], D.[Index]	, L.[DocumentId], [BaseLineId], [ScalingFactor], L.[Memo], N'Unchanged'
FROM [dbo].[Lines] L
JOIN @D2Save D ON L.[DocumentId] = D.[Id]
INSERT INTO @E2Save (
	[Id], [LineIndex], [LineId], EntryNumber, OperationId,	AccountId, CustodyId, ResourceId, Direction, Amount, [Value], NoteId, [RelatedReference], [RelatedAgentId], [RelatedResourceId], [RelatedAmount], [EntityState]
)
SELECT
	E.[Id], L.[Index],	[LineId], EntryNumber, OperationId,	AccountId, CustodyId, ResourceId, Direction, Amount, [Value], NoteId, [RelatedReference], [RelatedAgentId], [RelatedResourceId], [RelatedAmount], N'Unchanged' AS [EntityState]
FROM [dbo].[Entries] E
JOIN @L2Save L ON E.[LineId] = L.[Id]

UPDATE @D2Save SET [StartDateTime] = '2018.01.02', [EntityState] = N'Updated'
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
	[Frequency]				NVARCHAR (255) '$.Frequency',
	[Duration]				INT '$.Duration',
	[StartDateTime]			DATETIMEOFFSET (7) '$.StartDateTime',
	[EndDateTime]			DATETIMEOFFSET (7) '$.EndDateTime',
	[Mode]					NVARCHAR (255) '$.Mode',
	[SerialNumber]			INT '$.SerialNumber',
	[ResponsibleAgentId]	INT '$.ResponsibleAgentId',
	[ForwardedToAgentId]	INT '$.ForwardedToAgentId',
	[FolderId]				INT '$.FolderId',
	[LinesMemo]				NVARCHAR (255) '$.LinesMemo',
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

DECLARE @Docs [dbo].[IndexedIdForSaveList];
INSERT INTO @Docs([Id]) VALUES
	(1)
	, (2)
	, (3) 
	, (4)
	, (5)
	, (6)
	, (7)
	, (8)
	, (9)
	, (10)
	, (11) -- reinforcement
	, (12)
	, (13)
	, (14) -- Employee Hire
	, (15)
	, (16)
	, (17) -- Paysheet
	, (18) -- payment
	;
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
	@EntriesResultJson = @E3ResultJson OUTPUT;

IF @ValidationErrorsJson IS NOT NULL 
BEGIN
	Print 'Manual JV: Location 4'
	GOTO Err_Label;
END;
--select * FROM Documents where  Id in (Select Id from @Docs);
--SElect * from lines where DocumentId in (Select Id from @Docs);
--select * from entries where lineid in (select id from lines where DocumentId in (Select Id from @Docs));
