CREATE PROCEDURE [dbo].[dal_Documents__Select]
	@Ids [dbo].[IntegerList] READONLY,
	@DocumentsResultJson NVARCHAR(MAX) OUTPUT,
	@LinesResultJson NVARCHAR(MAX) OUTPUT,
	@EntriesResultJson NVARCHAR(MAX) OUTPUT
AS
	SELECT @DocumentsResultJson =	(
		SELECT [Id], [State], [DocumentType], [Frequency], [Duration],  
		[StartDateTime], [EndDateTime], [Mode],	[SerialNumber], 
		--[Memo], [LinesCustody1], [LinesCustody2], [LinesCustody3],
		[CreatedAt], [CreatedBy], [ModifiedAt], [ModifiedBy], N'Unchanged' As [EntityState]
		FROM [dbo].[Documents]
		WHERE [Id] IN (SELECT [Id] FROM @Ids)
		FOR JSON PATH
	);

	SELECT @LinesResultJson = (
		SELECT *, N'Unchanged' As [EntityState]
		FROM [dbo].Lines
		WHERE [DocumentId] IN (
			SELECT [Id]
			FROM @Ids
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
				FROM @Ids
			)
		)
		FOR JSON PATH
	);