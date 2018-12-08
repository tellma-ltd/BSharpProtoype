CREATE PROCEDURE [dbo].[dal_Settings__Select]
	@FieldListJson  NVARCHAR(MAX),
	@SettingsResultJson  NVARCHAR(MAX) OUTPUT
AS
SELECT @SettingsResultJson =	(
		SELECT
			[Field], [Value], [CreatedAt], [CreatedBy], [ModifiedAt], [ModifiedBy], N'Unchanged' As [EntityState]
		FROM dbo.Settings 
		WHERE [Field] IN (
			SELECT [Field]
			FROM OpenJson(@FieldListJson)
			WITH ([Field] NVARCHAR(255) '$.Field')
		)
		FOR JSON PATH
	);