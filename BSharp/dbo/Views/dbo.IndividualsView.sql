CREATE VIEW [dbo].[IndividualsView]
AS
SELECT Title, [Name] As [Full Name], CONVERT(NVARCHAR(255), BirthDateTime, 104) As DOB, IsActive As [Active ?], TaxIdentificationNumber As TIN, Gender
FROM [dbo].[Agents]
WHERE [RelationType] = N'Agent'
AND [PersonType] = N'Individual';