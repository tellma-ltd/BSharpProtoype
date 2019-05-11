CREATE FUNCTION [dbo].[fr_ResponsibilityCenters__Json] (
	@Json NVARCHAR(MAX)
)
RETURNS TABLE
AS
	RETURN
	SELECT *
	FROM OpenJson(@Json)
	WITH (
		[Id]						INT '$.Id',
		[ResponsibilityCenterType]	NVARCHAR (255) '$.ResponsibilityCenterType',
		[Name]						NVARCHAR (255) '$.Name',
		[Name2]						NVARCHAR (255) '$.Name2',
		[Name3]						NVARCHAR (255) '$.Name3',
		[IsOperatingSegment]		BIT '$.IsOperatingSegment',
		[IsActive]					BIT '$.IsActive',
		[ParentId]					INT '$.ParentId',
		[Code]						NVARCHAR (255) '$.Code',
		[OperationId]				INT '$.OperationId',		-- e.g., sales, services
		[ProductCategoryId]			INT '$.ProductCategoryId',		-- e.g., sales, services
		[GeographicRegionId]		INT '$.GeographicRegionId',		-- e.g., Riyadh, Jeddah
		[CustomerSegmentId]			INT '$.CustomerSegmentId',		-- e.g., Corporate, Individual or M, F or Adult youth, etc...
		[CreatedAt]					DATETIMEOFFSET(7) '$.CreatedAt',
		[CreatedById]				INT '$.CreatedById',
		[ModifiedAt]				DATETIMEOFFSET(7) '$.ModifiedAt',
		[ModifiedById]				INT '$.ModifiedById',
		[EntityState]				NVARCHAR(255) '$.EntityState'
	);