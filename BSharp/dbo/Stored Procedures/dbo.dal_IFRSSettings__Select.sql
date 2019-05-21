CREATE PROCEDURE [dbo].[dal_IFRSSettings__Select]
	@FieldList dbo.StringList READONLY,
	@ResultsJson NVARCHAR(MAX) OUTPUT
AS
SELECT @ResultsJson = (
		SELECT *, N'Unchanged' As [EntityState]
		FROM [dbo].IFRSSettings 
		WHERE [Field] IN (
			SELECT [Field]
			FROM @FieldList
		)
		FOR JSON PATH
	);