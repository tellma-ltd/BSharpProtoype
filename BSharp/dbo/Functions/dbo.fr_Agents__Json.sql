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
		[IsActive] BIT '$.IsActive',
		[Name] NVARCHAR (255) '$.Name',
		[Name2] NVARCHAR (255) '$.Name2',
		[Name3] NVARCHAR (255) '$.Name3',
		[Code] NVARCHAR (255) '$.Code',
		[SystemCode] NVARCHAR (255) '$.SystemCode',
		[PersonType] NVARCHAR (255) '$.PersonType',
		[IsRelated] BIT '$.IsRelated',
		[TaxIdentificationNumber] NVARCHAR (255) '$.TaxIdentificationNumber',
		[IsLocal] BIT '$.IsLocal',
		[Citizenship] NCHAR(2) '$.Citizenship',/*
			[Facebook], [Instagram], [Twitter], [PreferredContactChannel1], [PreferredContactAddress1],
			[PreferredContactChannel2], [PreferredContactAddress2],
			[BankId], [BankAccountNumber],
*/
		[BirthDateTime] DATETIMEOFFSET (7) '$.BirthDateTime',
		[TitleId] INT '$.TitleId',
		[Gender] INT '$.Gender',
		[ResidentialAddress] NVARCHAR (1024) '$.ResidentialAddress',
--		[ImageId],
		-- [MaritalStatus], [NumberOfChildren], [Religion], [Race], [TribeId], [RegionId],	[EducationLevelId], [EducationSublevelId],
--	Organizations only
		-- [OrganizationType], [WebSite], [ContactPerson], 
		[RegisteredAddress] NVARCHAR (1024) '$.RegisteredAddress',
		--[OwnershipType], [OwnershipPercent],

		[CreatedAt] DATETIMEOFFSET(7) '$.CreatedAt',
		[CreatedById] INT '$.CreatedById',
		[ModifiedAt] DATETIMEOFFSET(7) '$.ModifiedAt',
		[ModifiedById] INT '$.ModifiedById',
		[EntityState] NVARCHAR (255) '$.EntityState'
	);
