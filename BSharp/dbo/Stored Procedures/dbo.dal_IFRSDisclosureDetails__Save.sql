CREATE PROCEDURE [dbo].[dal_IFRSDisclosureDetails__Save]
	@Entities [IFRSDisclosureDetailList] READONLY,
	@IndexedIdsJson NVARCHAR(MAX) OUTPUT
AS
SET NOCOUNT ON;
	DECLARE @IndexedIds [dbo].[IndexedIdList];
	DECLARE @Now DATETIMEOFFSET(7) = SYSDATETIMEOFFSET();
	DECLARE @UserId INT = CONVERT(INT, SESSION_CONTEXT(N'UserId'));

-- Deletions
	DELETE FROM [dbo].[IFRSDisclosureDetails]
	WHERE [Id] IN (SELECT [Id] FROM @Entities WHERE [EntityState] = N'Deleted');

	INSERT INTO @IndexedIds([Index], [Id])
	SELECT x.[Index], x.[Id]
	FROM
	(
		MERGE INTO [dbo].[IFRSDisclosureDetails] AS t
		USING (
			SELECT [Index], [Id], [IFRSDisclosureId], [Value], [ValidSince]
			FROM @Entities 
			WHERE [EntityState] IN (N'Inserted', N'Updated')
		) AS s ON (t.[Id] = s.[Id])
		WHEN MATCHED 
		THEN
			UPDATE SET 
				t.[Value]			= s.[Value],
				t.[ValidSince]		= s.[ValidSince],
				t.[ModifiedAt]		= @Now,
				t.[ModifiedById]	= @UserId
		WHEN NOT MATCHED THEN
			INSERT ([IFRSDisclosureId], [Value], [ValidSince])
			VALUES (s.[IFRSDisclosureId], s.[Value], s.[ValidSince])
		OUTPUT s.[Index], inserted.[Id] 
	) As x

	SELECT @IndexedIdsJson = (SELECT * FROM @IndexedIds FOR JSON PATH);