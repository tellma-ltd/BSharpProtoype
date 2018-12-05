
CREATE VIEW [dbo].[LineTemplatesLabelView]
AS
SELECT * FROM [dbo].[TransactionSpecifications]
WHERE Definition = N'Label';
