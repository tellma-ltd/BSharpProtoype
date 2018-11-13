
CREATE FUNCTION [dbo].[ft_ValidationErrors](@ValidationErrors ValidationErrorList READONLY)
-- ALTER FUNCTION [dbo].[ft_ValidationErrors](@ValidationErrors ValidationErrorList READONLY)
RETURNS nvarchar(max)
AS BEGIN
	DECLARE @Result nvarchar(max);

	SELECT @Result = N'{' +
					ISNULL(N'[Documents][' + CAST(DocumentId AS nvarchar(10)) + ']', '') + 
					ISNULL(N'.[Lines][' + CAST([LineId] AS nvarchar(10)) + ']', '') + 
					ISNULL(N'.[Entries][' + CAST([EntryId] AS nvarchar(10)) + ']', '') +
					ISNULL(N'.' + PropertyName, '') +
					N':[{Message_Lang1:' + Message1 + N', Message_Lang2:' + Message2 + N'}]' +
					N'}'					   
	FROM @ValidationErrors

	RETURN @Result
END
