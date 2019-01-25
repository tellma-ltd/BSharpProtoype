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
		[CreatedAt] DATETIMEOFFSET(7) '$.CreatedAt',
		[CreatedBy] INT '$.CreatedBy',
		[ModifiedAt] DATETIMEOFFSET(7) '$.ModifiedAt',
		[ModifiedBy] INT '$.ModifiedBy',
		[EntityState] NVARCHAR(255) '$.EntityState'
	);