SET NOCOUNT ON;
BEGIN -- reset Identities
	-- Just for debugging convenience. Even though we are roling the transaction, the identities are changing
	IF NOT EXISTS(SELECT * FROM [dbo].[MeasurementUnits])	DBCC CHECKIDENT ('[dbo].[MeasurementUnits]', RESEED, 0) WITH NO_INFOMSGS;
	IF NOT EXISTS(SELECT * FROM [dbo].[Operations])			DBCC CHECKIDENT ('[dbo].[Operations]', RESEED, 0) WITH NO_INFOMSGS;
	IF NOT EXISTS(SELECT * FROM [dbo].[Custodies])			DBCC CHECKIDENT ('[dbo].[Custodies]', RESEED, 0) WITH NO_INFOMSGS;
	IF NOT EXISTS(SELECT * FROM [dbo].Resources)			DBCC CHECKIDENT ('[dbo].[Resources]', RESEED, 0) WITH NO_INFOMSGS;
	IF NOT EXISTS(SELECT * FROM [dbo].[Entries])			DBCC CHECKIDENT ('[dbo].[Entries]', RESEED, 0) WITH NO_INFOMSGS;
	IF NOT EXISTS(SELECT * FROM [dbo].Lines)				DBCC CHECKIDENT ('[dbo].[Lines]', RESEED, 0) WITH NO_INFOMSGS;
	IF NOT EXISTS(SELECT * FROM [dbo].[Documents])			DBCC CHECKIDENT ('[dbo].[Documents]', RESEED, 0) WITH NO_INFOMSGS;

	DECLARE @ValidationErrorsJson nvarchar(max), @ResultsJson nvarchar(max);
	DECLARE @DebugSettings bit = 0, @DebugMeasurementUnits bit = 0;
	DECLARE @DebugOperations bit = 0, @DebugResources bit = 0;
	DECLARE @DebugAgents bit = 0, @DebugLocations bit = 0;
	DECLARE @LookupsSelect bit = 0;
	DECLARE @fromDate Datetime, @toDate Datetime;
END
BEGIN TRY
	BEGIN TRANSACTION
		EXEC sp_set_session_context 'TenantId', 106;
		EXEC sp_set_session_context 'UserId', N'mohamad.akra@banan-it.com';
		:r .\00_Settings.sql
		:r .\01_MeasurementUnits.sql
		:r .\02_Operations.sql
		:r .\03_Resources.sql
		:r .\04_Agents.sql
		:r .\05_Locations.sql
		--:r .\10_Documents.sql

	--SELECT @fromDate = '2017.02.01', @toDate = '2024.03.01'
	--SELECT * from ft_Journal(@fromDate, @toDate) ORDER BY [Id], [LineId], [EntryId];
	--EXEC rpt_TrialBalance @fromDate = '2017.01.01', @toDate = '2017.02.01', @ByCustody = 0, @ByResource = 0;
	--EXEC rpt_WithholdingTaxOnPayment;
	--EXEC rpt_ERCA__VAT_Purchases;
	--EXEC rpt_IFRS @fromDate = @fromDate, @toDate = @toDate;
	--DECLARE @i int = 0;
	--SELECT @fromDate = '2017.01.1'; SELECT @toDate =DATEADD(DAY, 90, @fromDate);
	--WHILE @i < 30
	--BEGIN
	--	EXEC [dbo].[rpt_AssetRegister] @fromDate = @fromDate, @toDate = @toDate;
	--	SELECT @fromDate = DATEADD(DAY, 90, @fromDate), @toDate = DATEADD(DAY, 90, @toDate);
	--	SET @i = @i + 1;
	--END
	--EXEC [dbo].[rpt_AssetRegister] @fromDate = '2017.02.01', @toDate = '2018.02.01';
	--SELECT @fromDate = '2017.01.01', @toDate = '2024.01.01';
	--EXEC [dbo].[rpt_AssetRegister] @fromDate = @fromDate, @toDate = @toDate;
	--SELECT * from ft_Account__Statement(N'BalancesWithBanks', @CBEETB, @ETB, @fromDate, @toDate) ORDER BY StartDateTime;
	--SELECT * from ft_Account__Statement(N'DistributionCosts', @SalesManager, @Goff, @fromDate, @toDate) ORDER BY StartDateTime;
	--EXEC [dbo].[rpt_ERCA__EmployeeIncomeTax] @fromDate = '2018.02.01', @toDate = '2018.03.01';
	--EXEC [dbo].[rpt_Paysheet] @Reference = '2018.02';
	ROLLBACK;
END TRY
BEGIN CATCH
	ROLLBACK;
	THROW;
END CATCH
RETURN;

ERR_LABEL:
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