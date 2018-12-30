CREATE FUNCTION [dbo].[fr_Agents__Json]
(
	@Json NVARCHAR(MAX)
)
RETURNS TABLE
AS
	RETURN
	SELECT *
	FROM OpenJson(@Json)
	WITH (
		[Id] INT '$.Id',
		[AgentType] NVARCHAR (255) '$.AgentType',
		[Name] NVARCHAR (255) '$.Name',
		[IsActive] BIT '$.IsActive',
		[Code] NVARCHAR (255) '$.Code',
		[Address] NVARCHAR (255) '$.Address',
		[BirthDateTime] DATETIMEOFFSET (7) '$.BirthDateTime',
		[CreatedAt] DATETIMEOFFSET(7) '$.CreatedAt',
		[CreatedBy] NVARCHAR(450) '$.CreatedBy',
		[ModifiedAt] DATETIMEOFFSET(7) '$.ModifiedAt',
		[ModifiedBy] NVARCHAR(450) '$.ModifiedBy',
		[IsRelated] BIT '$.IsRelated', 
		[UserId] NVARCHAR (450) '$.UserId', 
		[TaxIdentificationNumber] NVARCHAR (255) '$.TaxIdentificationNumber',
		[Title] NVARCHAR (255) '$.Title',
		[Gender] NCHAR (1) '$.Gender',
		[EntityState] NVARCHAR(255) '$.EntityState'
	);