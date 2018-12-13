CREATE PROCEDURE [dbo].[dal_Settings__Save]
	@Settings [SettingForSaveList] READONLY
AS
SET NOCOUNT ON;
	DECLARE @IndexedIds [dbo].[IndexedIdList];
	DECLARE @TenantId int = CONVERT(INT, SESSION_CONTEXT(N'TenantId'));
	DECLARE @Now DATETIMEOFFSET(7) = SYSDATETIMEOFFSET();
	DECLARE @UserId NVARCHAR(450) = CONVERT(NVARCHAR(450), SESSION_CONTEXT(N'UserId'));

-- Deletions
	DELETE FROM [dbo].Settings
	WHERE [Field] IN (SELECT [Field] FROM @Settings WHERE [EntityState] = N'Deleted');

-- Inserts and Updates
	MERGE INTO [dbo].Settings AS t
	USING (
		SELECT [Field], [Value]
		FROM @Settings 
		WHERE [EntityState] IN (N'Inserted', N'Updated')
	) AS s ON (t.[Field] = s.[Field])
	WHEN MATCHED 
	THEN
		UPDATE SET 
			t.[Value]		= s.[Value],
			t.[ModifiedAt]	= @Now,
			t.[ModifiedBy]	= @UserId
	WHEN NOT MATCHED THEN
		INSERT ([TenantId], [Field], [Value], [CreatedAt], [CreatedBy], [ModifiedAt], [ModifiedBy])
		VALUES (@TenantId, s.[Field], s.[Value], @Now, @UserId, @Now, @UserId);

