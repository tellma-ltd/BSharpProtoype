CREATE PROCEDURE [dbo].[bll_MeasurementUnits__Validate]
	@MeasurementUnits MeasurementUnitList READONLY
AS
SET NOCOUNT ON;
DECLARE @ValidationErrors ValidationErrorList;
-- Code must be unique
INSERT INTO @ValidationErrors([Path], [ErrorName], [Argument1], [Argument2], [Argument3], [Argument4], [Argument5]) 
SELECT '[' + CAST(MUI.[Index] AS NVARCHAR(255)) + '].Code' As [Path], N'CodeIsAlreadyInUse' As [ErrorName],
	MUI.Code AS Argument1, NULL AS Argument2,NULL AS Argument3,NULL AS Argument4, NULL AS Argument5
FROM @MeasurementUnits MUI 
JOIN dbo.MeasurementUnits MDB ON MUI.Code = MDB.Code
WHERE MUI.Status = N'Inserted';
-- Add further logic

SELECT [Path], [ErrorName], [Argument1], [Argument2], [Argument3], [Argument4], [Argument5]
FROM @ValidationErrors;

