CREATE PROCEDURE [dbo].[dal_Operations__Select]
	@Ids [dbo].[IntegerList] READONLY,
	@ResultsJson NVARCHAR(MAX) OUTPUT
AS
SELECT @ResultsJson =	(
	SELECT
		[Id], [Name], [IsOperatingSegment], [IsActive], [Code], [ParentId], 
		[CreatedAt], [CreatedById], [ModifiedAt], [ModifiedById], N'Unchanged' As [EntityState]
	FROM [dbo].Operations
	WHERE [Id] IN (SELECT [Id] FROM @Ids)
	FOR JSON PATH
);