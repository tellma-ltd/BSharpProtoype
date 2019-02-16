CREATE PROCEDURE [dbo].[dal_Agents__Save]
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
			SELECT [Index], [Id], [PersonType], [Name], [Name2], [Code], [SystemCode], [Address], [BirthDateTime], [IsRelated], [TaxIdentificationNumber], [Title], [Gender]
			FROM @Entities 
			WHERE [EntityState] IN (N'Inserted', N'Updated')
		) AS s ON (t.Id = s.Id)
		WHEN MATCHED
		THEN
			UPDATE SET 
				t.[Name]			= s.[Name],
				t.[Name2]			= s.[Name2],
				t.[Code]			= s.[Code],

				t.[BirthDateTime]	= s.[BirthDateTime],

				t.[IsRelated]		= s.[IsRelated],
				t.[TaxIdentificationNumber] = s.[TaxIdentificationNumber],
				t.[Title]			= s.[Title],
				t.[Gender]			= s.[Gender],

				t.[ModifiedAt]		= @Now,
				t.[ModifiedById]	= @UserId
		WHEN NOT MATCHED THEN
			INSERT ([TenantId], [RelationType], [PersonType], [Name], [Name2], [Code], [SystemCode], [BirthDateTime], [IsRelated], [TaxIdentificationNumber], [Title], [Gender], [CreatedAt], [CreatedById], [ModifiedAt], [ModifiedById])
			VALUES (@TenantId, N'Agent',	s.[PersonType], s.[Name], s.[Name2], s.[Code], s.[SystemCode], s.[BirthDateTime], s.[IsRelated], s.[TaxIdentificationNumber], s.[Title], s.[Gender], @Now, @UserId, @Now, @UserId)
		OUTPUT s.[Index], inserted.[Id] 
	) AS x;
	
	SELECT @IndexedIdsJson = (SELECT * FROM @IndexedIds	FOR JSON PATH);