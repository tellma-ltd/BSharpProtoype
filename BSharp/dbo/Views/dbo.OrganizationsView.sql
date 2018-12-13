
CREATE VIEW [dbo].[OrganizationsView]
AS
SELECT Title, [Name] As [Registered Name], CONVERT(nchar(10), BirthDateTime, 104) As [Registration Date], IsActive AS [Active?], TaxIdentificationNumber As TIN --, UserId
FROM [dbo].Agents A JOIN [dbo].[Custodies] C ON A.Id = C.Id
WHERE AgentType = N'Organization';
GO;