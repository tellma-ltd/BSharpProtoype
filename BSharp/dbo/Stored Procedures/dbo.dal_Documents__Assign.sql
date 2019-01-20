CREATE PROCEDURE [dbo].[dal_Documents__Assign]
	@Documents [dbo].[IndexedIdList] READONLY,
	@AssigneeId nvarchar(450)
AS
BEGIN
	DECLARE @Now DATETIMEOFFSET(7) = SYSDATETIMEOFFSET();
	DECLARE @UserId NVARCHAR(450) = CONVERT(NVARCHAR(450), SESSION_CONTEXT(N'UserId'));

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