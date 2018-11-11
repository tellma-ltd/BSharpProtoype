BEGIN -- Cleanup & Declarations
	SET NOCOUNT ON;
	DECLARE @Settings TABLE(
		[Field] NVARCHAR (255)  NOT NULL,
		[Value] NVARCHAR (1024) NOT NULL,
		PRIMARY KEY CLUSTERED ([Field] ASC)
);
END
INSERT INTO @Settings Values
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

MERGE dbo.Settings AS t
USING @Settings AS s
ON s.[Field] = t.[Field] --AND s.tenantId = t.tenantId
WHEN MATCHED AND s.[Value] <> t.[Value] THEN
UPDATE
	SET t.[Value] = s.[Value]
WHEN NOT MATCHED BY SOURCE THEN
		DELETE
WHEN NOT MATCHED BY TARGET THEN
		INSERT ([Field], [Value])
		VALUES (s.[Field], s.[Value]);

SELECT * FROM @Settings