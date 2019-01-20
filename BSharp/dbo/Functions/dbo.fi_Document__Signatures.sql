CREATE FUNCTION [dbo].[fi_Document__Signatures] (
	@DocumentId INT
)
RETURNS TABLE
AS
RETURN
	SELECT	[Signatory], [SignedAt], [UnsignedAt]
	FROM [dbo].Signatures
	WHERE DocumentId = @DocumentId;