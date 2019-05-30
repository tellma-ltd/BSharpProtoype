CREATE PROCEDURE [dbo].[bll_Documents_Validate__Sign]
	@Documents [dbo].[IndexedIdList] READONLY,
	@ValidationErrorsJson NVARCHAR(MAX) OUTPUT
AS
SET NOCOUNT ON;
	DECLARE @ValidationErrors [dbo].[ValidationErrorList];
	DECLARE @Now DATETIMEOFFSET(7) = SYSDATETIMEOFFSET();

	-- Signing can be at any time
	-- We simply record the signature if
	-- It belongs to an agent
	-- It is required as per policy