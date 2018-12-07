SET NOCOUNT ON;
BEGIN -- reset Identities
	-- Just for debugging convenience. Even though we are roling the transaction, the identities are changing
	IF NOT EXISTS(SELECT * FROM [dbo].[MeasurementUnits])	DBCC CHECKIDENT ('[dbo].[MeasurementUnits]', RESEED, 0) WITH NO_INFOMSGS;
	IF NOT EXISTS(SELECT * FROM [dbo].[Operations])			DBCC CHECKIDENT ('[dbo].[Operations]', RESEED, 0) WITH NO_INFOMSGS;
	IF NOT EXISTS(SELECT * FROM [dbo].Custodies)			DBCC CHECKIDENT ('[dbo].Custodies', RESEED, 0) WITH NO_INFOMSGS;
	IF NOT EXISTS(SELECT * FROM [dbo].Resources)			DBCC CHECKIDENT ('[dbo].Resources', RESEED, 0) WITH NO_INFOMSGS;
	IF NOT EXISTS(SELECT * FROM [dbo].Entries)				DBCC CHECKIDENT ('[dbo].Entries', RESEED, 0) WITH NO_INFOMSGS;
	IF NOT EXISTS(SELECT * FROM [dbo].Lines)				DBCC CHECKIDENT ('[dbo].Lines', RESEED, 0) WITH NO_INFOMSGS;
	IF NOT EXISTS(SELECT * FROM [dbo].Documents)			DBCC CHECKIDENT ('[dbo].Documents', RESEED, 0) WITH NO_INFOMSGS;

	DECLARE @ValidationErrorsJson nvarchar(max), @IndexedIdsJson NVARCHAR(MAX);
	DECLARE @IndexedIds [dbo].[IndexedIdList];
	DECLARE @A1Result AgentList, @A2Result AgentList;
	DECLARE @L1Result LocationList, @L2Result LocationList;
END
BEGIN TRY
	BEGIN TRANSACTION
		EXEC sp_set_session_context 'Tenantid', 106;
		EXEC sp_set_session_context 'Language', N'AR';
		:r .\TestingSettings.sql
	--	:r .\TestingMeasurementUnits.sql
		:r .\TestingAgents.sql
		:r .\TestingLocations.sql
	--	:r .\TestingOperations.sql
	--	:r .\TestingResources.sql
	--	:r .\TestingManualJV.sql
	--SELECT * FROM dbo.MeasurementUnits;
	SELECT * FROM @A1Result; SELECT * FROM @A2Result;
	SELECT * FROM @L1Result; SELECT * FROM @L2Result;
	--SELECT * FROM [dbo].Custodies;
	--SELECT * FROM [dbo].[Operations];
	--SELECT * FROM [dbo].Resources;
	--SELECT * FROM [dbo].Documents;
	--SELECT * FROM [dbo].Lines;
	--SELECT * FROM [dbo].Entries;
	--SELECT * from ft_Journal('2018.01.01', '2018.01.01') ORDER BY Id, LineId, EntryId;
	--EXEC rpt_TrialBalance @fromDate = '2018.01.01', @toDate = '2018.06.30', @ByCustody = 0, @ByResource = 0;
	ROLLBACK;
END TRY
BEGIN CATCH
	ROLLBACK;
	THROW;
END CATCH
RETURN;

ERR_LABEL:
	--SELECT * FROM dbo.MeasurementUnits;
	SELECT * FROM [dbo].Custodies;
	--SELECT * FROM [dbo].[Operations];
	--SELECT * FROM [dbo].Resources;
	--SELECT * FROM [dbo].Documents;
	--SELECT * FROM [dbo].Lines;
	--SELECT * FROM [dbo].Entries;
	SELECT * FROM OpenJson(@ValidationErrorsJson)
	WITH (
		[Key] NVARCHAR(255) '$.Key',
		[ErrorName] NVARCHAR(255) '$.ErrorName',
		[Argument1] NVARCHAR(255) '$.Argument1',
		[Argument2] NVARCHAR(255) '$.Argument2',
		[Argument3] NVARCHAR(255) '$.Argument3',
		[Argument4] NVARCHAR(255) '$.Argument4',
		[Argument5] NVARCHAR(255) '$.Argument5'	
	);
	ROLLBACK;
RETURN;

SELECT * from ft_Journal('01.01.2000', '01.01.2200') ORDER BY Id, LineId, EntryId
EXEC rpt_TrialBalance;
EXEC rpt_WithholdingTaxOnPayment;
EXEC rpt_ERCA__VAT_Purchases; 

SELECT Debit, Credit from ft_Account__Statement(N'AdministrativeExpense', '2017.06.30', '2019.01.01');
SELECT * FROM ft_Journal('2017.06.30', '2019.01.01');

EXEC rpt_TrialBalance @fromDate = '2018.01.01', @toDate = '2018.06.30', @ByCustody = 0, @ByResource = 0;

