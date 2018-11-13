CREATE PROCEDURE [dbo].[api_Settings__Save]
	@Settings [SettingList] READONLY
AS
BEGIN
	BEGIN TRY
		DECLARE @TenantId int;
		SELECT @TenantId = dbo.fn_TenantId();
		IF @TenantId IS NULL
			BEGIN
				DECLARE @msg nvarchar(2048) = FORMATMESSAGE(50001);
				THROW 50001, @msg, 1;
			END
		BEGIN TRANSACTION
			DELETE FROM dbo.Settings WHERE [TenantId] = @TenantId AND [Field] IN (SELECT [Field] FROM @Settings WHERE Status = N'Deleted');

			MERGE INTO dbo.Settings AS t
			USING (
				SELECT @TenantId As [TenantId], [Field], [Value]
				FROM @Settings 
				WHERE [Status] IN (N'Inserted', N'Updated')
			) AS s ON t.[TenantId] = s.[TenantId] AND t.[Field] = s.[Field]
			WHEN MATCHED AND t.[Value] <> s.[Value] THEN
				UPDATE SET 
					t.[Value] = s.[Value]
			WHEN NOT MATCHED THEN
				INSERT ([TenantId], [Field], [Value])
				VALUES (@TenantId, s.[Field], s.[Value]);
		COMMIT TRANSACTION;
	END TRY

	BEGIN CATCH
		EXEC dbo.Error__Log;
		THROW;
	END CATCH

	SELECT S.[Field], S.[Value], N'Unchanged' As [Status]
	FROM dbo.Settings S
	WHERE S.[TenantId] = @TenantId
	AND S.[Field] IN (
		SELECT [Field] FROM @Settings WHERE [Status] IN (N'Inserted', N'Updated')
		);
END