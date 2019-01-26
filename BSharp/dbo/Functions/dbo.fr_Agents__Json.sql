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
		[Name2] NVARCHAR (255) '$.Name2',
		[IsActive] BIT '$.IsActive',
		[Code] NVARCHAR (255) '$.Code',
		[Address] NVARCHAR (1024) '$.Address',
		[BirthDateTime] DATETIMEOFFSET (7) '$.BirthDateTime',
		[CreatedAt] DATETIMEOFFSET(7) '$.CreatedAt',
		[CreatedById] INT '$.CreatedById',
		[ModifiedAt] DATETIMEOFFSET(7) '$.ModifiedAt',
		[ModifiedById] INT '$.ModifiedById',
		[IsRelated] BIT '$.IsRelated', 
		[TaxIdentificationNumber] NVARCHAR (255) '$.TaxIdentificationNumber',
		[Title] NVARCHAR (255) '$.Title',
		[Gender] NCHAR (1) '$.Gender',
		[EntityState] NVARCHAR(255) '$.EntityState'
	);