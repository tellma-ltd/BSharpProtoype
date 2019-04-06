CREATE FUNCTION [dbo].[fi_Document__Signatures] (
	@DocumentId INT
)
RETURNS TABLE
AS
RETURN
	SELECT	[SignatoryId], [SignedAt], [UnsignedAt]
	FROM [dbo].Signatures
	WHERE DocumentId = @DocumentId;