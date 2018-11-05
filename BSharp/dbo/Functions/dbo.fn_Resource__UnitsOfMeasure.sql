

CREATE FUNCTION [dbo].[fn_Resource__UnitsOfMeasure] 
(	
	@Resource int
)
RETURNS TABLE 
AS
RETURN 
(
	SELECT Id
	FROM dbo.UnitsOfMeasure
	WHERE UnitType = (
		SELECT UnitType 
		FROM dbo.UnitsOfMeasure 
		WHERE Id = dbo.fn_Resource__UnitOfMeasure(@Resource)
	)
)

