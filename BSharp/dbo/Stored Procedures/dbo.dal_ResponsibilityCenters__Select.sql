CREATE PROCEDURE [dbo].[dal_ResponsibilityCenters__Select]
	@Ids [dbo].[IntegerList] READONLY,
	@ResultsJson NVARCHAR(MAX) OUTPUT
AS
SELECT @ResultsJson =	(
	SELECT
		[Id], [Name], [IsActive], [Code], [ParentId],  [ProductCategoryId], [GeographicRegionId], [CustomerSegmentId], [OperationId],
		[CreatedAt], [CreatedById], [ModifiedAt], [ModifiedById], N'Unchanged' As [EntityState]
	FROM [dbo].[ResponsibilityCenters]
	WHERE [Id] IN (SELECT [Id] FROM @Ids)
	FOR JSON PATH
);