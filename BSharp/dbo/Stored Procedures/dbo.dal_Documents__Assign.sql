CREATE PROCEDURE [dbo].[dal_Documents__Assign]
	@Documents [dbo].[IndexedIdList] READONLY,
	@AssigneeId INT
AS
BEGIN
	DECLARE @Now DATETIMEOFFSET(7) = SYSDATETIMEOFFSET();
	DECLARE @UserId INT = CONVERT(INT, SESSION_CONTEXT(N'UserId'));

	UPDATE dbo.Documents
	SET
		[AssigneeId] = @AssigneeId,
		ModifiedAt = @Now,
		ModifiedBy = @UserId
	WHERE [Id] IN (
		SELECT [Id] FROM @Documents
	)
	AND [AssigneeId] <> @AssigneeId;
END;