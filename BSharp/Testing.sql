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

	DECLARE @ValidationErrorsJson nvarchar(max); 
	DECLARE @LookupsSelect bit = 0;
END
BEGIN TRY
	BEGIN TRANSACTION
		EXEC sp_set_session_context 'TenantId', 106;
		EXEC sp_set_session_context 'UserId', N'mohamad.akra@banan-it.com';
		EXEC sp_set_session_context 'Language', N'AR';
		:r .\Testing00_Settings.sql
		:r .\Testing01_MeasurementUnits.sql
		:r .\Testing02_Operations.sql
		:r .\Testing03_Resources.sql
		:r .\Testing04_Agents.sql
		:r .\Testing05_Locations.sql
		:r .\Testing10_ManualJV.sql
		--:r .\Testing11_HRCycle.sql
		--:r .\Testing12_PurchasingCycle.sql
		--:r .\Testing13_ProductionCycle.sql
		--:r .\Testing14_SalesCycle.sql
	DECLARE @fromDate Datetime = '2017.01.01', @toDate Datetime = '2024.01.01';
	SELECT * from ft_Journal(@fromDate, @toDate) ORDER BY [Id], [LineId], [EntryId];
	EXEC rpt_TrialBalance @fromDate = @fromDate, @toDate = @toDate, @ByCustody = 0, @ByResource = 0;
	EXEC rpt_TrialBalance @fromDate = '2017.01.01', @toDate = '2018.01.01', @ByCustody = 0, @ByResource = 0;
	EXEC rpt_WithholdingTaxOnPayment;
	EXEC rpt_ERCA__VAT_Purchases;
	EXEC rpt_IFRS @fromDate = @fromDate, @toDate = @toDate;
	DECLARE @i int = 0;
	SELECT @fromDate = '2017.01.01', @toDate = '2018.01.01';
	WHILE @i < 7
	BEGIN
		EXEC [dbo].[rpt_AssetRegister] @fromDate = @fromDate, @toDate = @toDate;
		SELECT @fromDate = DATEADD(year, 1, @fromDate), @toDate = DATEADD(year, 1, @toDate);
		SET @i = @i + 1;
	END
	EXEC [dbo].[rpt_AssetRegister] @fromDate = '2017.02.01', @toDate = '2018.02.01';
	EXEC [dbo].[rpt_AssetRegister] @fromDate = '2017.01.01', @toDate = '2023.12.31';

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