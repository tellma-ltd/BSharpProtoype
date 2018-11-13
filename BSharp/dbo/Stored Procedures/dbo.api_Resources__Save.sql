CREATE PROCEDURE [dbo].[api_Resources__Save]
	@Resources [ResourceList] READONLY
AS
BEGIN
	BEGIN TRY
		DECLARE @IdMappings IdMappingList, @TenantId int;
		SELECT @TenantId = dbo.fn_TenantId();
		IF @TenantId IS NULL
			THROW 50001, N'Tenant Id is NULL', 1;

		BEGIN TRANSACTION
			DELETE FROM dbo.Resources WHERE TenantId = @TenantId AND Id IN (SELECT Id FROM @Resources WHERE Status = N'Deleted');

			INSERT INTO @IdMappings([NewId], [OldId])
			SELECT x.[NewId], x.[OldId]
			FROM
			(
				MERGE INTO dbo.Resources AS t
				USING (
					SELECT @TenantId As [TenantId], [Id], [ResourceType], [Name], [Code], [UnitOfMeasure], [Memo], [Lookup1], [Lookup2], [Lookup3], [Lookup4], [GoodForServiceParentId], [FungibleParentId]
					FROM @Resources 
					WHERE [Status] IN (N'Inserted', N'Updated')
				) AS s ON t.[TenantId] = s.[TenantId] AND t.Id = s.Id
				WHEN MATCHED THEN
					UPDATE SET 
						t.[ResourceType]			= s.[ResourceType],         
						t.[Name]					= s.[Name],                   
						t.[Code]					= s.[Code],
						t.[UnitOfMeasure]			= s.[UnitOfMeasure],
						t.[Memo]					= s.[Memo],             
						t.[Lookup1]					= s.[Lookup1],
						t.[Lookup2]					= s.[Lookup2],
						t.[Lookup3]					= s.[Lookup3],
						t.[Lookup4]					= s.[Lookup4],
						t.[GoodForServiceParentId]	= s.[GoodForServiceParentId],
						t.[FungibleParentId]		= s.[FungibleParentId]
				WHEN NOT MATCHED THEN
					INSERT ([TenantId], [ResourceType],		[Name],	[Code], [UnitOfMeasure],	 [Memo],	[Lookup1],	[Lookup2],	[Lookup3],		[Lookup4], [GoodForServiceParentId], [FungibleParentId])
					VALUES (@TenantId, s.[ResourceType], s.[Name], s.[Code], s.[UnitOfMeasure], s.[Memo], s.[Lookup1], s.[Lookup2], s.[Lookup3], s.[Lookup4], s.[GoodForServiceParentId], s.[FungibleParentId])
				--WHEN NOT MATCHED BY SOURCE THEN 
				--	DELETE
				OUTPUT inserted.[Id] As [NewId], s.[Id] As [OldId]
			) AS x;
			PRINT N'Parent Id in table Resources is lost. Additional code is needed to fix it. Will be fixed once we agree it is necessary'
			/*
			UPDATE O
			SET O.[Parent] = 
			FROM dbo.Resources O 
			JOIN @Resources OL ON O.Id = OL.Parent
			JOIN @IdMappings M ON OL.Id = M.OldId
			JOIN dbo.Resources O2 ON M.NewId = O2.Id
			*/
		COMMIT TRANSACTION;
	END TRY

	BEGIN CATCH
		EXEC dbo.Error__Log;
		THROW;
	END CATCH
	
	SELECT R.[Id], R.[ResourceType], R.[Name], R.[Code], R.[UnitOfMeasure], R.[Memo], R.[Lookup1], R.[Lookup2], R.[Lookup3], R.[Lookup4], R.[GoodForServiceParentId], R.[FungibleParentId], N'Unchanged' As [Status], M.[OldId] As [TemporaryId]
	FROM dbo.Resources R
	LEFT JOIN @IdMappings M ON R.[Id] = M.[NewId]
	WHERE R.[TenantId] = @TenantId
	AND R.[Id] IN (
		SELECT M.[NewId] FROM @Resources R JOIN @IdMappings M ON R.Id = M.OldId WHERE [Status] = N'Inserted'
		UNION ALL
		SELECT Id FROM @Resources WHERE [Status] = N'Updated'
		);
END