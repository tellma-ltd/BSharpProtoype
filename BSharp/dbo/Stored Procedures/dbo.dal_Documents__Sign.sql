CREATE PROCEDURE [dbo].[dal_Documents__Sign]
	@Documents [dbo].[IndexedIdList] READONLY
AS
BEGIN
	DECLARE @Now DATETIMEOFFSET(7) = SYSDATETIMEOFFSET();
	DECLARE @UserId INT = CONVERT(INT, SESSION_CONTEXT(N'UserId'));
	-- if last signed by same user, simply update the time
	UPDATE dbo.Signatures
	SET [SignedAt] = @Now
	WHERE [Id] IN (
		SELECT Max(Id) FROM dbo.Signatures
		WHERE DocumentId IN (SELECT [Id] FROM @Documents)
	)
	AND [SignatoryId] = @UserId;

	-- if last signed by someone else, add user signature
	INSERT INTO dbo.Signatures([DocumentId])
	SELECT [DocumentId]
	FROM Signatures
	WHERE [Id] IN (
		SELECT MAX(Id) As [Id] FROM dbo.Signatures
		WHERE DocumentId IN (SELECT [Id] FROM @Documents)
		GROUP BY DocumentId
	)
	AND [SignatoryId] <> @UserId
	
	-- if never signed, add user signature
	INSERT INTO dbo.Signatures([DocumentId])
	SELECT [Id]
	FROM @Documents
	WHERE [Id] NOT IN (
		SELECT [DocumentId] FROM dbo.Signatures 
		WHERE [UnsignedAt] IS NOT NULL
	)
END;