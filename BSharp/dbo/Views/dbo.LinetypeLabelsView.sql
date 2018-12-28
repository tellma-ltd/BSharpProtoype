CREATE VIEW [dbo].[LineTypeLabelsView]
AS
SELECT * FROM [dbo].[LineTypeSpecifications]
WHERE Definition = N'Label';