CREATE PROCEDURE [dbo].[dal_Locations__Save]
	@Locations [LocationForSaveList] READONLY,
	@IndexedIdsJson  NVARCHAR(MAX) OUTPUT
AS
	DECLARE @IndexedIds [dbo].[IndexedIdList];
	DECLARE @TenantId int = CONVERT(INT, SESSION_CONTEXT(N'TenantId'));
	DECLARE @Now DATETIMEOFFSET(7) = SYSDATETIMEOFFSET();
	DECLARE @UserId NVARCHAR(450) = CONVERT(NVARCHAR(450), SESSION_CONTEXT(N'UserId'));

-- Deletions
	DELETE FROM [dbo].Custodies
	WHERE Id IN (SELECT Id FROM @Locations WHERE [EntityState] = N'Deleted');

-- Updates
	MERGE INTO [dbo].Custodies AS t
	USING (
		SELECT [Id], [LocationType], [Name], [Code], [Address], [BirthDateTime]
		FROM @Locations 
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

	MERGE INTO [dbo].Locations t
	USING (
		SELECT [Id], [LocationType], [CustodianId]
		FROM @Locations
		WHERE [EntityState] = N'Updated'
	) AS s ON (t.Id = s.Id)
	WHEN MATCHED THEN
		UPDATE SET
			t.[Id]				= s.[Id],
			t.[LocationType]	= s.[LocationType],
			t.[CustodianId]		= s.[CustodianId];

-- Inserts
	INSERT INTO @IndexedIds([Index], [Id])
	SELECT x.[Index], x.[Id]
	FROM
	(
		MERGE INTO [dbo].Custodies AS t
		USING (
			SELECT [Index], [Id], [LocationType], [Name], [Code], [Address], [BirthDateTime]
			FROM @Locations 
			WHERE [EntityState] = N'Inserted'
		) AS s ON (t.Id = s.Id)
		WHEN NOT MATCHED THEN
			INSERT ([TenantId], [CustodyType], [Name], [Code], [Address], [BirthDateTime], [CreatedAt], [CreatedBy], [ModifiedAt], [ModifiedBy])
			VALUES (@TenantId, s.[LocationType], s.[Name], s.[Code], s.[Address], s.[BirthDateTime], @Now, @UserId, @Now, @UserId)
		OUTPUT s.[Index], inserted.[Id] 
	) AS x;

	MERGE INTO [dbo].Locations t
	USING (
		SELECT I.[Id], [LocationType], [Address], [CustodianId],
				M.[Id] As [InsertedId]
		FROM @Locations I 
		JOIN @IndexedIds M ON I.[Index] = M.[Index]
		WHERE [EntityState] = N'Inserted'
	) AS s ON (t.Id = s.Id)
	WHEN NOT MATCHED THEN
		INSERT ([TenantId], [Id],			[LocationType], [CustodianId])
		VALUES (@TenantId, s.[InsertedId], s.[LocationType], s.[CustodianId]);
	
	SELECT @IndexedIdsJson =
	(
		SELECT [Index], [Id] FROM @IndexedIds
		FOR JSON AUTO
	);