CREATE PROCEDURE [dbo].[dal_Documents_Mode__Update]
	@Documents [dbo].[IndexedIdList] READONLY,
	@Mode nvarchar(255)
AS
BEGIN
	DECLARE @Now DATETIMEOFFSET(7) = SYSDATETIMEOFFSET();
	DECLARE @UserId NVARCHAR(450) = CONVERT(NVARCHAR(450), SESSION_CONTEXT(N'UserId'));

	UPDATE dbo.Documents
	SET
		[Mode] = @Mode,
		ModifiedAt = @Now,
		ModifiedBy = @UserId
	WHERE [Id] IN (
		SELECT [Id] FROM @Documents
	)
	AND [Mode] <> @Mode;
END;