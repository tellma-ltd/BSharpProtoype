SET NOCOUNT ON;
BEGIN -- reset Identities
	-- Just for debugging convenience. Even though we are roling the transaction, the identities are changing
	IF NOT EXISTS(SELECT * FROM [dbo].[MeasurementUnits])	DBCC CHECKIDENT ('[dbo].[MeasurementUnits]', RESEED, 0) WITH NO_INFOMSGS;
	IF NOT EXISTS(SELECT * FROM [dbo].[Operations])			DBCC CHECKIDENT ('[dbo].[Operations]', RESEED, 0) WITH NO_INFOMSGS;
	IF NOT EXISTS(SELECT * FROM [dbo].[Custodies])			DBCC CHECKIDENT ('[dbo].[Custodies]', RESEED, 0) WITH NO_INFOMSGS;
	IF NOT EXISTS(SELECT * FROM [dbo].[Resources])			DBCC CHECKIDENT ('[dbo].[Resources]', RESEED, 0) WITH NO_INFOMSGS;
	IF NOT EXISTS(SELECT * FROM [dbo].[Entries])			DBCC CHECKIDENT ('[dbo].[Entries]', RESEED, 0) WITH NO_INFOMSGS;
	IF NOT EXISTS(SELECT * FROM [dbo].[Lines])				DBCC CHECKIDENT ('[dbo].[Lines]', RESEED, 0) WITH NO_INFOMSGS;
	IF NOT EXISTS(SELECT * FROM [dbo].[Documents])			DBCC CHECKIDENT ('[dbo].[Documents]', RESEED, 0) WITH NO_INFOMSGS;

	DECLARE @ValidationErrorsJson nvarchar(max), @ResultsJson nvarchar(max);
	DECLARE @DebugSettings bit = 0, @DebugMeasurementUnits bit = 0;
	DECLARE @DebugOperations bit = 0, @DebugResources bit = 0;
	DECLARE @DebugAgents bit = 0, @DebugPlaces bit = 0;
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
		:r .\05_Places.sql
		:r .\10_Documents.sql

	SELECT @fromDate = '2017.02.01', @toDate = '2024.03.01'
	SELECT * from dbo.ft_Journal(@fromDate, @toDate) ORDER BY [Id], [LineId], [EntryId];
	EXEC rpt_TrialBalance @fromDate = '2017.01.01', @toDate = '2017.02.01', @ByCustody = 0, @ByResource = 0;
	SELECT * FROM dbo.ft_WithholdingTaxOnPayment(default, default);
	SELECT * FROM dbo.ft_ERCA__VAT_Purchases(default, default);
	--EXEC rpt_IFRS @fromDate = @fromDate, @toDate = @toDate;
	--DECLARE @i int = 0;
	--SELECT @fromDate = '2017.01.1'; SELECT @toDate = DATEADD(DAY, 90, @fromDate);
	--WHILE @i < 30
	--BEGIN
	--	SELECT * FROM [dbo].[ft_AssetRegister](@fromDate, @toDate);
	--	SELECT @fromDate = DATEADD(DAY, 90, @fromDate), @toDate = DATEADD(DAY, 90, @toDate);
	--	SET @i = @i + 1;
	--END
	--	SELECT * FROM dbo.[ft_AssetRegister]('2017.02.01', '2018.02.01');
	--SELECT @fromDate = '2017.01.01', @toDate = '2024.01.01';
	--SELECT * FROM dbo.ft_AssetRegister(@fromDate, @toDate);
	--SELECT * from dbo.ft_Account__Statement(N'BalancesWithBanks', @CBEETB, @ETB, @fromDate, @toDate) ORDER BY StartDateTime;
	--SELECT * from dbo.ft_Account__Statement(N'DistributionCosts', @SalesManager, @Goff, @fromDate, @toDate) ORDER BY StartDateTime;
	--SELECT * FROM dbo.ft_ERCA__EmployeeIncomeTax('2018.02.01', '2018.03.01');
	--SELECT * FROM dbo.ft_Paysheet(default, default, '2018.02', @Basic, @Transportation);
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