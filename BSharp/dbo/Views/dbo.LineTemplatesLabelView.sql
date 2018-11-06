
CREATE VIEW [dbo].[LineTemplatesLabelView]
AS
SELECT * FROM dbo.[TransactionTemplates]
WHERE Definition = N'Label'
