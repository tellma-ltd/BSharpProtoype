CREATE PROCEDURE [dbo].[dal_Documents_Lines__Select]
	@IndexedIds [dbo].IndexedIdList READONLY,
	@DocumentsResultJson NVARCHAR(MAX) OUTPUT,
	@LinesResultJson NVARCHAR(MAX) OUTPUT,
	@EntriesResultJson NVARCHAR(MAX) OUTPUT
AS
	SELECT @DocumentsResultJson =	(
		SELECT T.[Index], D.[Id], D.[State], D.[TransactionType], D.[Mode], D.[SerialNumber], 
		D.[ResponsibleAgentId], D.[ForwardedToAgentId], 
		D.[FolderId], D.[LinesMemo], D.[LinesStartDateTime], D.[LinesEndDateTime], 
		D.[LinesCustody1], D.[LinesCustody2], D.[LinesCustody3],
		D.[CreatedAt], D.[CreatedBy], D.[ModifiedAt], D.[ModifiedBy], N'Unchanged' As [EntityState]
		FROM [dbo].[Documents] D 
		JOIN @IndexedIds T ON D.Id = T.Id
		FOR JSON PATH
	);

	SELECT @LinesResultJson = (
		SELECT *, N'Unchanged' As [EntityState]
		FROM [dbo].Lines
		WHERE [DocumentId] IN (
			SELECT [Id]
			FROM @IndexedIds
		)
		FOR JSON PATH
	);

	SELECT @EntriesResultJson = (
		SELECT *, N'Unchanged' As [EntityState]
		FROM [dbo].Entries
		WHERE [LineId] IN (
			SELECT [Id]
			FROM [dbo].Lines
			WHERE [DocumentId] IN (
				SELECT [Id] 
				FROM @IndexedIds
			)
		)
		FOR JSON PATH
	);