BEGIN -- Cleanup & Declarations
	DECLARE @S1Result [dbo].SettingList, @S2Result [dbo].SettingList;
	DECLARE @S1Save SettingForSaveList, @S2Save SettingForSaveList;
	DECLARE @S1ResultJson NVARCHAR(MAX), @S2ResultJson NVARCHAR(MAX);
END
INSERT INTO @S1Save
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

	EXEC [dbo].[api_Settings__Save]
		@Settings = @S1Save,
		@ValidationErrorsJson = @ValidationErrorsJson OUTPUT,
		@SettingsResultJson = @S1ResultJson OUTPUT

	IF @ValidationErrorsJson IS NOT NULL 
	BEGIN
		Print 'Location: Settings 1'
		GOTO Err_Label;
	END

	INSERT INTO @S1Result(
		[Field], [Value], [CreatedAt], [CreatedBy], [ModifiedAt], [ModifiedBy], [EntityState]
	)
	SELECT 
		[Field], [Value], [CreatedAt], [CreatedBy], [ModifiedAt], [ModifiedBy], [EntityState]
	FROM OpenJson(@S1ResultJson)
	WITH (
		[Field] NVARCHAR (255) '$.Field',
		[Value] NVARCHAR (255) '$.Value',
		[CreatedAt] DATETIMEOFFSET(7) '$.CreatedAt',
		[CreatedBy] NVARCHAR(450) '$.CreatedBy',
		[ModifiedAt] DATETIMEOFFSET(7) '$.ModifiedAt',
		[ModifiedBy] NVARCHAR(450) '$.ModifiedBy',
		[EntityState] NVARCHAR(255) '$.EntityState'
	);
IF @LookupsSelect = 1
	SELECT * FROM [dbo].Settings;
