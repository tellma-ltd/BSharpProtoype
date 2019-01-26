CREATE FUNCTION [dbo].[fr_Settings__Json] (
	@Json NVARCHAR(MAX)
)
RETURNS TABLE
AS
	RETURN
	SELECT *
	FROM OpenJson(@Json)
	WITH (
		[Field] NVARCHAR (255) '$.Field',
		[Value] NVARCHAR (255) '$.Value',
		[CreatedAt] DATETIMEOFFSET(7) '$.CreatedAt',
		[CreatedById] INT '$.CreatedById',
		[ModifiedAt] DATETIMEOFFSET(7) '$.ModifiedAt',
		[ModifiedById] INT '$.ModifiedById',
		[EntityState] NVARCHAR(255) '$.EntityState'
	);