CREATE PROCEDURE [dbo].[dal_Documents__Unsign]
	@Documents [dbo].[IndexedIdList] READONLY
AS
BEGIN
	DECLARE @TenantId int = CONVERT(INT, SESSION_CONTEXT(N'TenantId'));
	DECLARE @Now DATETIMEOFFSET(7) = SYSDATETIMEOFFSET();
	DECLARE @UserId NVARCHAR(450) = CONVERT(NVARCHAR(450), SESSION_CONTEXT(N'UserId'));

	-- if last signed by same user, hard delete the signature
	DELETE FROM dbo.Signatures
	WHERE [Id] IN (
		SELECT Max(Id) FROM dbo.Signatures
		WHERE DocumentId IN (SELECT [Id] FROM @Documents)
	)
	AND [Signatory] = @UserId;

	-- else, soft delete the signature
	UPDATE dbo.Signatures
	SET [UnsignedAt] = @Now
	WHERE [Signatory] = @UserId;
END;