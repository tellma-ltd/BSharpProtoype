CREATE VIEW [dbo].[OrganizationsView]
AS
SELECT Title, [Name] As [Registered Name], CONVERT(nchar(10), BirthDateTime, 104) As [Registration Date], IsActive AS [Active?], TaxIdentificationNumber As TIN
FROM [dbo].[Custodies]
WHERE CustodyType = N'Agent'
AND AgentType = N'Organization';