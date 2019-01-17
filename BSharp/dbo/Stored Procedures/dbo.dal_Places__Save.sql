﻿CREATE PROCEDURE [dbo].[dal_Places__Save]
	@Entities [PlaceList] READONLY,
	@IndexedIdsJson NVARCHAR(MAX) OUTPUT
AS
	DECLARE @IndexedIds [dbo].[IndexedIdList];
	DECLARE @TenantId int = CONVERT(INT, SESSION_CONTEXT(N'TenantId'));
	DECLARE @Now DATETIMEOFFSET(7) = SYSDATETIMEOFFSET();
	DECLARE @UserId NVARCHAR(450) = CONVERT(NVARCHAR(450), SESSION_CONTEXT(N'UserId'));

-- Deletions
	DELETE FROM [dbo].[Custodies]
	WHERE [Id] IN (SELECT [Id] FROM @Entities WHERE [EntityState] = N'Deleted');

	INSERT INTO @IndexedIds([Index], [Id])
	SELECT x.[Index], x.[Id]
	FROM
	(
		MERGE INTO [dbo].[Custodies] AS t
		USING (
			SELECT [Index], [Id], [PlaceType], [Name], [Code], [Address], [BirthDateTime]
			FROM @Entities 
			WHERE [EntityState] IN (N'Inserted', N'Updated')
		) AS s ON (t.Id = s.Id)
		WHEN MATCHED
		THEN
			UPDATE SET 
				t.[Name]			= s.[Name],
				t.[Code]			= s.[Code],
				t.[Address]			= s.[Address],
				t.[BirthDateTime]	= s.[BirthDateTime],
				t.[ModifiedAt]		= @Now,
				t.[ModifiedBy]		= @UserId
		WHEN NOT MATCHED THEN
			INSERT ([TenantId], [CustodyType], [Name], [Code], [Address], [BirthDateTime], [CreatedAt], [CreatedBy], [ModifiedAt], [ModifiedBy])
			VALUES (@TenantId, s.[PlaceType], s.[Name], s.[Code], s.[Address], s.[BirthDateTime], @Now, @UserId, @Now, @UserId)
		OUTPUT s.[Index], inserted.[Id] 
	) AS x;

	MERGE INTO [dbo].Places t
	USING (
		SELECT L.[Id], [PlaceType], [CustodianId],
				II.[Id] As [InsertedId]
		FROM @Entities L
		JOIN @IndexedIds II ON L.[Index] = II.[Index]
		WHERE [EntityState] IN (N'Inserted', N'Updated')
	) AS s ON (t.Id = s.Id)
	WHEN MATCHED THEN
		UPDATE SET
			t.[Id]						= s.[Id],
			t.[CustodianId]				= s.[CustodianId]
	WHEN NOT MATCHED THEN
		INSERT ([TenantId], [Id],			[PlaceType],	[CustodianId])
		VALUES (@TenantId, s.[InsertedId], s.[PlaceType], s.[CustodianId]);
	
	SELECT @IndexedIdsJson = (SELECT * FROM @IndexedIds FOR JSON PATH);