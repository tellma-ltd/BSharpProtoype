CREATE FUNCTION [dbo].[ft_MeasurementUnits__Json] (
	@Json NVARCHAR(MAX)
)
RETURNS TABLE

AS
	RETURN
	SELECT *
	FROM OpenJson(@Json)
	WITH (
		[Id] INT '$.Id',
		[UnitType] NVARCHAR (255) '$.UnitType',
		[Name] NVARCHAR (255) '$.Name',
		[Description] NVARCHAR (255) '$.Description',
		[UnitAmount] FLOAT (53) '$.UnitAmount',
		[BaseAmount] FLOAT (53) '$.BaseAmount',
		[IsActive] BIT '$.IsActive',
		[Code] NVARCHAR (255) '$.Code',
		[CreatedAt] DATETIMEOFFSET(7) '$.CreatedAt',
		[CreatedBy] NVARCHAR(450) '$.CreatedBy',
		[ModifiedAt] DATETIMEOFFSET(7) '$.ModifiedAt',
		[ModifiedBy] NVARCHAR(450) '$.ModifiedBy',
		[EntityState] NVARCHAR(255) '$.EntityState'
	);