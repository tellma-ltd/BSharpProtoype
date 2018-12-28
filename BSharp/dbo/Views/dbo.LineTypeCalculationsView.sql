CREATE VIEW [dbo].[LineTypeCalculationsView]
AS
SELECT *
FROM [dbo].[LineTypeSpecifications]
WHERE (Definition = N'Calculation');