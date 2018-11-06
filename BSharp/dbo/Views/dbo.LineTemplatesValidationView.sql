
CREATE VIEW [dbo].[LineTemplatesValidationView]
AS
SELECT * FROM dbo.[TransactionTemplates]
WHERE Definition = N'Label'
