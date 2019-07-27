CREATE PROCEDURE [dbo].[dal_Documents__Select]
	@Ids [dbo].[IdList] READONLY,
	@ResultJson NVARCHAR(MAX) OUTPUT
AS
	SELECT @ResultJson = (
		SELECT
			*, N'Unchanged' As [EntityState],
			(SELECT *, N'Unchanged' As [EntityState] FROM dbo.[DocumentLineEntries] E WHERE E.[DocumentLineId] = D.Id FOR JSON PATH) Entries,
			(SELECT *, N'Unchanged' As [EntityState] FROM dbo.[DocumentLines] L WHERE L.DocumentId = D.Id FOR JSON PATH) Lines
		FROM [dbo].[Documents] D
		WHERE D.[Id] IN (SELECT [Id] FROM @Ids)
		FOR JSON PATH 
	);