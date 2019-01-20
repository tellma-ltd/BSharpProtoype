﻿CREATE PROCEDURE [dbo].[dal_Settings__Select]
	@FieldList dbo.StringList READONLY,
	@ResultsJson NVARCHAR(MAX) OUTPUT
AS
SELECT @ResultsJson = (
		SELECT *, N'Unchanged' As [EntityState]
		FROM [dbo].Settings 
		WHERE [Field] IN (
			SELECT [Field]
			FROM @FieldList
		)
		FOR JSON PATH
	);