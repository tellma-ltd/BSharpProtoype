CREATE PROCEDURE [dbo].[dal_Resources__Select]
	@Ids [dbo].[IntegerList] READONLY,
	@ResultsJson NVARCHAR(MAX) OUTPUT
AS
SELECT @ResultsJson = (
	SELECT
		*, N'Unchanged' As [EntityState]
	FROM [dbo].[Resources]
	WHERE [Id] IN (SELECT [Id] FROM @Ids)
	FOR JSON PATH
);