CREATE PROCEDURE [dbo].[dal_Agents__Save]
	@Entities [AgentList] READONLY,
	@IndexedIdsJson NVARCHAR(MAX) OUTPUT
AS
SET NOCOUNT ON;
	DECLARE @IndexedIds [dbo].[IndexedIdList];
	DECLARE @Now DATETIMEOFFSET(7) = SYSDATETIMEOFFSET();
	DECLARE @UserId INT = CONVERT(INT, SESSION_CONTEXT(N'UserId'));

-- Deletions
	DELETE FROM [dbo].[Agents]
	WHERE [Id] IN (SELECT [Id] FROM @Entities WHERE [EntityState] = N'Deleted');

	INSERT INTO @IndexedIds([Index], [Id])
	SELECT x.[Index], x.[Id]
	FROM
	(
		MERGE INTO [dbo].[Agents] AS t
		USING (
			SELECT [Index], [Id], [Name], [Name2], [Name3], [Code], [SystemCode], [PersonType], [IsRelated], [TaxIdentificationNumber],
				[IsLocal], [Citizenship], [Facebook], [Instagram], [Twitter],
				[PreferredContactChannel1], [PreferredContactAddress1], [PreferredContactChannel2], [PreferredContactAddress2],
				[BirthDateTime], [MaritalStatus], [Religion], [Race], [Gender], [TribeId], [RegionId], [ResidentialAddress], [TitleId],
				[JobTitle], [EmployeeSince], [EducationLevelId], [EducationSublevelId], [BankId], [BankAccountNumber], [NumberOfChildren]

			FROM @Entities 
			WHERE [EntityState] IN (N'Inserted', N'Updated')
		) AS s ON (t.Id = s.Id)
		WHEN MATCHED
		THEN
			UPDATE SET 
				t.[Name]					= s.[Name],
				t.[Name2]					= s.[Name2],
				t.[Name3]					= s.[Name3],
				t.[Code]					= s.[Code],
				t.[PersonType]				= s.[PersonType], 

				t.[IsRelated]				= s.[IsRelated],
				t.[TaxIdentificationNumber] = s.[TaxIdentificationNumber],
				t.[IsLocal]					= s.[IsLocal],
				t.[Citizenship]				= s.[Citizenship],
				t.[Facebook]				= s.[Facebook],
				t.[Instagram]				= s.[Instagram],
				t.[Twitter]					= s.[Twitter],
				t.[PreferredContactChannel1] = s.[PreferredContactChannel1],
				t.[PreferredContactAddress1] = s.[PreferredContactAddress1],
				t.[PreferredContactChannel2] = s.[PreferredContactChannel2],
				t.[PreferredContactAddress2] = s.[PreferredContactAddress2],

				t.[BirthDateTime]			= s.[BirthDateTime],
				t.[MaritalStatus]			= s.[MaritalStatus],
				t.[Religion]				= s.[Religion],
				t.[Race]					= s.[Race],
				t.[Gender]					= s.[Gender],
				t.[TribeId]					= s.[TribeId],
				t.[RegionId]				= s.[RegionId],
				t.[ResidentialAddress]		= s.[ResidentialAddress],
				t.[TitleId]					= s.[TitleId],

				t.[EducationLevelId]		= s.[EducationLevelId],
				t.[EducationSublevelId]		= s.[EducationSublevelId],
				t.[BankId]					= s.[BankId],
				t.[BankAccountNumber]		= s.[BankAccountNumber],
				t.[NumberOfChildren]		= s.[NumberOfChildren],

				t.[ModifiedAt]				= @Now,
				t.[ModifiedById]			= @UserId
		WHEN NOT MATCHED THEN
			INSERT ([PersonType], 
				[Name], [Name2], [Name3], [Code], [SystemCode], [IsRelated], [TaxIdentificationNumber],
				[IsLocal], [Citizenship], [Facebook], [Instagram], [Twitter],
				[PreferredContactChannel1], [PreferredContactAddress1], [PreferredContactChannel2], [PreferredContactAddress2],
				[BirthDateTime], [MaritalStatus], [Religion], [Race], [Gender], [TribeId], [RegionId], [ResidentialAddress], [TitleId],
				[EducationLevelId], [EducationSublevelId], [BankId], [BankAccountNumber], [NumberOfChildren])
			VALUES (s.[PersonType],
				s.[Name], s.[Name2], s.[Name3], s.[Code], s.[SystemCode], s.[IsRelated], s.[TaxIdentificationNumber],
				s.[IsLocal], s.[Citizenship], s.[Facebook], s.[Instagram], s.[Twitter],
				s.[PreferredContactChannel1], s.[PreferredContactAddress1], s.[PreferredContactChannel2], s.[PreferredContactAddress2],
				s.[BirthDateTime], s.[MaritalStatus], s.[Religion], s.[Race], s.[Gender], s.[TribeId], s.[RegionId], s.[ResidentialAddress], s.[TitleId],
				s.[EducationLevelId], s.[EducationSublevelId], s.[BankId], s.[BankAccountNumber], s.[NumberOfChildren])
		OUTPUT s.[Index], inserted.[Id] 
	) AS x;
	SELECT @IndexedIdsJson = (SELECT * FROM @IndexedIds	FOR JSON PATH);