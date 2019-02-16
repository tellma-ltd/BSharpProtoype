CREATE PROCEDURE [dbo].[dal_Places__Select]
	@Ids [dbo].[IntegerList] READONLY,
	@ResultsJson NVARCHAR(MAX) OUTPUT
AS
SELECT @ResultsJson = (
	SELECT [Id], [Name], [Name2], [Code], [BirthDateTime], IsActive, [CreatedAt], [CreatedById], [ModifiedAt], [ModifiedById],
			CustodianId, N'Unchanged' As [EntityState]
	FROM [dbo].[Agents]
	WHERE [Id] IN (SELECT [Id] FROM @Ids)
	FOR JSON PATH
);