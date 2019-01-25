CREATE FUNCTION [dbo].[fr_Resources__Json] (
	@RJson NVARCHAR(MAX)
)
RETURNS TABLE
AS
	RETURN
	SELECT *
	FROM OpenJson(@RJson)
	WITH (
		[Id] INT '$.Id',
		[MeasurementUnitId] INT '$.MeasurementUnitId',
		[ResourceType] NVARCHAR (255) '$.ResourceType',
		[Name] NVARCHAR (255) '$.Name',
		[IsActive] BIT '$.IsActive',
		[Code] NVARCHAR (255) '$.Code',
		[PartOfId] INT '$.PartOfId',
		[InstanceOfId] INT '$.InstanceOfId',
		[ServiceOfId] INT '$.ServiceOfId',
		[CreatedAt] DATETIMEOFFSET(7) '$.CreatedAt',
		[CreatedBy] INT '$.CreatedBy',
		[ModifiedAt] DATETIMEOFFSET(7) '$.ModifiedAt',
		[ModifiedBy] INT '$.ModifiedBy',
		[EntityState] NVARCHAR(255) '$.EntityState'
	);