DECLARE @Now DATETIMEOFFSET(7) = SYSDATETIMEOFFSET();
DECLARE @UserId UNIQUEIDENTIFIER = NEWID();
IF NOT EXISTS(SELECT * FROM [dbo].[LocalUsers] WHERE [Name] = N'Dr. Akra')
BEGIN
	INSERT INTO [dbo].[LocalUsers](Id, [Name], [AgentId]) VALUES
	(@UserId, N'Dr. Akra', NULL); -- N'DESKTOP-V0VNDC4\Mohamad Akra'
END
ELSE
SELECT @UserId = [Id] FROM dbo.LocalUsers WHERE [Name] = N'Dr. Akra';
EXEC sp_set_session_context 'UserId', @UserId;
SET @UserId = CONVERT(UNIQUEIDENTIFIER, SESSION_CONTEXT(N'UserId'));

:r .\01_IfrsConcepts.sql
:r .\011_IfrsDisclosures.sql
:r .\012_IfrsNotes.sql
--:r .\08_MeasurementUnits.sql -- WRONG. To provision, use the code in Testing instead
--:r .\02_Accounts.sql
--EXEC [dbo].[adm_Accounts_Notes__Update];
--:r .\04_AccountsNotes.sql
--:r .\05_DocumentTypes.sql
--:r .\05_LineTypeSpecifications.sql
--:r .\07_AccountSpecifications.sql