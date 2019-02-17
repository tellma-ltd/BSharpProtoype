CREATE PROCEDURE [dbo].[dal_Employees__Save]
	@Entities [EmployeeList] READONLY,
	@IndexedIdsJson NVARCHAR(MAX) OUTPUT
AS
	DECLARE @IndexedIds [dbo].[IndexedIdList];
	DECLARE @TenantId int = CONVERT(INT, SESSION_CONTEXT(N'TenantId'));
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
			SELECT [Index], [Id], [Name], [Name2], [Code], [SystemCode], [IsRelated], [TaxIdentificationNumber],
				[IsLocal], [Citizenship], [Facebook], [Instagram], [Twitter],
				[PreferredContactChannel1], [PreferredContactAddress1], [PreferredContactChannel2], [PreferredContactAddress2],
				[BirthDateTime], [MaritalStatus], [Religion], [Race], [Gender], [TribeId], [RegionId], [ResidentialAddress], [Title],
				[JobTitle], [EmployeeSince], [EducationLevel], [EducationSublevel], [BankId], [BankAccountNumber], [NumberOfChildren]

			FROM @Entities 
			WHERE [EntityState] IN (N'Inserted', N'Updated')
		) AS s ON (t.Id = s.Id)
		WHEN MATCHED
		THEN
			UPDATE SET 
				t.[Name]					= s.[Name],
				t.[Name2]					= s.[Name2],
				t.[Code]					= s.[Code],

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
				t.[Title]					= s.[Title],

				t.[JobTitle]				= s.[JobTitle],
				t.[EmployeeSince]			= s.[EmployeeSince],
				t.[EducationLevel]			= s.[EducationLevel],
				t.[EducationSublevel]		= s.[EducationSublevel],
				t.[BankId]					= s.[BankId],
				t.[BankAccountNumber]		= s.[BankAccountNumber],
				t.[NumberOfChildren]		= s.[NumberOfChildren],

				t.[ModifiedAt]				= @Now,
				t.[ModifiedById]			= @UserId
		WHEN NOT MATCHED THEN
			INSERT ([TenantId], [RelationType], [PersonType], 
				[Name], [Name2], [Code], [SystemCode], [IsRelated], [TaxIdentificationNumber],
				[IsLocal], [Citizenship], [Facebook], [Instagram], [Twitter],
				[PreferredContactChannel1], [PreferredContactAddress1], [PreferredContactChannel2], [PreferredContactAddress2],
				[BirthDateTime], [MaritalStatus], [Religion], [Race], [Gender], [TribeId], [RegionId], [ResidentialAddress], [Title],
				[JobTitle], [EmployeeSince], [EducationLevel], [EducationSublevel], [BankId], [BankAccountNumber], [NumberOfChildren],
				[CreatedAt], [CreatedById], [ModifiedAt], [ModifiedById])
			VALUES (@TenantId, N'employee',	N'Individual', 
				s.[Name], s.[Name2], s.[Code], s.[SystemCode], s.[IsRelated], s.[TaxIdentificationNumber],
				s.[IsLocal], s.[Citizenship], s.[Facebook], s.[Instagram], s.[Twitter],
				s.[PreferredContactChannel1], s.[PreferredContactAddress1], s.[PreferredContactChannel2], s.[PreferredContactAddress2],
				s.[BirthDateTime], s.[MaritalStatus], s.[Religion], s.[Race], s.[Gender], s.[TribeId], s.[RegionId], s.[ResidentialAddress], s.[Title],
				s.[JobTitle], s.[EmployeeSince], s.[EducationLevel], s.[EducationSublevel], s.[BankId], s.[BankAccountNumber], s.[NumberOfChildren],
				@Now, @UserId, @Now, @UserId)
		OUTPUT s.[Index], inserted.[Id] 
	) AS x;
	/*	[BasicSalary]				MONEY,
	[TransporationAllowance]	MONEY,
	[OvertimeRate]				MONEY, */
	SELECT @IndexedIdsJson = (SELECT * FROM @IndexedIds	FOR JSON PATH);