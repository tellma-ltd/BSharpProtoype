CREATE PROCEDURE [dbo].[dal_Operations__Select]
	@Ids [dbo].[IntegerList] READONLY,
	@EntitiesResultJson NVARCHAR(MAX) OUTPUT
AS
SELECT @EntitiesResultJson =	(
	SELECT
		[Id], [Name], [IsOperatingSegment], [IsActive], [Code], [ParentId], 
		[CreatedAt], [CreatedBy], [ModifiedAt], [ModifiedBy], N'Unchanged' As [EntityState]
	FROM [dbo].Operations
	WHERE [Id] IN (SELECT [Id] FROM @Ids)
	FOR JSON PATH
);