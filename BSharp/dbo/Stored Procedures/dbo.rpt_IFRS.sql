
CREATE PROCEDURE [dbo].[rpt_IFRS] --R
	@fromDate Date = NULL, 
	@toDate Date = NULL,
	@PresentationCurrency nchar(3) = NULL,
	@RoundingLevel int = 0
AS
BEGIN
	SET NOCOUNT ON;
	IF @PresentationCurrency IS NULL
		SET @PresentationCurrency = dbo.fn_Settings(N'FunctionalCurrency');

	CREATE TABLE dbo.#IFRS(
		[Field] [nvarchar](255) PRIMARY KEY,
		[Value] [nvarchar](255) NULL
	);

	INSERT INTO #IFRS
	SELECT * FROM dbo.Settings
	WHERE Field IN (
		N'DisclosureOfGeneralInformationAboutFinancialStatementsExplanatory',
		N'NameOfReportingEntityOrOtherMeansOfIdentification', -- Ok
		N'ExplanationOfChangeInNameOfReportingEntityOrOtherMeansOfIdentificationFromEndOfPrecedingReportingPeriod',
		N'DescriptionOfNatureOfFinancialStatements');

	DECLARE @strRoundingLevel nvarchar(50) = CAST(@RoundingLevel AS nvarchar(50)), 
			@strPeriod nvarchar(50) = cast(@fromDate as nvarchar(50)) + N' - ' + cast(@toDate as nvarchar(50)),
			@strToDate nvarchar(50) = cast(@toDate as nvarchar(50));
	INSERT INTO #IFRS([Field], [Value]) VALUES
	(N'DescriptionOfPresentationCurrency', @PresentationCurrency),
	(N'PeriodCoveredByFinancialStatements', @strPeriod),
	(N'LevelOfRoundingUsedInFinancialStatements', @strRoundingLevel),
	(N'DateOfEndOfReportingPeriod2013', @strToDate)

	SELECT * FROM #IFRS;
	DROP TABLE #IFRS;
END
