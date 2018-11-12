CREATE PROCEDURE [dbo].[api_Settings__Save]
	@Settings [SettingList] READONLY
AS
BEGIN
	DECLARE @TenantId int;
	BEGIN TRANSACTION
		BEGIN TRY
			SELECT @TenantId = dbo.fn_TenantId();
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
			--WHEN NOT MATCHED BY SOURCE THEN 
			--	DELETE
		END TRY

		BEGIN CATCH
			SELECT   /*
			ERROR_NUMBER() AS ErrorNumber  
			,ERROR_SEVERITY() AS ErrorSeverity  
			,ERROR_STATE() AS ErrorState  
			, */ERROR_PROCEDURE() AS ErrorProcedure  
			,ERROR_LINE() AS ErrorLine  
			,ERROR_MESSAGE() AS ErrorMessage; 

			IF @@TRANCOUNT > 0 
			ROLLBACK TRANSACTION;
		END CATCH

	IF @@TRANCOUNT > 0  
    COMMIT TRANSACTION;
	
	SELECT S.[Field], S.[Value], N'Unchanged' As [Status]
	FROM dbo.Settings S
	WHERE S.[TenantId] = @TenantId
	AND S.[Field] IN (
		SELECT [Field] FROM @Settings WHERE [Status] IN (N'Inserted', N'Updated')
		);
END