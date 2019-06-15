CREATE FUNCTION [dbo].[fr_IfrsSettings__Json] (
	@Json NVARCHAR(MAX)
)
RETURNS TABLE

AS
	RETURN
	SELECT *
	FROM OpenJson(@Json)
	WITH (
		[Id] INT '$.Id',
		[Field] NVARCHAR (255) '$.Field',
		[Value] NVARCHAR (255) '$.Value',
		[ValidSince] Date '$.ValidSince',
		[CreatedAt] DATETIMEOFFSET(7) '$.CreatedAt',
		[CreatedById] INT '$.CreatedById',
		[ModifiedAt] DATETIMEOFFSET(7) '$.ModifiedAt',
		[ModifiedById] INT '$.ModifiedById',
		[EntityState] NVARCHAR (255) '$.EntityState'
	);
GO;