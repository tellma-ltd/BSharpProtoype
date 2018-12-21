CREATE VIEW [dbo].[LineTemplatesCalculationView]
AS
SELECT *
FROM [dbo].[TransactionSpecifications]
WHERE (Definition = N'Calculation');