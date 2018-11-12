SET NOCOUNT ON;
BEGIN TRANSACTION
EXEC sp_set_session_context 'Tenantid', 101;
:r .\TestingSettings.sql
:r .\TestingCustodies.sql
:r .\TestingOperations.sql
:r .\TestingResources.sql
--:r .\TestingManualJV.sql
ROLLBACK