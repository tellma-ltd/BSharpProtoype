CREATE VIEW [dbo].[LineTypeValidationsView]
AS
SELECT * FROM [dbo].[LineTypeSpecifications]
WHERE Definition = N'Validation';