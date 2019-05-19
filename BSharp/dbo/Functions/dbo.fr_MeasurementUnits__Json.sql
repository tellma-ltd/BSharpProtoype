CREATE FUNCTION [dbo].[fr_MeasurementUnits__Json] (
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
		[Name2] NVARCHAR (255) '$.Name2',
		[Name3] NVARCHAR (255) '$.Name3',
		[Description] NVARCHAR (255) '$.Description',
		[Description2] NVARCHAR (255) '$.Description2',
		[Description3] NVARCHAR (255) '$.Description3',
		[UnitAmount] FLOAT (53) '$.UnitAmount',
		[BaseAmount] FLOAT (53) '$.BaseAmount',
		[IsActive] BIT '$.IsActive',
		[Code] NVARCHAR (255) '$.Code',
		[CreatedAt] DATETIMEOFFSET(7) '$.CreatedAt',
		[CreatedById] INT '$.CreatedById',
		[ModifiedAt] DATETIMEOFFSET(7) '$.ModifiedAt',
		[ModifiedById] INT '$.ModifiedById',
		[EntityState] NVARCHAR (255) '$.EntityState'
	);