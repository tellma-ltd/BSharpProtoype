CREATE VIEW [dbo].[IndividualsView]
AS
SELECT Title, [Name] As [Full Name], CONVERT(NVARCHAR(255), BirthDateTime, 104) As DOB, IsActive As [Active ?], TaxIdentificationNumber As TIN, UserId, Gender
FROM [dbo].[Custodies]
WHERE CustodyType = N'Agent'
AND AgentType = N'Individual';