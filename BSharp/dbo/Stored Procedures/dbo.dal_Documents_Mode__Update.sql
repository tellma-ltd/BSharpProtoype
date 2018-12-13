CREATE PROCEDURE [dbo].[dal_Documents_Mode__Update]
	@Documents [dbo].IndexedIdList READONLY,
	@Mode nvarchar(255)
AS
BEGIN
	DECLARE @DocumentsIndexedIds [dbo].[IndexedIdList], @LinesIndexedIds [dbo].[IndexedIdList];
	DECLARE @TenantId int = CONVERT(INT, SESSION_CONTEXT(N'TenantId'));
	DECLARE @Now DATETIMEOFFSET(7) = SYSDATETIMEOFFSET();
	DECLARE @UserId NVARCHAR(450) = CONVERT(NVARCHAR(450), SESSION_CONTEXT(N'UserId'));

	UPDATE dbo.Documents
	SET
		[Mode] = @Mode
	WHERE [Id] IN (
		SELECT [Id] FROM @Documents
	)
	AND [Mode] <> @Mode;
END;