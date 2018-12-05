﻿CREATE PROCEDURE [dbo].[dal_Agents__Save]
	@Agents [AgentForSaveList] READONLY,
	@IndexedIdsJson  NVARCHAR(MAX) OUTPUT
AS
	DECLARE @IndexedIds [dbo].[IndexedIdList];
	DECLARE @TenantId int = CONVERT(INT, SESSION_CONTEXT(N'TenantId'));
	DECLARE @Now DATETIMEOFFSET(7) = SYSDATETIMEOFFSET();
	DECLARE @UserId NVARCHAR(450) = CONVERT(NVARCHAR(450), SESSION_CONTEXT(N'UserId'));

-- Deletions
	DELETE FROM [dbo].Custodies
	WHERE Id IN (SELECT Id FROM @Agents WHERE [EntityState] = N'Deleted');

-- Updates
	MERGE INTO [dbo].Custodies AS t
	USING (
		SELECT [Id], [AgentType], [Name], [Code], [Address], [BirthDateTime]
		FROM @Agents 
		WHERE [EntityState] = N'Updated'
	) AS s ON (t.Id = s.Id)
	WHEN MATCHED
	AND (	
		t.[Name] <> s.[Name] OR
		ISNULL(t.[Code], N'')				<> ISNULL(s.[Code], N'') OR
		ISNULL(t.[Address], N'')	<> ISNULL(s.[Address], N'') OR
		ISNULL(t.[BirthDateTime], N'')		<> ISNULL(s.[BirthDateTime], N'')
	)
	THEN
		UPDATE SET 
			t.[Name]			= s.[Name],
			t.[Code]			= s.[Code],
			t.[Address]	= s.[Address],
			t.[BirthDateTime]	= s.[BirthDateTime],
			t.[ModifiedAt]		= @Now,
			t.[ModifiedBy]		= @UserId;

	MERGE INTO [dbo].Agents t
	USING (
		SELECT [Id], [AgentType], [IsRelated], [UserId], [TaxIdentificationNumber], [Title], [Gender]
		FROM @Agents
		WHERE [EntityState] = N'Updated'
	) AS s ON (t.Id = s.Id)
	WHEN MATCHED THEN
		UPDATE SET
			t.[Id]						= s.[Id],
			t.[IsRelated]				= s.[IsRelated],
			t.[UserId]					= s.[UserId],
			t.[TaxIdentificationNumber] = s.[TaxIdentificationNumber],
			t.[Title]					= s.[Title],
			t.[Gender]					= s.[Gender];

-- Inserts
	INSERT INTO @IndexedIds([Index], [Id])
	SELECT x.[Index], x.[Id]
	FROM
	(
		MERGE INTO [dbo].Custodies AS t
		USING (
			SELECT [Index], [Id], [AgentType], [Name], [Code], [Address], [BirthDateTime]
			FROM @Agents 
			WHERE [EntityState] = N'Inserted'
		) AS s ON (t.Id = s.Id)
		WHEN NOT MATCHED THEN
			INSERT ([TenantId], [CustodyType], [Name], [Code], [Address], [BirthDateTime], [CreatedAt], [CreatedBy], [ModifiedAt], [ModifiedBy])
			VALUES (@TenantId, s.[AgentType], s.[Name], s.[Code], s.[Address], s.[BirthDateTime], @Now, @UserId, @Now, @UserId)
		OUTPUT s.[Index], inserted.[Id] 
	) AS x;

	MERGE INTO [dbo].Agents t
	USING (
		SELECT I.[Id], [AgentType], [IsRelated] , [UserId], [TaxIdentificationNumber], [Title], [Gender],
				M.[Id] As [InsertedId]
		FROM @Agents I 
		JOIN @IndexedIds M ON I.[Index] = M.[Index]
		WHERE [EntityState] = N'Inserted'
	) AS s ON (t.Id = s.Id)
	WHEN NOT MATCHED THEN
		INSERT ([TenantId], [Id],			[AgentType],	[IsRelated],	[UserId],	[TaxIdentificationNumber], [Title], [Gender])
		VALUES (@TenantId, s.[InsertedId], s.[AgentType], s.[IsRelated], s.[UserId], s.[TaxIdentificationNumber], s.[Title], s.[Gender]);
	
	SELECT @IndexedIdsJson =
	(
		SELECT [Index], [Id] FROM @IndexedIds
		FOR JSON AUTO
	);