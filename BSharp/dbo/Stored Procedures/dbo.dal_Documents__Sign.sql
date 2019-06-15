CREATE PROCEDURE [dbo].[dal_Documents__Sign]
	@Entities [dbo].[IndexedIdList] READONLY
AS
BEGIN
	DECLARE @Now DATETIMEOFFSET(7) = SYSDATETIMEOFFSET();
	DECLARE @UserId INT = CONVERT(INT, SESSION_CONTEXT(N'UserId'));
	-- TODO: The logic below should apply only to signatures defined as required.
	-- if last signed by same user, simply update the time
	UPDATE dbo.Signatures
	SET [SignedAt] = @Now
	WHERE [Id] IN (
		SELECT Max(Id) FROM dbo.Signatures
		WHERE DocumentId IN (SELECT [Id] FROM @Entities)
	)
	AND [SignedById] = @UserId;

	-- if last signed by someone else, add user signature
	INSERT INTO dbo.Signatures([DocumentId])
	SELECT [DocumentId]
	FROM Signatures
	WHERE [Id] IN (
		SELECT MAX(Id) As [Id] FROM dbo.Signatures
		WHERE DocumentId IN (SELECT [Id] FROM @Entities)
		GROUP BY DocumentId
	)
	AND [SignedById] <> @UserId
	
	-- if never signed, add user signature
	INSERT INTO dbo.Signatures([DocumentId])
	SELECT [Id]
	FROM @Entities
	WHERE [Id] NOT IN (
		SELECT [DocumentId] FROM dbo.Signatures 
		WHERE [UnsignedAt] IS NOT NULL
	)

	-- TODO: We need to sign the lines involving the resource transfer as well
END;