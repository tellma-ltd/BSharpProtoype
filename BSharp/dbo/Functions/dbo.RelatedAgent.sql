
CREATE FUNCTION [dbo].[RelatedAgent](@EntryNumber tinyint, @Entries EntryList READONLY)
RETURNS int
AS
BEGIN
	DECLARE @Result int

	SELECT @Result = RelatedAgentId
	FROM @Entries
	WHERE EntryNumber = @EntryNumber

	RETURN @Result

END
