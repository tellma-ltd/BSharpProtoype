CREATE PROCEDURE [dbo].[dal_Documents_Mode__Update]
	@Documents [dbo].[IndexedIdList] READONLY,
	@Mode nvarchar(255)
AS
BEGIN
	DECLARE @Now DATETIMEOFFSET(7) = SYSDATETIMEOFFSET();
	DECLARE @UserId INT = CONVERT(INT, SESSION_CONTEXT(N'UserId'));

	UPDATE dbo.Documents
	SET
		[Mode] = @Mode,
		[AssigneeId] = CASE WHEN @Mode = N'Draft' THEN @UserId ELSE NULL END,
		ModifiedAt = @Now,
		ModifiedBy = @UserId
	WHERE [Id] IN (
		SELECT [Id] FROM @Documents
	)
	AND [Mode] <> @Mode;
END;