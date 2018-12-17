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
	DECLARE @BusinessEntity int, @Existing int, @Expansion int;
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
		:r .\Testing11_HRCycle.sql
		:r .\Testing12_PurchasingCycle.sql
		:r .\Testing13_ProductionCycle.sql
		:r .\Testing14_SalesCycle.sql

	SELECT * from ft_Journal('2018.01.01', '2018.01.31') ORDER BY [Id], [LineId], [EntryId];
	EXEC rpt_TrialBalance @fromDate = '2018.01.01', @toDate = '2018.06.30', @ByCustody = 0, @ByResource = 0;
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

SELECT * from ft_Journal('01.01.2000', '01.01.2200') ORDER BY [Id], [LineId], EntryId
EXEC rpt_TrialBalance;
EXEC rpt_WithholdingTaxOnPayment;
EXEC rpt_ERCA__VAT_Purchases; 

SELECT Debit, Credit from ft_Account__Statement(N'AdministrativeExpense', '2017.06.30', '2019.01.01');
SELECT * FROM ft_Journal('2017.06.30', '2019.01.01');

EXEC rpt_TrialBalance @fromDate = '2018.01.01', @toDate = '2018.06.30', @ByCustody = 0, @ByResource = 0;

