CREATE PROCEDURE [dbo].[dal_IfrsDisclosureDetails__Select]
	@Ids [dbo].[IdList] READONLY,
	@ResultsJson NVARCHAR(MAX) OUTPUT
AS
SELECT @ResultsJson = (
		SELECT *, N'Unchanged' As [EntityState]
		FROM [dbo].[IfrsDisclosureDetails] 
		WHERE [Id] IN (SELECT [Id] FROM @Ids)
	FOR JSON PATH
	);