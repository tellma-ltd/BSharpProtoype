
CREATE VIEW [dbo].[LineTemplatesValidationView]
AS
SELECT * FROM [dbo].[TransactionSpecifications]
WHERE Definition = N'Label';
