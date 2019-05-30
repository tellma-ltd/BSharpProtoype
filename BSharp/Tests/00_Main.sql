SET NOCOUNT ON;
BEGIN -- reset Identities
	-- Just for debugging convenience. Even though we are roling the transaction, the identities are changing
	IF NOT EXISTS(SELECT * FROM [dbo].[IFRSDisclosureDetails])	DBCC CHECKIDENT ('[dbo].[IFRSDisclosureDetails]', RESEED, 0) WITH NO_INFOMSGS;
	IF NOT EXISTS(SELECT * FROM [dbo].[MeasurementUnits])	DBCC CHECKIDENT ('[dbo].[MeasurementUnits]', RESEED, 0) WITH NO_INFOMSGS;
	IF NOT EXISTS(SELECT * FROM [dbo].[ResponsibilityCenters])			DBCC CHECKIDENT ('[dbo].[ResponsibilityCenters]', RESEED, 0) WITH NO_INFOMSGS;
	IF NOT EXISTS(SELECT * FROM [dbo].[Agents])			DBCC CHECKIDENT ('[dbo].[Agents]', RESEED, 0) WITH NO_INFOMSGS;
	IF NOT EXISTS(SELECT * FROM [dbo].[Resources])			DBCC CHECKIDENT ('[dbo].[Resources]', RESEED, 0) WITH NO_INFOMSGS;
	IF NOT EXISTS(SELECT * FROM [dbo].[TransactionEntries])			DBCC CHECKIDENT ('[dbo].[TransactionEntries]', RESEED, 0) WITH NO_INFOMSGS;
	IF NOT EXISTS(SELECT * FROM [dbo].[TransactionLines])				DBCC CHECKIDENT ('[dbo].[TransactionLines]', RESEED, 0) WITH NO_INFOMSGS;
	IF NOT EXISTS(SELECT * FROM [dbo].[Documents])			DBCC CHECKIDENT ('[dbo].[Documents]', RESEED, 0) WITH NO_INFOMSGS;
	DECLARE @ValidationErrorsJson nvarchar(max), @ResultsJson nvarchar(max);
	DECLARE @DebugSettings bit = 1, @DebugMeasurementUnits bit = 0;
	DECLARE @DebugOperations bit = 1, @DebugResources bit = 0;
	DECLARE @DebugAgents bit = 0, @DebugPlaces bit = 0;
	DECLARE @LookupsSelect bit = 0;
	DECLARE @fromDate Datetime, @toDate Datetime;
	EXEC sp_set_session_context 'TenantId', 106;
	EXEC sp_set_session_context 'Debug', 1;
	DECLARE @TenantId int = CONVERT(INT, SESSION_CONTEXT(N'TenantId'));
	DECLARE @UserId int;
	IF NOT EXISTS(SELECT * FROM [dbo].[LocalUsers])
	BEGIN
		INSERT INTO [dbo].[LocalUsers]([Name], [AgentId]) VALUES
		(N'Dr. Akra', NULL); -- N'DESKTOP-V0VNDC4\Mohamad Akra'
		 SET @UserId = SCOPE_IDENTITY();
	END
	ELSE
		SELECT @UserId = [Id] FROM dbo.LocalUsers WHERE [Name] = N'Dr. Akra';

	EXEC sp_set_session_context 'UserId', @UserId;
	SET @UserId = CONVERT(INT, SESSION_CONTEXT(N'UserId'));
	DECLARE @Now DATETIMEOFFSET(7) = SYSDATETIMEOFFSET();
END

BEGIN TRY
	BEGIN TRANSACTION
		:r .\01_Settings.sql
		--:r .\02_MeasurementUnits.sql
		--:r .\03_Operations.sql
		--:r .\04_Resources.sql
		--:r .\05_Agents.sql
		--:r .\10_Documents.sql
	--	select * from entries;
	--SELECT @fromDate = '2017.01.01', @toDate = '2024.03.01'
	--SELECT * from dbo.[fi_Journal](@fromDate, @toDate) ORDER BY [Id], [EntryId];
	--EXEC rpt_TrialBalance @fromDate = @fromDate, @toDate = @toDate;
	--SELECT * FROM dbo.[fi_WithholdingTaxOnPayment](default, default);
	--SELECT * FROM dbo.[fi_ERCA__VAT_Purchases](default, default);
	--EXEC rpt_IFRS @fromDate = @fromDate, @toDate = @toDate;
	--DECLARE @i int = 0;
	--SELECT @fromDate = '2017.01.1'; SELECT @toDate = DATEADD(DAY, 90, @fromDate);
	--WHILE @i < 30
	--BEGIN
	--	SELECT * FROM [dbo].[fi_AssetRegister](@fromDate, @toDate);
	--	SELECT @fromDate = DATEADD(DAY, 90, @fromDate), @toDate = DATEADD(DAY, 90, @toDate);
	--	SET @i = @i + 1;
	--END
	--SELECT * FROM dbo.[fi_AssetRegister]('2017.02.01', '2018.02.01');
	--SELECT @fromDate = '2017.01.01', @toDate = '2024.01.01';
	--SELECT * FROM dbo.fi_AssetRegister(@fromDate, @toDate);
	--SELECT * from dbo.fi_Account__Statement(N'BalancesWithBanks', @CBEETB, @ETB, @fromDate, @toDate) ORDER BY StartDateTime;
	--SELECT * from dbo.fi_Account__Statement(N'DistributionCosts', @SalesDepartment, @Goff, @fromDate, @toDate) ORDER BY StartDateTime;
	--SELECT * FROM dbo.fi_ERCA__EmployeeIncomeTax('2018.02.01', '2018.03.01');
	--SELECT * FROM dbo.fi_Paysheet(default, default, '2018.02', @Basic, @Transportation);
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
		[Key] NVARCHAR (255) '$.Key',
		[ErrorName] NVARCHAR (255) '$.ErrorName',
		[Argument1] NVARCHAR (255) '$.Argument1',
		[Argument2] NVARCHAR (255) '$.Argument2',
		[Argument3] NVARCHAR (255) '$.Argument3',
		[Argument4] NVARCHAR (255) '$.Argument4',
		[Argument5] NVARCHAR (255) '$.Argument5'	
	);
	ROLLBACK;
RETURN;