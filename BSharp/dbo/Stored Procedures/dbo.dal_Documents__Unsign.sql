CREATE PROCEDURE [dbo].[dal_Documents__Unsign]
	@Documents [dbo].[IndexedIdList] READONLY
AS
BEGIN
	DECLARE @TenantId int = CONVERT(INT, SESSION_CONTEXT(N'TenantId'));
	DECLARE @Now DATETIMEOFFSET(7) = SYSDATETIMEOFFSET();
	DECLARE @UserId INT = CONVERT(INT, SESSION_CONTEXT(N'UserId'));

	-- if last signed by same user, hard delete the signature
	DELETE FROM dbo.[DocumentSignatures]
	WHERE [Id] IN (
		SELECT Max(Id) FROM dbo.[DocumentSignatures]
		WHERE DocumentId IN (SELECT [Id] FROM @Documents)
	)
	AND [ActorId] = @UserId;

	-- else, soft delete the signature
	UPDATE dbo.[DocumentSignatures]
	SET [RevokedAt] = @Now
	WHERE [ActorId] = @UserId;
END;