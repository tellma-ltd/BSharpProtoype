BEGIN -- Cleanup & Declarations
	DECLARE @IfrsDisclosureDetailsDTO [IfrsDisclosureDetailList];
END
INSERT INTO @IfrsDisclosureDetailsDTO
([IfrsDisclosureId],[Value]) Values
-- Ifrs values
(N'NameOfReportingEntityOrOtherMeansOfIdentification', N'Banan IT, plc'),
(N'DomicileOfEntity', N'ET'),
(N'LegalFormOfEntity', N'PrivateLimitedCompany'),
(N'CountryOfIncorporation', N'ET'),
(N'AddressOfRegisteredOfficeOfEntity', N'Addis Abab, Bole Subcity, Woreda 6, House 316/3/203A'),
(N'PrincipalPlaceOfBusiness', N'Markan GH, Girgi, Addis Ababa'),
(N'DescriptionOfNatureOfEntitysOperationsAndPrincipalActivities', N'Software design, development and implementation'),
(N'NameOfParentEntity', N'BIOSS'),
(N'NameOfUltimateParentOfGroup', N'BIOSS');
-- Non Ifrs values
--(N'TaxIdentificationNumber', N'123456789'),
--(N'FunctionalCurrencyCode', N'ETB');

EXEC [dbo].[api_IfrsDisclosureDetails__Save]
	@Entities = @IfrsDisclosureDetailsDTO,
	@ValidationErrorsJson = @ValidationErrorsJson OUTPUT,
	@ResultsJson = @ResultsJson OUTPUT

EXEC rpt_Ifrs @fromDate = '2018.07.01', @toDate = '2019.06.30'

IF @ValidationErrorsJson IS NOT NULL 
BEGIN
	Print 'Place: Settings 1'
	GOTO Err_Label;
END

--IF @DebugSettings = 1
	SELECT * FROM [dbo].[IfrsDisclosureDetails];