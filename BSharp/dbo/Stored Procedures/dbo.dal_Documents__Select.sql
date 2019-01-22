CREATE PROCEDURE [dbo].[dal_Documents__Select]
	@Ids [dbo].[IntegerList] READONLY,
	@DocumentsResultJson NVARCHAR(MAX) OUTPUT,
--	@LinesResultJson NVARCHAR(MAX) OUTPUT,
	@EntriesResultJson NVARCHAR(MAX) OUTPUT
	-- We need to return the WideLines and the DocumentLineTypes as well.
	-- We need to return the lines only for the Manual JV line case
AS
	SELECT @DocumentsResultJson = (
		SELECT *, N'Unchanged' As [EntityState]
		FROM [dbo].[Documents]
		WHERE [Id] IN (SELECT [Id] FROM @Ids)
		FOR JSON PATH
	);

	--SELECT @LinesResultJson = (
	--	SELECT *, N'Unchanged' As [EntityState]
	--	FROM [dbo].Lines
	--	WHERE [DocumentId] IN (SELECT [Id] FROM @Ids)
	--	FOR JSON PATH
	--);

	SELECT @EntriesResultJson = (
		SELECT *, N'Unchanged' As [EntityState]
		FROM [dbo].[Entries]
		WHERE [DocumentId] IN (SELECT [Id] FROM @Ids)
		FOR JSON PATH
	);