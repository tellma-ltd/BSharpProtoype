CREATE FUNCTION [dbo].[fr_Operations__Json] (
	@Json NVARCHAR(MAX)
)
RETURNS TABLE
AS
	RETURN
	SELECT *
	FROM OpenJson(@Json)
	WITH (
		[Id] INT '$.Id',
		[Name] NVARCHAR (255) '$.Name',
		[IsOperatingSegment] BIT '$.IsOperatingSegment',
		[IsActive] BIT '$.IsActive',
		[Code] NVARCHAR (255) '$.Code',
		[ParentId] INT '$.ParentId',
		[ProductCategoryId]		INT '$.ProductCategoryId',		-- e.g., sales, services
		[GeographicRegionId]	INT '$.GeographicRegionId',		-- e.g., Riyadh, Jeddah
		[CustomerSegmentId]		INT '$.CustomerSegmentId',		-- e.g., Corporate, Individual or M, F or Adult youth, etc...
		[FunctionId]			INT '$.FunctionId',		-- e.g., HQ, Branch, Accommodation
		[CreatedAt] DATETIMEOFFSET(7) '$.CreatedAt',
		[CreatedById] INT '$.CreatedById',
		[ModifiedAt] DATETIMEOFFSET(7) '$.ModifiedAt',
		[ModifiedById] INT '$.ModifiedById',
		[EntityState] NVARCHAR(255) '$.EntityState'
	);