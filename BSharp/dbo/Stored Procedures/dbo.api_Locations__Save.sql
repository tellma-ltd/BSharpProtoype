CREATE PROCEDURE [dbo].[api_Locations__Save]
	@Locations [LocationList] READONLY
AS
BEGIN
	DECLARE @IdMappings IdMappingList;
	BEGIN TRANSACTION
		BEGIN TRY

			DELETE FROM dbo.Custodies WHERE Id IN (SELECT Id FROM @Locations WHERE Status = N'Deleted');

			INSERT INTO @IdMappings([NewId], [OldId])
			SELECT x.[NewId], x.[OldId]
			FROM
			(
				MERGE INTO dbo.Custodies AS t
				USING (
					SELECT [Id], [LocationType], [Name], [IsActive] 
					FROM @Locations 
					WHERE [Status] IN (N'Inserted', N'Updated')
				) AS s ON t.Id = s.Id
				WHEN MATCHED THEN
					UPDATE SET 
						t.[Name] = s.[Name],
						t.[IsActive] = s.[IsActive]
				WHEN NOT MATCHED THEN
					INSERT ([CustodyType], [Name], [IsActive])
					VALUES (s.[LocationType], s.[Name], s.[IsActive])
				--WHEN NOT MATCHED BY SOURCE THEN 
				--	DELETE
				OUTPUT inserted.[Id] As [NewId], s.[Id] As [OldId]
			) AS x;

			MERGE INTO dbo.Locations t
			USING (
				SELECT M.[NewId] As [Id], [LocationType], [Address], [Parent], [Custodian]
				FROM @Locations I 
				JOIN @IdMappings M ON I.Id = M.OldId
			) As s ON t.Id = s.Id
			WHEN MATCHED THEN
				UPDATE SET
					t.[Id]						= s.[Id],
					t.[Address]					= s.[Address],
					t.[Parent]					= s.[Parent],      
					t.[Custodian]				= s.[Custodian]
			WHEN NOT MATCHED THEN
				INSERT ([Id], [LocationType],		[Address] ,	[Parent],	[Custodian])
				VALUES (s.[Id], s.[LocationType], s.[Address], s.[Parent], s.[Custodian]);

				--WHEN NOT MATCHED BY SOURCE THEN 
				--	DELETE
		END TRY

		BEGIN CATCH
			SELECT   /*
			ERROR_NUMBER() AS ErrorNumber  
			,ERROR_SEVERITY() AS ErrorSeverity  
			,ERROR_STATE() AS ErrorState  
			, */ERROR_PROCEDURE() AS ErrorProcedure  
			,ERROR_LINE() AS ErrorLine  
			,ERROR_MESSAGE() AS ErrorMessage; 

			IF @@TRANCOUNT > 0 
			ROLLBACK TRANSACTION;
		END CATCH

	IF @@TRANCOUNT > 0  
    COMMIT TRANSACTION;
	
	SELECT C.[Id], L.[LocationType], C.[Name], C.[IsActive], L.[Address], L.[Parent], L.[Custodian], N'Unchanged' As Status, M.[OldId] As [TemporaryId]
	FROM dbo.Custodies C JOIN dbo.Locations L ON C.Id = L.Id
	LEFT JOIN @IdMappings M ON C.[Id] = M.[NewId]
	WHERE C.[Id] IN (
		SELECT M.[NewId] FROM @Locations L JOIN @IdMappings M ON L.Id = M.OldId WHERE [Status] = N'Inserted'
		UNION ALL
		SELECT Id FROM @Locations WHERE [Status] = N'Updated');
END