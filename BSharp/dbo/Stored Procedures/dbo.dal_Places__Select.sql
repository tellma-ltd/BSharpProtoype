CREATE PROCEDURE [dbo].[dal_Places__Select]
	@Ids [dbo].[IntegerList] READONLY,
	@ResultsJson NVARCHAR(MAX) OUTPUT
AS
SELECT @ResultsJson = (
	SELECT [Id], [PlaceType], [Name], [Code], [Address], [BirthDateTime], IsActive, [CreatedAt], [CreatedBy], [ModifiedAt], [ModifiedBy],
			CustodianId, N'Unchanged' As [EntityState]
	FROM [dbo].[Custodies]
	WHERE [Id] IN (SELECT [Id] FROM @Ids)
	FOR JSON PATH
);