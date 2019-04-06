CREATE PROCEDURE [dbo].[dal_Documents__Unsign]
	@Documents [dbo].[IndexedIdList] READONLY
AS
BEGIN
	DECLARE @TenantId int = CONVERT(INT, SESSION_CONTEXT(N'TenantId'));
	DECLARE @Now DATETIMEOFFSET(7) = SYSDATETIMEOFFSET();
	DECLARE @UserId INT = CONVERT(INT, SESSION_CONTEXT(N'UserId'));

	-- if last signed by same user, hard delete the signature
	DELETE FROM dbo.Signatures
	WHERE [Id] IN (
		SELECT Max(Id) FROM dbo.Signatures
		WHERE DocumentId IN (SELECT [Id] FROM @Documents)
	)
	AND [SignatoryId] = @UserId;

	-- else, soft delete the signature
	UPDATE dbo.Signatures
	SET [UnsignedAt] = @Now
	WHERE [SignatoryId] = @UserId;
END;