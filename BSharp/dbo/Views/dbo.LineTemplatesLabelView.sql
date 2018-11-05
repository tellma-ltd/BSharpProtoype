
CREATE VIEW [dbo].[LineTemplatesLabelView]
AS
SELECT * FROM dbo.LineTemplates
WHERE Definition = N'Label'
