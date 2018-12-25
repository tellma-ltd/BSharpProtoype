CREATE PROCEDURE [dbo].[dal_Documents_WideLines__Select]
	@IndexedIds [dbo].[IndexedIdList] READONLY,
	@DocumentsResultJson NVARCHAR(MAX) OUTPUT,
	@WideLinesResultJson NVARCHAR(MAX) OUTPUT
AS
SET NOCOUNT ON;

	SELECT @DocumentsResultJson =	(
		SELECT T.[Index], D.[Id], D.[State], D.[TransactionType], D.[Mode], D.[SerialNumber], 
		D.[ResponsibleAgentId], D.[ForwardedToAgentId], 
		D.[FolderId], D.[LinesMemo], D.[StartDateTime], D.[EndDateTime], 
		D.[LinesCustody1], D.[LinesCustody2], D.[LinesCustody3],
		D.[CreatedAt], D.[CreatedBy], D.[ModifiedAt], D.[ModifiedBy], N'Unchanged' As [EntityState]
		FROM [dbo].[Documents] D 
		JOIN @IndexedIds T ON D.Id = T.Id
		FOR JSON PATH
	);

	SELECT @WideLinesResultJson = (
		SELECT *, N'Unchanged' As [EntityState]
		FROM [dbo].WideLinesView
		WHERE [DocumentId] IN (SELECT [Id] FROM @IndexedIds)
		FOR JSON PATH
	);