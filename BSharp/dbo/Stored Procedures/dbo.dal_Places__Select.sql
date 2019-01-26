CREATE PROCEDURE [dbo].[dal_Places__Select]
	@Ids [dbo].[IntegerList] READONLY,
	@ResultsJson NVARCHAR(MAX) OUTPUT
AS
SELECT @ResultsJson = (
	SELECT [Id], [PlaceType], [Name], [Name2], [Code], [Address], [BirthDateTime], IsActive, [CreatedAt], [CreatedById], [ModifiedAt], [ModifiedById],
			CustodianId, N'Unchanged' As [EntityState]
	FROM [dbo].[Custodies]
	WHERE [Id] IN (SELECT [Id] FROM @Ids)
	FOR JSON PATH
);