﻿
CREATE PROCEDURE [dbo].[rpt_IFRS] --R
	@fromDate Date = NULL, 
	@toDate Date = NULL,
	@PresentationCurrency nchar(3) = NULL,
	@RoundingLevel int = 0
AS
BEGIN
	SET NOCOUNT ON;
	IF @PresentationCurrency IS NULL
		SET @PresentationCurrency = [dbo].fn_Settings(N'FunctionalCurrency');

	CREATE TABLE [dbo].#IFRS(
		[Field] [nvarchar](255) PRIMARY KEY,
		[Value] [nvarchar](255) NULL
	);

	INSERT INTO #IFRS
	SELECT * FROM [dbo].Settings
	WHERE Field IN (
		N'DisclosureOfGeneralInformationAboutFinancialStatementsExplanatory',
		N'NameOfReportingEntityOrOtherMeansOfIdentification', -- Ok
		N'ExplanationOfChangeInNameOfReportingEntityOrOtherMeansOfIdentificationFromEndOfPrecedingReportingPeriod',
		N'DescriptionOfNatureOfFinancialStatements');

	DECLARE @strRoundingLevel NVARCHAR(255) = CAST(@RoundingLevel AS NVARCHAR(255)), 
			@strPeriod NVARCHAR(255) = cast(@fromDate as NVARCHAR(255)) + N' - ' + cast(@toDate as NVARCHAR(255)),
			@strToDate NVARCHAR(255) = cast(@toDate as NVARCHAR(255));
	INSERT INTO #IFRS([Field], [Value]) VALUES
	(N'DescriptionOfPresentationCurrency', @PresentationCurrency),
	(N'PeriodCoveredByFinancialStatements', @strPeriod),
	(N'LevelOfRoundingUsedInFinancialStatements', @strRoundingLevel),
	(N'DateOfEndOfReportingPeriod2013', @strToDate)

	SELECT * FROM #IFRS;
	DROP TABLE #IFRS;
END
