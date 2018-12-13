CREATE PROCEDURE [dbo].[dal_Settings__Select]
	@FieldList dbo.StringList READONLY,
	@SettingsResultJson NVARCHAR(MAX) OUTPUT
AS
SELECT @SettingsResultJson = (
		SELECT
			[Field], [Value], [CreatedAt], [CreatedBy], [ModifiedAt], [ModifiedBy], N'Unchanged' As [EntityState]
		FROM [dbo].Settings 
		WHERE [Field] IN (
			SELECT [Field]
			FROM @FieldList
		)
		FOR JSON PATH
	);