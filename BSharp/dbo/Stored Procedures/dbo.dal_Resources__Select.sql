CREATE PROCEDURE [dbo].[dal_Resources__Select]
	@IndexedIds dbo.IndexedIdList READONLY,
	@ResourcesResultJson NVARCHAR(MAX) OUTPUT
AS
SELECT @ResourcesResultJson =	(
	SELECT
		T.[Index], R.[Id],R.[MeasurementUnitId], R.[ResourceType], R.[Name], R.[Source], R.[Purpose], 
		R.[Memo], R.[Lookup1], R.[Lookup2], R.[Lookup3], R.[Lookup4], R.[FungibleParentId], R.[IsActive], R.[Code], 
		R.[CreatedAt], R.[CreatedBy], R.[ModifiedAt], R.[ModifiedBy], N'Unchanged' As [EntityState]
	FROM [dbo].[Resources] R JOIN (
		SELECT [Index], [Id] 
		FROM @IndexedIds
	) T ON R.Id = T.Id
	FOR JSON PATH
);