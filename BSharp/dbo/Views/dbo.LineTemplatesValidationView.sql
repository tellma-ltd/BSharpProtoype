
CREATE VIEW [dbo].[LineTemplatesValidationView]
AS
SELECT * FROM dbo.LineTemplates
WHERE Definition = N'Label'
