CREATE PROCEDURE [dbo].[dal_Agents__Select]
	@Ids [dbo].[IdList] READONLY,
	@ResultsJson NVARCHAR(MAX) OUTPUT
AS
	SELECT @ResultsJson = (
		SELECT
			-- Common
			[Id], [IsActive], [Name], [Name2], [Name3], [Code], [SystemCode],
			[AgentType], [IsRelated], [TaxIdentificationNumber], [IsLocal], [Citizenship],
			[Facebook], [Instagram], [Twitter], [PreferredContactChannel1], [PreferredContactAddress1],
			[PreferredContactChannel2], [PreferredContactAddress2],
			[BankId], [BankAccountNumber],
			-- Individuals Only
			[BirthDateTime], [TitleId], [Gender], [ResidentialAddress], [ImageId],
			[MaritalStatus], [NumberOfChildren], [Religion], [Race], [TribeId], [RegionId],	[EducationLevelId], [EducationSublevelId],
			--	Organizations only
			[OrganizationType], [WebSite], [ContactPerson], [RegisteredAddress], [OwnershipType], [OwnershipPercent],
			[CreatedAt], [CreatedById], [ModifiedAt], [ModifiedById],
			N'Unchanged' As [EntityState]
		FROM [dbo].[Agents]
		WHERE [Id] IN (SELECT [Id] FROM @Ids)
		FOR JSON PATH
	);