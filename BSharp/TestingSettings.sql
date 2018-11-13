BEGIN -- Cleanup & Declarations
	DECLARE @Settings SettingList, @SettingsResult SettingList;
END
INSERT INTO @Settings
([Field],[Value]) Values
-- IFRS values
(N'NameOfReportingEntityOrOtherMeansOfIdentification', N'Banan IT, plc'),
(N'DomicileOfEntity', N'ET'),
(N'LegalFormOfEntity', N'PrivateLimitedCompany'),
(N'CountryOfIncorporation', N'ET'),
(N'AddressOfRegisteredOfficeOfEntity', N'Addis Abab, Bole Subcity, Woreda 6, House 316/3/203A'),
(N'PrincipalPlaceOfBusiness', N'Markan GH, Girgi, Addis Ababa'),
(N'DescriptionOfNatureOfEntitysOperationsAndPrincipalActivities', N'Software design, development and implementation'),
(N'NameOfParentEntity', N'BIOSS'),
(N'NameOfUltimateParentOfGroup', N'BIOSS'),
-- Non IFRS values
(N'TaxIdentificationNumber', N'123456789'),
(N'FunctionalCurrencyUnit', N'ETB');

DELETE FROM @SettingsResult; INSERT INTO @SettingsResult([Field], [Value], [Status])
EXEC  [dbo].[api_Settings__Save]  @Settings = @Settings; DELETE FROM @Settings WHERE Status IN (N'Inserted', N'Updated', 'Deleted'); INSERT INTO @Settings SELECT * FROM @SettingsResult;

SELECT * FROM @Settings;