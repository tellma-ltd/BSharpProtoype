EXEC sp_set_session_context 'Tenantid', 106;
DECLARE @TenantId int = CONVERT(INT, SESSION_CONTEXT(N'TenantId'));
:r .\01_MeasurementUnits.sql -- WRONG. To provision, use the code in Testing instead
:r .\02_Accounts.sql
:r .\03_Notes.sql
EXEC [dbo].[adm_Accounts_Notes__Update];
:r .\04_AccountsNotes.sql
:r .\05_DocumentTypes.sql
:r .\06_LineTypeSpecifications.sql
:r .\07_AccountSpecifications.sql