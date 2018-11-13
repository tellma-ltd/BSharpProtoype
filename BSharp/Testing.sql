SET NOCOUNT ON;

--SET LANGUAGE us_english; 
SET LANGUAGE French;
--SET LANGUAGE Arabic; 
BEGIN TRY
	BEGIN TRANSACTION
		EXEC sp_addmessage @msgnum = 50001, @severity = 16, @msgtext = 'Tenant Id is NULL', @lang = 'us_english';
		EXEC sp_addmessage @msgnum = 50001, @severity = 16, @msgtext = 'On ne peut pas determiner le Id de client', @lang = 'French';
		EXEC sp_addmessage @msgnum = 50001, @severity = 16, @msgtext = 'تعذر تحديد رقم الاشتراك', @lang = 'Arabic';

		EXEC sp_set_session_context 'Tenantid', NULL;
		:r .\TestingSettings.sql
		:r .\TestingCustodies.sql
		:r .\TestingOperations.sql
		:r .\TestingResources.sql
		:r .\TestingManualJV.sql
	ROLLBACK;
END TRY
BEGIN CATCH
	SELECT * FROM dbo.Errors;
	ROLLBACK;
	THROW;
END CATCH