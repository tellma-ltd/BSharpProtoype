CREATE FUNCTION [dbo].[fr_Settings__Json] (
	@Json NVARCHAR(MAX)
)
RETURNS TABLE
AS
	RETURN
	SELECT *
	FROM OpenJson(@Json)
	WITH (
		[FunctionalCurrencyId] INT '$.FunctionalCurrencyId',
		[ArchiveDate] Date '$.ArchiveDate',
		[TenantLanguage2] NVARCHAR (255) '$.TenantLanguage2',
		[TenantLanguage3] NVARCHAR (255) '$.TenantLanguage3',
		[CreatedAt] DATETIMEOFFSET(7) '$.CreatedAt',
		[CreatedById] INT '$.CreatedById',
		[ModifiedAt] DATETIMEOFFSET(7) '$.ModifiedAt',
		[ModifiedById] INT '$.ModifiedById',
		[EntityState] NVARCHAR (255) '$.EntityState'
	);