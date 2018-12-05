CREATE PROCEDURE [dbo].[api_Settings__Save]
	@Settings [SettingList] READONLY
AS
BEGIN
	DECLARE @TenantId int, @msg nvarchar(2048);
	SELECT @TenantId = [dbo].fn_TenantId();
	IF @TenantId IS NULL
	BEGIN
		SELECT @msg = FORMATMESSAGE([dbo].fn_Translate('NullTenantId')); 
		THROW 50001, @msg, 1;
	END

	DELETE FROM [dbo].Settings WHERE [TenantId] = @TenantId AND [Field] IN (SELECT [Field] FROM @Settings WHERE [EntityState] = N'Deleted');

	MERGE INTO [dbo].Settings AS t
	USING (
		SELECT @TenantId As [TenantId], [Field], [Value]
		FROM @Settings 
		WHERE [EntityState] IN (N'Inserted', N'Updated')
	) AS s ON t.[TenantId] = s.[TenantId] AND t.[Field] = s.[Field]
	WHEN MATCHED AND t.[Value] <> s.[Value] THEN
		UPDATE SET 
			t.[Value] = s.[Value]
	WHEN NOT MATCHED THEN
		INSERT ([TenantId], [Field], [Value])
		VALUES (@TenantId, s.[Field], s.[Value]);

	SELECT S.[Field], S.[Value], N'Unchanged' As [EntityState]
	FROM [dbo].Settings S
	WHERE S.[TenantId] = @TenantId
	AND S.[Field] IN (
		SELECT [Field] FROM @Settings WHERE [EntityState] IN (N'Inserted', N'Updated')
		);
END