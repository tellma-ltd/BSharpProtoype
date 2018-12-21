CREATE PROCEDURE [dbo].[dal_Resources__Select]
	@Ids [dbo].[IntegerList] READONLY,
	@EntitiesResultJson NVARCHAR(MAX) OUTPUT
AS
SELECT @EntitiesResultJson = (
	SELECT
		[Id],[MeasurementUnitId], [ResourceType], [Name], [Source], [Purpose], [Memo],  
		[Lookup1], [Lookup2], [Lookup3], [Lookup4], [PartOfId], [InstanceOfId], [ServiceOfId], [IsActive], [Code], 
		[CreatedAt], [CreatedBy], [ModifiedAt], [ModifiedBy], N'Unchanged' As [EntityState]
	FROM [dbo].[Resources]
	WHERE [Id] IN (SELECT [Id] FROM @Ids)
	FOR JSON PATH
);