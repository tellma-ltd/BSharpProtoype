CREATE PROCEDURE [dbo].[dal_Documents_State__Update]
	@Documents [dbo].[IndexedIdList] READONLY,
	@State NVARCHAR (255)
AS
BEGIN
	DECLARE @Now DATETIMEOFFSET(7) = SYSDATETIMEOFFSET();
	DECLARE @UserId INT = CONVERT(INT, SESSION_CONTEXT(N'UserId'));

	UPDATE dbo.Documents
	SET
		[DocumentState] = @State,
		ModifiedAt = @Now,
		ModifiedById = @UserId
	WHERE [Id] IN (
		SELECT [Id] FROM @Documents
	)
	AND [DocumentState] <> @State;
END;