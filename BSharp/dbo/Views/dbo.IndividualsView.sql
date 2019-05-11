CREATE VIEW [dbo].[IndividualsView]
AS
SELECT TitleId, [Name] As [Full Name], CONVERT(NVARCHAR(255), BirthDateTime, 104) As DOB, IsActive As [Active ?], TaxIdentificationNumber As TIN, Gender
FROM [dbo].[Agents]
WHERE [PersonType] = N'Individual';